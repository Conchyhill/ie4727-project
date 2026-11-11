// Books: browse/search, book details, reviews, the chapter reader, and creating/editing/deleting books
// and chapters (replaces browse.php, book.php, read.php, create.php and delete_action.php).
// Who may delete: a book -> its author or the admin, only while nobody has bought it;
// a chapter -> the author or the admin; a review -> its writer or the admin. Only authors edit.
import { Router } from 'express';
import { hasErrors, normaliseSerial, SORTS, validateBook, validateChapter, validateReview } from '@novel/shared';
import { all, get, NOW, run, TODAY, transaction } from '../db.js';
import { canReadChapter, fail, fieldErrors, int, isInCart, like, list, ownsBook, requireLogin, str } from '../lib.js';
import { deleteUpload, imageField, saveImage } from '../uploads.js';

const router = Router();
const PER_PAGE = 10;
const AVG_RATING = '(SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id)';
const SALES = `(SELECT COUNT(*) FROM order_items oi JOIN orders o ON o.id = oi.order_id
                WHERE oi.book_id = b.id AND o.status = 'success')`;

// Successful sales of a book; a sold book can't be deleted (buyers would lose it)
const salesOf = (bookId) => get(`SELECT ${SALES} AS n FROM books b WHERE b.id = ?`, bookId)?.n ?? 0;
const isAdmin = (user) => user?.role === 'admin';
// The author or the admin may delete the book and its chapters
const canManage = (book, user) => user !== null && (user.id === book.user_id || isAdmin(user));

// ------------------------------------------------------------------ browse and search

// GET /api/books?q=&genre=fantasy&genre=action&status=&sort=&page=  (+ serial, author, language for members)
router.get('/books', (req, res) => {
    const q = str(req.query.q);
    const genres = list(req.query.genre);
    const status = ['ongoing', 'completed'].includes(req.query.status) ? req.query.status : 'all';
    const sort = Object.hasOwn(SORTS, str(req.query.sort)) ? str(req.query.sort) : 'views';

    // Members-only fields are ignored for guests (Theme 6: registered users search by serial number)
    const member = req.user !== null;
    const serialText = member ? str(req.query.serial) : '';
    const serial = serialText ? normaliseSerial(serialText) || serialText.toUpperCase() : '';
    const author = member ? str(req.query.author) : '';
    const language = member ? str(req.query.language) : '';

    // ---- WHERE clause with placeholders ----
    const where = [];
    const params = [];
    if (q) {
        where.push("(b.title LIKE ? ESCAPE '\\' OR b.synopsis LIKE ? ESCAPE '\\' OR u.username LIKE ? ESCAPE '\\')");
        params.push(like(q), like(q), like(q));
    }
    if (genres.length) {
        where.push(`g.slug IN (${genres.map(() => '?').join(', ')})`);
        params.push(...genres);
    }
    if (status !== 'all') {
        where.push('b.status = ?');
        params.push(status);
    }
    if (serial) {
        where.push('b.serial_no = ?');
        params.push(serial);
    }
    if (author) {
        where.push("u.username LIKE ? ESCAPE '\\'");
        params.push(like(author));
    }
    if (language) {
        where.push('b.language = ?');
        params.push(language);
    }
    const whereSql = where.length ? 'WHERE ' + where.join(' AND ') : '';
    const from = 'FROM books b JOIN users u ON u.id = b.user_id JOIN genres g ON g.id = b.genre_id';

    const total = get(`SELECT COUNT(*) AS n ${from} ${whereSql}`, ...params).n;
    const pages = Math.max(1, Math.ceil(total / PER_PAGE));
    const page = Math.min(Math.max(1, int(req.query.page)), pages);

    const orderBy = {
        views: 'b.views DESC',
        updated: 'last_update IS NULL, last_update DESC',
        rating: 'avg_rating IS NULL, avg_rating DESC, b.views DESC',
    }[sort];

    const books = all(
        `SELECT b.id, b.serial_no, b.title, b.cover, b.synopsis, b.status, b.price, b.views,
                u.username AS author, g.name AS genre, ${AVG_RATING} AS avg_rating,
                (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS chapter_count,
                (SELECT MAX(c.created_at) FROM chapters c WHERE c.book_id = b.id) AS last_update
         ${from} ${whereSql}
         ORDER BY ${orderBy}
         LIMIT ? OFFSET ?`,
        ...params, PER_PAGE, (page - 1) * PER_PAGE,
    );

    // Tags for the books on this page, and which ones are already in the member's library
    const ids = books.map((b) => b.id);
    const tagsByBook = {};
    const inLibrary = new Set();
    if (ids.length) {
        const marks = ids.map(() => '?').join(', ');
        for (const row of all(`SELECT bt.book_id, t.name FROM book_tags bt JOIN tags t ON t.id = bt.tag_id
                               WHERE bt.book_id IN (${marks}) ORDER BY t.name`, ...ids)) {
            (tagsByBook[row.book_id] ??= []).push(row.name);
        }
        if (member) {
            for (const row of all(`SELECT book_id FROM reading_list WHERE user_id = ? AND in_library = 1 AND book_id IN (${marks})`,
                req.user.id, ...ids)) {
                inLibrary.add(row.book_id);
            }
        }
    }

    res.json({
        books: books.map((b) => ({ ...b, tags: tagsByBook[b.id] ?? [], inLibrary: inLibrary.has(b.id) })),
        total, page, pages, sort, member,
    });
});

