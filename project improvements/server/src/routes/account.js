// Account settings, order history and the admin statistics (replaces account.php).
import { Router } from 'express';
import bcrypt from 'bcryptjs';
import { hasErrors, validateDeleteAccount, validatePasswordChange, validateProfile } from '@novel/shared';
import { all, get, run, transaction } from '../db.js';
import { fail, fieldErrors, raw, requireLogin, str } from '../lib.js';
import { deleteUpload, imageField, saveImage } from '../uploads.js';

const router = Router();
router.use('/account', requireLogin);

const passwordMatches = (userId, password) =>
    bcrypt.compareSync(password, get('SELECT password_hash FROM users WHERE id = ?', userId).password_hash);

router.get('/account', (req, res) => {
    const userId = req.user.id;
    const user = get('SELECT id, username, email, photo, role, created_at FROM users WHERE id = ?', userId);
    const summary = get(
        `SELECT (SELECT COUNT(*) FROM books WHERE user_id = ?) AS books_written,
                (SELECT COUNT(*) FROM reviews WHERE user_id = ?) AS reviews_written,
                (SELECT COUNT(*) FROM reading_list WHERE user_id = ? AND in_library = 1) AS library_size,
                (SELECT COUNT(DISTINCT oi.book_id) FROM orders o JOIN order_items oi ON oi.order_id = o.id
                  WHERE o.user_id = ? AND o.status = 'success') AS books_owned`,
        userId, userId, userId, userId,
    );
    const orders = all(
        `SELECT o.id, o.total, o.status, o.created_at, group_concat(b.title, ', ' ORDER BY b.title) AS titles
         FROM orders o JOIN order_items oi ON oi.order_id = o.id JOIN books b ON b.id = oi.book_id
         WHERE o.user_id = ?
         GROUP BY o.id
         ORDER BY o.created_at DESC, o.id DESC`,
        userId,
    );

    // ---- ADMIN STATISTICS (grouping and aggregation) ----
    let admin = null;
    if (user.role === 'admin') {
        admin = {
            totals: get(
                `SELECT (SELECT COUNT(*) FROM users) AS users,
                        (SELECT COUNT(*) FROM books) AS books,
                        (SELECT COUNT(*) FROM chapters) AS chapters,
                        (SELECT COUNT(*) FROM reviews) AS reviews,
                        (SELECT COALESCE(SUM(views), 0) FROM book_views_daily WHERE view_date >= date('now', 'localtime', '-6 days')) AS views_week,
                        (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status = 'success') AS revenue`,
            ),
            bestSellers: all(
                `SELECT b.id, b.title, COUNT(*) AS copies, SUM(oi.price) AS revenue
                 FROM order_items oi
                 JOIN orders o ON o.id = oi.order_id AND o.status = 'success'
                 JOIN books b ON b.id = oi.book_id
                 GROUP BY b.id
                 ORDER BY revenue DESC
                 LIMIT 10`,
            ),
            dailyOrders: all(
                `SELECT date(created_at) AS day,
                        SUM(status = 'success') AS successful,
                        SUM(status = 'failed') AS failed,
                        SUM(CASE WHEN status = 'success' THEN total ELSE 0 END) AS revenue
                 FROM orders
                 WHERE created_at >= date('now', 'localtime', '-6 days')
                 GROUP BY date(created_at)
                 ORDER BY day DESC`,
            ),
            genreStats: all(
                `SELECT g.name, COUNT(b.id) AS books, COALESCE(SUM(b.views), 0) AS views,
                        (SELECT AVG(r.rating) FROM reviews r JOIN books b2 ON b2.id = r.book_id WHERE b2.genre_id = g.id) AS avg_rating
                 FROM genres g
                 LEFT JOIN books b ON b.genre_id = g.id
                 GROUP BY g.id
                 ORDER BY views DESC`,
            ),
            feedback: all('SELECT name, email, subject, message, created_at FROM feedback ORDER BY created_at DESC, id DESC LIMIT 5'),
        };
    }

    res.json({ user, summary, orders, admin });
});

// ---- PROFILE PHOTO ----
router.post('/account/photo', imageField('photo'), (req, res) => {
    if (!req.file) return fieldErrors(res, { photo: 'Choose an image to upload.' });
    const result = saveImage(req.file, 'avatars');
    if (result.error) return fieldErrors(res, { photo: result.error });
    run('UPDATE users SET photo = ? WHERE id = ?', result.path, req.user.id);
    deleteUpload(req.user.photo);  // remove the old upload
    res.json({ message: 'Your profile photo has been updated.', photo: result.path });
});

// ---- USERNAME / EMAIL ----
router.put('/account/profile', (req, res) => {
    const values = { username: str(req.body.username), email: str(req.body.email) };
    const errors = validateProfile(values);
    if (!errors.username && get('SELECT 1 FROM users WHERE username = ? AND id <> ?', values.username, req.user.id)) {
        errors.username = 'That username is already taken.';
    }
    if (!errors.email && get('SELECT 1 FROM users WHERE email = ? AND id <> ?', values.email, req.user.id)) {
        errors.email = 'Another account already uses that email.';
    }
    if (hasErrors(errors)) return fieldErrors(res, errors);
    run('UPDATE users SET username = ?, email = ? WHERE id = ?', values.username, values.email, req.user.id);
    res.json({ message: 'Your details have been updated.' });
});

// ---- CHANGE PASSWORD ----
router.put('/account/password', (req, res) => {
    const values = { current: raw(req.body.current), password: raw(req.body.password), confirm: raw(req.body.confirm) };
    const errors = validatePasswordChange(values);
    if (!errors.current && !passwordMatches(req.user.id, values.current)) {
        errors.current = 'Your current password is incorrect.';
    }
    if (hasErrors(errors)) return fieldErrors(res, errors);
    run('UPDATE users SET password_hash = ? WHERE id = ?', bcrypt.hashSync(values.password, 10), req.user.id);
    res.json({ message: 'Your password has been changed.' });
});

// ---- DELETE ACCOUNT ----
router.delete('/account', (req, res) => {
    if (req.user.role === 'admin') return fail(res, 403, 'The admin account cannot be deleted.');
    const values = { password: raw(req.body.password), confirm: req.body.confirm === true };
    const errors = validateDeleteAccount(values);
    if (!errors.password && !passwordMatches(req.user.id, values.password)) {
        errors.password = 'Your password is incorrect.';
    }
    if (hasErrors(errors)) return fieldErrors(res, errors);

    transaction(() => {
        // keep the member's books on the site by handing them to the admin account
        const adminId = get("SELECT id FROM users WHERE role = 'admin' ORDER BY id LIMIT 1").id;
        run('UPDATE books SET user_id = ? WHERE user_id = ?', adminId, req.user.id);
        run('DELETE FROM users WHERE id = ?', req.user.id);  // cascades to reviews, lists, cart and orders
    });
    deleteUpload(req.user.photo);
    req.session = null;
    res.json({ message: 'Your account has been deleted. Sorry to see you go!' });
});

export default router;
