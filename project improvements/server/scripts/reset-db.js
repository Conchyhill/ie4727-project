// Wipes the SQLite database and reloads the sample data: npm run db:reset
import { resetDatabase, dbFile, get } from '../src/db.js';

resetDatabase();
const counts = get(`SELECT (SELECT COUNT(*) FROM users) AS users, (SELECT COUNT(*) FROM books) AS books,
                           (SELECT COUNT(*) FROM chapters) AS chapters, (SELECT COUNT(*) FROM reviews) AS reviews`);
console.log(`Database reset: ${dbFile}`);
console.log(`${counts.users} users, ${counts.books} books, ${counts.chapters} chapters, ${counts.reviews} reviews`);