// ------------------------------------------------------------------ book details and reviews

router.get('/books/:id', (req, res) => {
    const bookId = int(req.params.id);
    const book = get(
        `SELECT b.id, b.serial_no, b.title, b.user_id, b.language, b.synopsis, b.cover, b.status, b.price, b.views, b.created_at,
                u.username AS author, g.name AS genre, g.slug AS genre_slug, ${AVG_RATING} AS avg_rating,
                (SELECT COUNT(*) FROM reviews r WHERE r.book_id = b.id) AS review_count
         FROM books b JOIN users u ON u.id = b.user_id JOIN genres g ON g.id = b.genre_id
         WHERE b.id = ?`,
        bookId,
    );
    if (!book) return fail(res, 404, 'This book does not exist or has been removed.');

    const tags = all('SELECT t.name FROM book_tags bt JOIN tags t ON t.id = bt.tag_id WHERE bt.book_id = ? ORDER BY t.name', bookId);
    const chapters = all('SELECT number, title, created_at FROM chapters WHERE book_id = ? ORDER BY number', bookId);
    const reviews = all(
        `SELECT r.user_id, r.rating, r.comment, r.created_at, u.username, u.photo
         FROM reviews r JOIN users u ON u.id = r.user_id
         WHERE r.book_id = ? ORDER BY r.created_at DESC`,
        bookId,
    );

    // What this member has done with the book so far
    const user = req.user;
    const isAuthor = user !== null && user.id === book.user_id;
    const owned = user !== null && ownsBook(user.id, bookId);
    const isFree = Number(book.price) === 0;
    const manage = canManage(book, user);
    res.json({
        book,
        tags: tags.map((t) => t.name),
        chapters,
        reviews,
        viewer: {
            loggedIn: user !== null,
            isAuthor,
            isAdmin: isAdmin(user),
            canManage: manage,
            sales: manage ? salesOf(bookId) : 0,
            owned,
            isFree,
            fullAccess: isFree || isAuthor || owned,
            inCart: user !== null && isInCart(user.id, bookId),
            listRow: user && get('SELECT in_library, last_chapter FROM reading_list WHERE user_id = ? AND book_id = ?', user.id, bookId),
            myReview: (user && reviews.find((r) => r.user_id === user.id)) ?? null,
        },
    });
});

router.post('/books/:id/reviews', requireLogin, (req, res) => {
    const bookId = int(req.params.id);
    const book = get('SELECT id, user_id FROM books WHERE id = ?', bookId);
    if (!book) return fail(res, 404, 'This book does not exist.');
    if (book.user_id === req.user.id) return fail(res, 403, 'You cannot review your own book.');

    const values = { rating: int(req.body.rating), comment: str(req.body.comment) };
    const errors = validateReview(values);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    // one review per member per book: a second submit replaces the first
    run(`INSERT INTO reviews (book_id, user_id, rating, comment) VALUES (?, ?, ?, ?)
         ON CONFLICT (book_id, user_id) DO UPDATE SET rating = excluded.rating, comment = excluded.comment, created_at = ${NOW}`,
        bookId, req.user.id, values.rating, values.comment);
    res.json({ message: 'Thanks, your review has been saved.' });
});

