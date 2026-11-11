// SQLite connection plus small query helpers (the Node version of includes/db.php).
// better-sqlite3 is synchronous, and every helper uses a prepared statement with ? placeholders,
// so user input is never pasted into the SQL text.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import Database from 'better-sqlite3';

const serverRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dbFile = process.env.DB_FILE ?? path.join(serverRoot, 'data', 'novel_portal.db');
fs.mkdirSync(path.dirname(dbFile), { recursive: true });

export const db = new Database(dbFile);
db.pragma('journal_mode = WAL');   // readers don't block the writer
db.pragma('foreign_keys = ON');    // SQLite needs this per connection for ON DELETE CASCADE

const statements = new Map();
function prepare(sql) {
    let statement = statements.get(sql);
    if (!statement) {
        statement = db.prepare(sql);
        statements.set(sql, statement);
    }
    return statement;
}

// All rows as objects
export const all = (sql, ...params) => prepare(sql).all(...params);
// First row, or null
export const get = (sql, ...params) => prepare(sql).get(...params) ?? null;
// INSERT / UPDATE / DELETE; returns { changes, lastInsertRowid }
export const run = (sql, ...params) => prepare(sql).run(...params);
// Runs fn inside BEGIN ... COMMIT (ROLLBACK if it throws)
export const transaction = (fn) => db.transaction(fn)();

// SQL snippets for the date maths MySQL did with NOW(), CURDATE() and TIMESTAMPDIFF
export const NOW = "datetime('now', 'localtime')";
export const TODAY = "date('now', 'localtime')";
export const secondsAgo = (column) => `CAST((julianday('now', 'localtime') - julianday(${column})) * 86400 AS INTEGER)`;

// Drop and recreate every table, then load the sample data
export function resetDatabase() {
    const schema = fs.readFileSync(path.join(serverRoot, 'db', 'schema.sql'), 'utf8');
    const seed = fs.readFileSync(path.join(serverRoot, 'db', 'seed.sql'), 'utf8');
    db.exec(schema);
    transaction(() => db.exec(seed));
    statements.clear();
}

// First run: create the database automatically so `npm run dev` just works
export function ensureDatabase() {
    const exists = db.prepare("SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'users'").get();
    if (!exists) {
        console.log('No database found, creating it from db/schema.sql and db/seed.sql ...');
        resetDatabase();
    }
}

export { dbFile, serverRoot };
