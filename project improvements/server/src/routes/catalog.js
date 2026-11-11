// Home page sections, lookup lists, the Info page stats and the feedback form
// (replaces index.php and the server side of info.php).
import { Router } from 'express';
import { hasErrors, validateFeedback } from '@novel/shared';
import { all, get, run, secondsAgo, TODAY } from '../db.js';
import { fieldErrors, str } from '../lib.js';

const router = Router();

router.get('/home', (req, res) => {
    const days = req.query.period === 'week' ? 6 : 0;  // today only, or today plus the previous 6 days

    // TRENDING: sum of daily views over the selected period
    const trending = all(
        `SELECT b.id, b.title, b.cover, SUM(v.views) AS period_views,
                (SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id) AS avg_rating
         FROM books b
         JOIN book_views_daily v ON v.book_id = b.id AND v.view_date >= date(${TODAY}, ?)
         GROUP BY b.id
         ORDER BY period_views DESC
         LIMIT 10`,
        `-${days} days`,
    );

    // RECENTLY UPDATED: books ordered by their newest chapter
    const recent = all(
        `SELECT b.id, b.title, b.cover, g.name AS genre, c.number, c.title AS chapter_title,
                ${secondsAgo('c.created_at')} AS seconds_ago
         FROM books b
         JOIN genres g ON g.id = b.genre_id
         JOIN chapters c ON c.book_id = b.id
              AND c.number = (SELECT MAX(c2.number) FROM chapters c2 WHERE c2.book_id = b.id)
         ORDER BY c.created_at DESC
         LIMIT 8`,
    );

    // TOP GENRES: total views of all books in each genre
    const genres = all(
        `SELECT g.name, g.slug, COUNT(b.id) AS book_count, COALESCE(SUM(b.views), 0) AS total_views
         FROM genres g
         LEFT JOIN books b ON b.genre_id = g.id
         GROUP BY g.id
         ORDER BY total_views DESC`,
    );

    res.json({ trending, recent, genres });
});

// Genres, tags and languages for the Browse filters and the Create form
router.get('/meta', (req, res) => {
    res.json({
        genres: all('SELECT id, name, slug FROM genres ORDER BY name'),
        tags: all('SELECT id, name FROM tags ORDER BY name'),
        bookLanguages: all('SELECT DISTINCT language FROM books ORDER BY language').map((row) => row.language),
    });
});

router.get('/info/stats', (req, res) => {
    res.json(get(`SELECT (SELECT COUNT(*) FROM books) AS books, (SELECT COUNT(*) FROM chapters) AS chapters,
                         (SELECT COUNT(*) FROM users) AS members, (SELECT COUNT(*) FROM genres) AS genres`));
});

router.post('/feedback', (req, res) => {
    const values = {
        name: str(req.body.name),
        email: str(req.body.email),
        subject: str(req.body.subject),
        message: str(req.body.message),
    };
    const errors = validateFeedback(values);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    run('INSERT INTO feedback (name, email, subject, message) VALUES (?, ?, ?, ?)',
        values.name, values.email, values.subject, values.message);
    // The PHP version also mail()s webmaster@localhost. Here the message is saved to the database
    // and shown to the admin on the Account page; the console line stands in for the local mailbox.
    console.log(`[feedback] ${values.subject} from ${values.name} <${values.email}>`);
    res.status(201).json({ message: `Thanks for your feedback, ${values.name}! Our team will read it soon.` });
});

export default router;