// Delete a review: the member who wrote it, or the admin
router.delete('/books/:id/reviews/:userId', requireLogin, (req, res) => {
    const bookId = int(req.params.id);
    const reviewerId = int(req.params.userId);
    if (reviewerId !== req.user.id && !isAdmin(req.user)) return fail(res, 403, 'You can only delete your own reviews.');
    const result = run('DELETE FROM reviews WHERE book_id = ? AND user_id = ?', bookId, reviewerId);
    if (result.changes === 0) return fail(res, 404, 'That review does not exist.');
    res.json({ message: reviewerId === req.user.id ? 'Your review has been deleted.' : 'The review has been deleted.' });
});

// ------------------------------------------------------------------ reader

// Each read adds a view (all-time and today's count) and updates the member's reading progress
router.get('/books/:id/chapters/:number', (req, res) => {
    const bookId = int(req.params.id);
    const number = Math.max(1, int(req.params.number));
    const book = get('SELECT id, title, user_id, price FROM books WHERE id = ?', bookId);
    const chapter = book && get('SELECT number, title, content, created_at FROM chapters WHERE book_id = ? AND number = ?', bookId, number);
    if (!chapter) {
        return res.status(404).json({ error: 'This chapter does not exist.', book: book && { id: book.id, title: book.title } });
    }

    const chapters = all('SELECT number, title FROM chapters WHERE book_id = ? ORDER BY number', bookId);
    const canRead = canReadChapter(book, number, req.user);
    if (canRead) {
        transaction(() => {
            run('UPDATE books SET views = views + 1 WHERE id = ?', bookId);
            run(`INSERT INTO book_views_daily (book_id, view_date, views) VALUES (?, ${TODAY}, 1)
                 ON CONFLICT (book_id, view_date) DO UPDATE SET views = views + 1`, bookId);
            if (req.user) {
                // History keeps the furthest chapter reached; reading doesn't add the book to the Library tab
                run(`INSERT INTO reading_list (user_id, book_id, in_library, last_chapter) VALUES (?, ?, 0, ?)
                     ON CONFLICT (user_id, book_id) DO UPDATE SET last_chapter = MAX(last_chapter, excluded.last_chapter), updated_at = ${NOW}`,
                    req.user.id, bookId, number);
            }
        });
    }

    res.json({
        book: { id: book.id, title: book.title, price: book.price },
        chapter: { ...chapter, content: canRead ? chapter.content : null },
        chapters,
        canRead,
        isAuthor: req.user !== null && req.user.id === book.user_id,
        loggedIn: req.user !== null,
        inCart: req.user !== null && isInCart(req.user.id, bookId),
    });
});

// ------------------------------------------------------------------ create / edit (members)

// A book the current member wrote, or null
const ownBook = (bookId, userId) => get('SELECT * FROM books WHERE id = ? AND user_id = ?', bookId, userId);

// Read and check the book form; returns { values, errors }
function readBookForm(req, editId) {
    const validTagIds = all('SELECT id FROM tags').map((t) => t.id);
    const values = {
        title: str(req.body.title),
        genreId: int(req.body.genreId),
        language: str(req.body.language),
        status: str(req.body.status),
        price: str(req.body.price),
        synopsis: str(req.body.synopsis),
        tags: [...new Set(list(req.body.tags).map(Number))],
    };
    const errors = validateBook(values, {
        genreIds: all('SELECT id FROM genres').map((g) => g.id),
        tagIds: validTagIds,
    });
    // same title as another of this author's books?
    if (!errors.title && get('SELECT 1 FROM books WHERE user_id = ? AND title = ? COLLATE NOCASE AND id <> ?',
        req.user.id, values.title, editId)) {
        errors.title = 'You already have a book with this title.';
    }
    return { values, errors };
}

function saveTags(bookId, tagIds) {
    run('DELETE FROM book_tags WHERE book_id = ?', bookId);
    for (const tagId of tagIds) run('INSERT INTO book_tags (book_id, tag_id) VALUES (?, ?)', bookId, tagId);
}

