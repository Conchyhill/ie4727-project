-- SQLite version of ../../../sql/schema.sql (same tables and columns as the MySQL database).
-- Differences from MySQL:
--   * AUTO_INCREMENT -> INTEGER PRIMARY KEY AUTOINCREMENT
--   * ENUM -> TEXT with a CHECK constraint
--   * DECIMAL -> REAL, DATETIME/DATE -> TEXT in 'YYYY-MM-DD HH:MM:SS' local time
--   * usernames and emails use COLLATE NOCASE (MySQL's utf8mb4_unicode_ci is case-insensitive too)
--   * reading_list.updated_at has no ON UPDATE, so the server sets it in each UPDATE
-- Running this file drops and recreates every table (npm run db:reset).

PRAGMA foreign_keys = OFF;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS reading_list;
DROP TABLE IF EXISTS book_views_daily;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS chapters;
DROP TABLE IF EXISTS book_tags;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

-- Registered members (role 'admin' sees the site statistics on the Account page)
CREATE TABLE users (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT NOT NULL UNIQUE COLLATE NOCASE CHECK (length(username) <= 30),
    email         TEXT NOT NULL UNIQUE COLLATE NOCASE CHECK (length(email) <= 100),
    password_hash TEXT NOT NULL,
    photo         TEXT,
    role          TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member', 'admin')),
    created_at    TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Each book has one main genre
CREATE TABLE genres (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE
);

-- Free-form tags, many per book
CREATE TABLE tags (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE books (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    serial_no  TEXT NOT NULL UNIQUE,                    -- e.g. NB-000001, searchable by members
    title      TEXT NOT NULL,
    user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,   -- author
    genre_id   INTEGER NOT NULL REFERENCES genres(id),
    language   TEXT NOT NULL DEFAULT 'English',
    synopsis   TEXT NOT NULL,
    cover      TEXT,                                    -- NULL = placeholder cover
    status     TEXT NOT NULL DEFAULT 'ongoing' CHECK (status IN ('ongoing', 'completed')),
    price      REAL NOT NULL DEFAULT 0 CHECK (price >= 0 AND price < 100),
    views      INTEGER NOT NULL DEFAULT 0,              -- all-time total
    created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE book_tags (
    book_id INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, tag_id)
);

-- Latest created_at per book drives "Recently Updated"
CREATE TABLE chapters (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id    INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    number     INTEGER NOT NULL,
    title      TEXT NOT NULL,
    content    TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    UNIQUE (book_id, number)
);

-- One review per member per book (re-submitting updates it)
CREATE TABLE reviews (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id    INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating     INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    UNIQUE (book_id, user_id)
);

-- Views per book per day; Trending sums the last 1 or 7 days
CREATE TABLE book_views_daily (
    book_id   INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    view_date TEXT NOT NULL,
    views     INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (book_id, view_date)
);

-- Library (in_library = 1) and History (last_chapter > 0) on the Reading List page
CREATE TABLE reading_list (
    user_id      INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    book_id      INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    in_library   INTEGER NOT NULL DEFAULT 1,
    last_chapter INTEGER NOT NULL DEFAULT 0,
    updated_at   TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY (user_id, book_id)
);

CREATE TABLE cart_items (
    user_id  INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    book_id  INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    added_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY (user_id, book_id)
);

-- Payment is simulated; failed attempts are recorded too
CREATE TABLE orders (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total      REAL NOT NULL,
    status     TEXT NOT NULL CHECK (status IN ('success', 'failed')),
    created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    book_id  INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    price    REAL NOT NULL,
    PRIMARY KEY (order_id, book_id)
);

-- Messages from the feedback form on the Info page
CREATE TABLE feedback (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    email      TEXT NOT NULL,
    subject    TEXT NOT NULL,
    message    TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Indexes for the foreign keys and sort columns used by the pages
CREATE INDEX idx_books_user ON books(user_id);
CREATE INDEX idx_books_genre ON books(genre_id);
CREATE INDEX idx_chapters_created ON chapters(created_at);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_views_date ON book_views_daily(view_date);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_order_items_book ON order_items(book_id);
