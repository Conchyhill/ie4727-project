// Helpers shared by the route files (the Node version of includes/functions.php and auth.php).
import { FREE_CHAPTERS } from '@novel/shared';
import { get } from './db.js';

// Trimmed string from a request field, or '' when missing or not a string (e.g. ?q[]=x)
export const str = (value) => (typeof value === 'string' ? value.trim() : '');
// Untrimmed string, for passwords
export const raw = (value) => (typeof value === 'string' ? value : '');
// Whole number, or 0
export function int(value) {
    const n = Number.parseInt(value, 10);
    return Number.isFinite(n) ? n : 0;
}
// A field that may be sent once or several times (?genre=a&genre=b, or tags in a multipart form)
export const list = (value) => (value === undefined || value === null ? [] : [].concat(value)).filter((v) => typeof v === 'string' && v !== '');
// LIKE pattern that matches the text literally (escapes % and _); use with ESCAPE '\'
export const like = (text) => '%' + text.replace(/[\\%_]/g, '\\$&') + '%';
export const roundMoney = (amount) => Math.round(Number(amount) * 100) / 100;

// Send 400 with field errors: { errors: { field: message } }
export const fieldErrors = (res, errors) => res.status(400).json({ errors });
export const fail = (res, status, error) => res.status(status).json({ error });

// Members-only endpoints. The client sends guests to the login page when it gets a 401.
export function requireLogin(req, res, next) {
    if (!req.user) return fail(res, 401, 'Please log in to continue.');
    next();
}

// Has this user bought the book (in a successful order)?
export function ownsBook(userId, bookId) {
    return get(
        `SELECT 1 FROM orders o JOIN order_items oi ON oi.order_id = o.id
         WHERE o.user_id = ? AND oi.book_id = ? AND o.status = 'success' LIMIT 1`,
        userId, bookId,
    ) !== null;
}

// Free chapters, free books, the author and buyers can read; book needs id, user_id and price
export function canReadChapter(book, chapterNumber, user) {
    if (chapterNumber <= FREE_CHAPTERS || Number(book.price) === 0) return true;
    if (!user) return false;
    return user.id === book.user_id || ownsBook(user.id, book.id);
}

export function cartCount(userId) {
    return get('SELECT COUNT(*) AS n FROM cart_items WHERE user_id = ?', userId).n;
}

export const isInCart = (userId, bookId) => get('SELECT 1 FROM cart_items WHERE user_id = ? AND book_id = ?', userId, bookId) !== null;