// Optional cover upload; adds to errors and returns the stored path (or null)
function readCover(req, errors) {
    if (!req.file || hasErrors(errors)) return null;
    const result = saveImage(req.file, 'covers');
    if (result.error) errors.cover = result.error;
    return result.path ?? null;
}

// The member's own books, for the table on the Create page
router.get('/my/books', requireLogin, (req, res) => {
    res.json(all(
        `SELECT b.id, b.serial_no, b.title, b.status, b.views, g.name AS genre,
                COUNT(c.id) AS chapters, ${AVG_RATING} AS avg_rating, ${SALES} AS sales
         FROM books b
         JOIN genres g ON g.id = b.genre_id
         LEFT JOIN chapters c ON c.book_id = b.id
         WHERE b.user_id = ?
         GROUP BY b.id
         ORDER BY b.created_at DESC, b.id DESC`,
        req.user.id,
    ));
});

// New book (INSERT)
router.post('/books', requireLogin, imageField('cover'), (req, res) => {
    const { values, errors } = readBookForm(req, 0);
    const cover = readCover(req, errors);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    const bookId = transaction(() => {
        // insert with a temporary serial, then derive the real one from the new id (NB-000021)
        const result = run(
            `INSERT INTO books (serial_no, title, user_id, genre_id, language, synopsis, cover, status, price)
             VALUES ('TMP-' || hex(randomblob(4)), ?, ?, ?, ?, ?, ?, ?, ?)`,
            values.title, req.user.id, values.genreId, values.language, values.synopsis, cover, values.status, Number(values.price),
        );
        const id = Number(result.lastInsertRowid);
        run("UPDATE books SET serial_no = 'NB-' || printf('%06d', id) WHERE id = ?", id);
        saveTags(id, values.tags);
        return id;
    });
    res.status(201).json({ id: bookId, message: `"${values.title}" has been created. Now add your first chapter.` });
});

// Current values for the edit form, plus the next chapter number for the Add chapter form
router.get('/books/:id/edit', requireLogin, (req, res) => {
    const book = ownBook(int(req.params.id), req.user.id);
    if (!book) return fail(res, 403, 'You can only edit books that you have written.');
    res.json({
        id: book.id,
        title: book.title,
        genreId: book.genre_id,
        language: book.language,
        status: book.status,
        price: Number(book.price).toFixed(2),
        synopsis: book.synopsis,
        cover: book.cover,
        tags: all('SELECT tag_id FROM book_tags WHERE book_id = ?', book.id).map((t) => t.tag_id),
        nextChapter: get('SELECT COALESCE(MAX(number), 0) + 1 AS n FROM chapters WHERE book_id = ?', book.id).n,
        sales: salesOf(book.id),
    });
});

// Edit book (UPDATE)
router.put('/books/:id', requireLogin, imageField('cover'), (req, res) => {
    const book = ownBook(int(req.params.id), req.user.id);
    if (!book) return fail(res, 403, 'You can only edit books that you have written.');
    const { values, errors } = readBookForm(req, book.id);
    const cover = readCover(req, errors);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    transaction(() => {
        run(`UPDATE books SET title = ?, genre_id = ?, language = ?, synopsis = ?, status = ?, price = ?, cover = COALESCE(?, cover)
             WHERE id = ? AND user_id = ?`,
        values.title, values.genreId, values.language, values.synopsis, values.status, Number(values.price), cover,
        book.id, req.user.id);
        saveTags(book.id, values.tags);
    });
    if (cover) deleteUpload(book.cover);
    res.json({ id: book.id, message: `"${values.title}" has been updated.` });
});

// Add the next chapter (INSERT)
router.post('/books/:id/chapters', requireLogin, (req, res) => {
    const book = ownBook(int(req.params.id), req.user.id);
    if (!book) return fail(res, 403, 'You can only add chapters to books that you have written.');
    const values = { title: str(req.body.title), content: str(req.body.content) };
    const errors = validateChapter(values);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    const number = transaction(() => {
        const next = get('SELECT COALESCE(MAX(number), 0) + 1 AS n FROM chapters WHERE book_id = ?', book.id).n;
        run('INSERT INTO chapters (book_id, number, title, content) VALUES (?, ?, ?, ?)', book.id, next, values.title, values.content);
        return next;
    });
    res.status(201).json({ number, message: `Chapter ${number} of "${book.title}" has been published.` });
});

