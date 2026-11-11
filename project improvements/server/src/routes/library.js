// Reading list: Library tab (saved books) and History tab (furthest chapter read)
// (replaces reading_list.php and list_action.php).
import { Router } from 'express';
import { all, get, NOW, run, secondsAgo } from '../db.js';
import { fail, int, requireLogin } from '../lib.js';

const router = Router();
router.use('/reading-list', requireLogin);

router.get('/reading-list', (req, res) => {
    const tab = req.query.tab === 'history' ? 'history' : 'library';
    const condition = tab === 'history' ? 'rl.last_chapter > 0' : 'rl.in_library = 1';
    const books = all(
        `SELECT b.id, b.title, b.cover, g.name AS genre, rl.last_chapter, rl.in_library,
                (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS total_chapters,
                ${secondsAgo('rl.updated_at')} AS seconds_ago
         FROM reading_list rl
         JOIN books b ON b.id = rl.book_id
         JOIN genres g ON g.id = b.genre_id
         WHERE rl.user_id = ? AND ${condition}
         ORDER BY rl.updated_at DESC`,
        req.user.id,
    );
    const counts = get(
        `SELECT COALESCE(SUM(in_library = 1), 0) AS library, COALESCE(SUM(last_chapter > 0), 0) AS history
         FROM reading_list WHERE user_id = ?`,
        req.user.id,
    );
    res.json({ tab, books, counts });
});

// Add a book to the Library tab
router.post('/reading-list', (req, res) => {
    const bookId = int(req.body.bookId);
    const book = get('SELECT title FROM books WHERE id = ?', bookId);
    if (!book) return fail(res, 404, 'That book does not exist.');
    run(`INSERT INTO reading_list (user_id, book_id, in_library) VALUES (?, ?, 1)
         ON CONFLICT (user_id, book_id) DO UPDATE SET in_library = 1, updated_at = ${NOW}`,
    req.user.id, bookId);
    res.json({ message: `"${book.title}" was added to your library.` });
});

// ?tab=library takes it off the Library tab, ?tab=history clears it from the History tab
router.delete('/reading-list/:bookId', (req, res) => {
    const bookId = int(req.params.bookId);
    const fromHistory = req.query.tab === 'history';
    const book = get('SELECT title FROM books WHERE id = ?', bookId);
    if (!book) return fail(res, 404, 'That book does not exist.');
    run(`UPDATE reading_list SET ${fromHistory ? 'last_chapter = 0' : 'in_library = 0'} WHERE user_id = ? AND book_id = ?`,
        req.user.id, bookId);
    // a row that is in neither tab is no longer needed
    run('DELETE FROM reading_list WHERE user_id = ? AND book_id = ? AND in_library = 0 AND last_chapter = 0', req.user.id, bookId);
    res.json({ message: `"${book.title}" was removed from your ${fromHistory ? 'history' : 'library'}.` });
});

export default router;
