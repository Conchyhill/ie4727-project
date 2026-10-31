-- Database schema for the web-novel library portal.
-- Import in phpMyAdmin (Import tab, no database selected), then import seed.sql.
-- Re-importing this file wipes and recreates the whole database.

DROP DATABASE IF EXISTS novel_portal;
CREATE DATABASE novel_portal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE novel_portal;

-- Registered members (role 'admin' can see the stats on account.php)
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(30)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    photo         VARCHAR(255) NULL,
    role          ENUM('member', 'admin') NOT NULL DEFAULT 'member',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Each book has one main genre
CREATE TABLE genres (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Free-form tags, many per book
CREATE TABLE tags (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE books (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    serial_no  VARCHAR(12)  NOT NULL UNIQUE,         -- e.g. NB-000001, searchable by members
    title      VARCHAR(150) NOT NULL,
    user_id    INT NOT NULL,                         -- author
    genre_id   INT NOT NULL,
    language   VARCHAR(30)  NOT NULL DEFAULT 'English',
    synopsis   TEXT NOT NULL,
    cover      VARCHAR(255) NULL,                    -- NULL = placeholder cover
    status     ENUM('ongoing', 'completed') NOT NULL DEFAULT 'ongoing',
    price      DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    views      INT NOT NULL DEFAULT 0,               -- all-time total
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
) ENGINE=InnoDB;

CREATE TABLE book_tags (
    book_id INT NOT NULL,
    tag_id  INT NOT NULL,
    PRIMARY KEY (book_id, tag_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)  REFERENCES tags(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- Latest created_at per book drives "Recently Updated"
CREATE TABLE chapters (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    book_id    INT NOT NULL,
    number     INT NOT NULL,
    title      VARCHAR(150) NOT NULL,
    content    MEDIUMTEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (book_id, number),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- One review per member per book (re-submitting updates it)
CREATE TABLE reviews (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    book_id    INT NOT NULL,
    user_id    INT NOT NULL,
    rating     TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (book_id, user_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Views per book per day; Trending sums the last 1 or 7 days
CREATE TABLE book_views_daily (
    book_id   INT  NOT NULL,
    view_date DATE NOT NULL,
    views     INT  NOT NULL DEFAULT 0,
    PRIMARY KEY (book_id, view_date),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Library (in_library = 1) and History (last_chapter > 0) on reading_list.php
CREATE TABLE reading_list (
    user_id      INT NOT NULL,
    book_id      INT NOT NULL,
    in_library   TINYINT(1) NOT NULL DEFAULT 1,
    last_chapter INT NOT NULL DEFAULT 0,
    updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cart_items (
    user_id  INT NOT NULL,
    book_id  INT NOT NULL,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Payment is simulated; failed attempts are recorded too
CREATE TABLE orders (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    total      DECIMAL(8,2) NOT NULL,
    status     ENUM('success', 'failed') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE order_items (
    order_id INT NOT NULL,
    book_id  INT NOT NULL,
    price    DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id)  REFERENCES books(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- Messages from the feedback form on info.php
CREATE TABLE feedback (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(60)  NOT NULL,
    email      VARCHAR(100) NOT NULL,
    subject    VARCHAR(100) NOT NULL,
    message    TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