// Current text of a chapter, for the Edit chapter form (author only)
router.get('/books/:id/chapters/:number/edit', requireLogin, (req, res) => {
    const book = ownBook(int(req.params.id), req.user.id);
    if (!book) return fail(res, 403, 'You can only edit books that you have written.');
    const chapter = get('SELECT number, title, content FROM chapters WHERE book_id = ? AND number = ?', book.id, int(req.params.number));
    if (!chapter) return fail(res, 404, 'That chapter does not exist.');
    res.json({ bookId: book.id, bookTitle: book.title, ...chapter });
});

// Edit a chapter (UPDATE). The release date is kept, so an edit doesn't count as a new update on Home.
router.put('/books/:id/chapters/:number', requireLogin, (req, res) => {
    const book = ownBook(int(req.params.id), req.user.id);
    if (!book) return fail(res, 403, 'You can only edit books that you have written.');
    const number = int(req.params.number);
    if (!get('SELECT 1 FROM chapters WHERE book_id = ? AND number = ?', book.id, number)) return fail(res, 404, 'That chapter does not exist.');
    const values = { title: str(req.body.title), content: str(req.body.content) };
    const errors = validateChapter(values);
    if (hasErrors(errors)) return fieldErrors(res, errors);

    run('UPDATE chapters SET title = ?, content = ? WHERE book_id = ? AND number = ?', values.title, values.content, book.id, number);
    res.json({ number, message: `Chapter ${number} of "${book.title}" has been updated.` });
});

// Delete a chapter (author or admin). Later chapters move up one number so Previous / Next still work.
router.delete('/books/:id/chapters/:number', requireLogin, (req, res) => {
    const book = get('SELECT id, title, user_id FROM books WHERE id = ?', int(req.params.id));
    if (!book) return fail(res, 404, 'That book does not exist.');
    if (!canManage(book, req.user)) return fail(res, 403, 'You can only delete chapters of books that you have written.');
    const number = int(req.params.number);
    const chapter = get('SELECT title FROM chapters WHERE book_id = ? AND number = ?', book.id, number);
    if (!chapter) return fail(res, 404, 'That chapter does not exist.');

    transaction(() => {
        run('DELETE FROM chapters WHERE book_id = ? AND number = ?', book.id, number);
        // SQLite checks UNIQUE (book_id, number) row by row, so go through negative numbers to close the gap
        run('UPDATE chapters SET number = -(number - 1) WHERE book_id = ? AND number > ?', book.id, number);
        run('UPDATE chapters SET number = -number WHERE book_id = ? AND number < 0', book.id);
        // readers who got past the deleted chapter keep the same place in the story
        run('UPDATE reading_list SET last_chapter = last_chapter - 1 WHERE book_id = ? AND last_chapter >= ?', book.id, number);
        run('DELETE FROM reading_list WHERE book_id = ? AND in_library = 0 AND last_chapter = 0', book.id);
    });
    res.json({ message: `Chapter ${number} ("${chapter.title}") has been deleted. Later chapters were renumbered.` });
});

// Delete a book (author or admin, only while nobody has bought it).
// Chapters, reviews, tags, views, reading lists and cart items go with it (ON DELETE CASCADE).
router.delete('/books/:id', requireLogin, (req, res) => {
    const book = get('SELECT id, title, user_id, cover FROM books WHERE id = ?', int(req.params.id));
    if (!book) return fail(res, 404, 'That book does not exist.');
    if (!canManage(book, req.user)) return fail(res, 403, 'You can only delete books that you have written.');
    const sales = salesOf(book.id);
    if (sales > 0) {
        return fail(res, 409, `"${book.title}" has been bought ${sales} time${sales > 1 ? 's' : ''}, so it cannot be deleted. `
            + 'You can still edit it or mark it as completed.');
    }
    run('DELETE FROM books WHERE id = ?', book.id);
    deleteUpload(book.cover);  // only removes files in /uploads, never the seed covers
    res.json({ message: `"${book.title}" has been deleted.`, wasAuthor: book.user_id === req.user.id });
});

export default router;
