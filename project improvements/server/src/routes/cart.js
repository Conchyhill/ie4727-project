// Shopping cart and checkout (replaces cart.php and cart_action.php).
// Payment is simulated (a third-party gateway is assumed): card numbers starting with 4 are approved,
// any other valid number is declined. Card details are only validated, never stored.
import { Router } from 'express';
import { cardDigits, hasErrors, validateCheckout } from '@novel/shared';
import { all, get, run, transaction } from '../db.js';
import { cartCount, fail, fieldErrors, int, ownsBook, requireLogin, roundMoney, str } from '../lib.js';

const router = Router();
router.use(['/cart', '/orders'], requireLogin);

function cartItems(userId) {
    // Books already bought (e.g. in another tab) can't be bought twice
    run(`DELETE FROM cart_items WHERE user_id = ? AND book_id IN (
             SELECT oi.book_id FROM orders o JOIN order_items oi ON oi.order_id = o.id
             WHERE o.user_id = ? AND o.status = 'success')`, userId, userId);
    return all(
        `SELECT b.id, b.title, b.cover, b.price, u.username AS author,
                (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS chapters
         FROM cart_items ci
         JOIN books b ON b.id = ci.book_id
         JOIN users u ON u.id = b.user_id
         WHERE ci.user_id = ?
         ORDER BY ci.added_at, b.id`,
        userId,
    );
}
const sumPrices = (items) => roundMoney(items.reduce((sum, item) => sum + Number(item.price), 0));

router.get('/cart', (req, res) => {
    const items = cartItems(req.user.id);
    res.json({ items, total: sumPrices(items) });
});

router.post('/cart', (req, res) => {
    const userId = req.user.id;
    const bookId = int(req.body.bookId);
    const book = get('SELECT id, title, user_id, price FROM books WHERE id = ?', bookId);
    if (!book) return fail(res, 404, 'That book does not exist.');
    if (book.user_id === userId) return fail(res, 400, 'You are the author of this book, so you can already read all of it.');
    if (Number(book.price) === 0) return fail(res, 400, 'This book is free to read.');
    if (ownsBook(userId, bookId)) return fail(res, 400, 'You already own this book.');

    run('INSERT OR IGNORE INTO cart_items (user_id, book_id) VALUES (?, ?)', userId, bookId);
    res.json({ message: `"${book.title}" was added to your cart.`, cartCount: cartCount(userId) });
});

router.delete('/cart/:bookId', (req, res) => {
    const bookId = int(req.params.bookId);
    const book = get('SELECT title FROM books WHERE id = ?', bookId);
    run('DELETE FROM cart_items WHERE user_id = ? AND book_id = ?', req.user.id, bookId);
    res.json({ message: book ? `"${book.title}" was removed from your cart.` : 'Removed from your cart.' });
});

router.post('/cart/checkout', (req, res) => {
    const userId = req.user.id;
    const items = cartItems(userId);
    if (!items.length) return fail(res, 400, 'Your cart is empty.');

    const card = {
        cardName: str(req.body.cardName),
        cardNumber: str(req.body.cardNumber),
        expiry: str(req.body.expiry),
        cvv: str(req.body.cvv),
    };
    const errors = validateCheckout(card);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    const status = cardDigits(card.cardNumber).startsWith('4') ? 'success' : 'failed';  // simulated gateway response
    const total = sumPrices(items);
    const orderId = transaction(() => {
        const id = Number(run('INSERT INTO orders (user_id, total, status) VALUES (?, ?, ?)', userId, total, status).lastInsertRowid);
        for (const item of items) {
            run('INSERT INTO order_items (order_id, book_id, price) VALUES (?, ?, ?)', id, item.id, item.price);
            if (status === 'success') {
                // bought books go straight into the member's library
                run(`INSERT INTO reading_list (user_id, book_id, in_library) VALUES (?, ?, 1)
                     ON CONFLICT (user_id, book_id) DO UPDATE SET in_library = 1`, userId, item.id);
            }
        }
        if (status === 'success') run('DELETE FROM cart_items WHERE user_id = ?', userId);
        return id;
    });
    res.status(201).json({ orderId, status });
});

// Result of a checkout attempt (only the member's own orders)
router.get('/orders/:id', (req, res) => {
    const order = get('SELECT id, total, status, created_at FROM orders WHERE id = ? AND user_id = ?', int(req.params.id), req.user.id);
    if (!order) return fail(res, 404, 'Order not found.');
    order.books = all('SELECT b.id, b.title FROM order_items oi JOIN books b ON b.id = oi.book_id WHERE oi.order_id = ? ORDER BY b.title', order.id);
    res.json(order);
});

export default router;
