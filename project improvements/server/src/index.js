// Express server: the JSON API under /api, uploaded images under /uploads,
// and (after `npm run build`) the React app itself.
import fs from 'node:fs';
import path from 'node:path';
import express from 'express';
import cookieParser from 'cookie-parser';
import cookieSession from 'cookie-session';
import { ensureDatabase, get, serverRoot } from './db.js';
import { UPLOAD_ROOT } from './uploads.js';
import authRoutes from './routes/auth.js';
import catalogRoutes from './routes/catalog.js';
import bookRoutes from './routes/books.js';
import libraryRoutes from './routes/library.js';
import cartRoutes from './routes/cart.js';
import accountRoutes from './routes/account.js';

const PORT = Number(process.env.PORT ?? 3001);
const SESSION_SECRET = process.env.SESSION_SECRET ?? 'dev-only-secret-change-me';

ensureDatabase();

const app = express();
app.disable('x-powered-by');
app.use(express.json({ limit: '1mb' }));
app.use(cookieParser());
// The session is a signed cookie holding only the user id (httpOnly, so page scripts can't read it).
// SameSite=Lax means other sites can't send requests with it, which blocks cross-site form posts.
app.use(cookieSession({
    name: 'novel_session',
    secret: SESSION_SECRET,
    httpOnly: true,
    sameSite: 'lax',
    maxAge: 7 * 24 * 3600 * 1000,
}));

// Logged-in user's row on every request, or null for guests (current_user() in PHP)
app.use((req, res, next) => {
    req.body ??= {};
    req.user = null;
    if (req.session?.userId) {
        req.user = get('SELECT id, username, email, photo, role FROM users WHERE id = ?', req.session.userId);
        if (!req.user) req.session = null;  // account was deleted
    }
    next();
});

app.use('/uploads', express.static(UPLOAD_ROOT, { fallthrough: false, maxAge: '7d' }));
app.use('/api', authRoutes, catalogRoutes, bookRoutes, libraryRoutes, cartRoutes, accountRoutes);
app.use('/api', (req, res) => res.status(404).json({ error: 'Not found.' }));

// Production: serve the built React app, and send every other GET to index.html so client-side routes work
const clientBuild = path.resolve(serverRoot, '../client/dist');
if (fs.existsSync(clientBuild)) {
    app.use(express.static(clientBuild));
    app.use((req, res, next) => (req.method === 'GET' ? res.sendFile(path.join(clientBuild, 'index.html')) : next()));
}

// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
    const status = err.status ?? err.statusCode ?? 500;
    if (status >= 500) console.error(err);
    const message = status === 404 ? 'Not found.' : status < 500 ? 'The request could not be read.' : 'Something went wrong on the server.';
    res.status(status).json({ error: message });
});

app.listen(PORT, () => {
    console.log(`API server on http://localhost:${PORT}`);
    if (fs.existsSync(clientBuild)) console.log(`Serving the built client from ${clientBuild}`);
});
