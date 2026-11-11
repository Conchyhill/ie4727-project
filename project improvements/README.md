# Project improvements: modern version (15% enhancement)

This folder rebuilds the base PHP/MySQL site with a modern stack. It has the same 10 pages, features, database tables and sample data:

| Layer | Base version (repo root) | This version |
|---|---|---|
| Frontend | PHP-rendered HTML, `css/style.css`, plain JS | **React 19** single-page app + **Tailwind CSS 4** (built with Vite) |
| Backend | PHP pages + handler scripts | **Node.js + Express 5** JSON API |
| Database | MySQL (XAMPP) | **SQLite** (one file, via `better-sqlite3`) |

The base version in the repo root is unchanged and still the one graded for the 85%.

## Running it

You need Node.js 20.19 or newer (`node -v`). XAMPP does not need to be running.

```bash
cd "project improvements"
npm install        # installs client, server and shared in one go (npm workspaces)
npm run dev        # API on http://localhost:3001 + React app on http://localhost:5173
```

Open **http://localhost:5173**. The first start creates the database at `server/data/novel_portal.db` from `server/db/schema.sql` and `server/db/seed.sql`.

| Command | What it does |
|---|---|
| `npm run dev` | Starts both servers with auto-reload |
| `npm run db:reset` | Wipes the database and reloads the sample data (like re-importing `schema.sql` + `seed.sql`) |
| `npm run build` then `npm start` | Production build: Express serves the built React app and the API together on http://localhost:3001 |
| `npm run convert-seed` | Regenerates `server/db/seed.sql` from the MySQL `../sql/seed.sql` after the seed changes |

The seed logins are the same: `admin` / `admin123`, `alice` / `password123`, `bob` / `password123`, `chen` / `password123`. The PHP bcrypt hashes work unchanged in Node.

Demo payment: card numbers starting with 4 succeed (`4242 4242 4242 4242`). Other valid numbers fail (`5555 5555 5555 4444`).

## Folder layout

```
project improvements/
├── package.json            npm workspaces + root scripts
├── shared/index.js         validation rules + constants used by BOTH client and server
├── server/
│   ├── db/schema.sql       SQLite schema (same tables as sql/schema.sql)
│   ├── db/seed.sql         sample data, generated from ../sql/seed.sql
│   ├── scripts/            convert-seed.js, reset-db.js
│   ├── src/index.js        Express app: sessions, /api routes, /uploads, serves client/dist
│   ├── src/db.js           SQLite connection + all/get/run/transaction helpers (prepared statements)
│   ├── src/lib.js          canReadChapter, ownsBook, requireLogin, input helpers
│   ├── src/uploads.js      image upload checks (size + real file type) for covers/avatars
│   └── src/routes/         auth, catalog, books, library, cart, account
└── client/
    ├── vite.config.js      dev server; forwards /api and /uploads to Express
    ├── public/images/      logo + placeholder cover/avatar (copied from ../images)
    └── src/
        ├── App.jsx         routes (each page lazy-loaded)
        ├── index.css       Tailwind + palette (#302a1c, #6d6758, #b69f86, #bab19b) + .btn/.card/.input
        ├── context/        AuthContext (current user, cart count), FlashContext (toast messages)
        ├── lib/            api.js (fetch wrapper), hooks.js (useApi, useForm, ...), format.js
        ├── components/     Layout (nav + footer), RequireAuth, ui.jsx, PasswordStrength
        └── pages/          one file per page (below)
```

## Page and endpoint map

| PHP page | React route | API used |
|---|---|---|
| `index.php` | `/` (`Home.jsx`) | `GET /api/home?period=today\|week` |
| `browse.php` | `/browse` (`Browse.jsx`) | `GET /api/books?q&genre&status&sort&page&serial&author&language`, `GET /api/meta` |
| `book.php?id=` | `/books/:id` (`Book.jsx`) | `GET /api/books/:id`, `POST /api/books/:id/reviews` |
| `read.php?book=&ch=` | `/books/:id/read/:ch` (`Reader.jsx`) | `GET /api/books/:id/chapters/:n` (also counts the view + updates progress) |
| `login.php`, `logout.php` | `/login` (`Login.jsx`) | `POST /api/auth/login`, `/signup`, `/logout`, `GET /api/auth/me` |
| `account.php` | `/account` (`Account.jsx`) | `GET /api/account`, `POST /api/account/photo`, `PUT /api/account/profile`, `PUT /api/account/password`, `DELETE /api/account` |
| `reading_list.php`, `list_action.php` | `/reading-list` (`ReadingList.jsx`) | `GET/POST /api/reading-list`, `DELETE /api/reading-list/:bookId?tab=` |
| `create.php` | `/create`, `/create/edit/:id` (`Create.jsx`), `/create/:id/chapter` and `/create/:id/chapter/:ch` (`ChapterForm.jsx`) | `GET /api/my/books`, `POST /api/books`, `GET /api/books/:id/edit`, `PUT /api/books/:id`, `POST /api/books/:id/chapters`, `GET /api/books/:id/chapters/:n/edit`, `PUT /api/books/:id/chapters/:n` |
| `delete_action.php` | buttons on `Book.jsx`, `Create.jsx`, `ChapterForm.jsx` | `DELETE /api/books/:id` (author/admin, unsold only), `DELETE /api/books/:id/chapters/:n` (author/admin, renumbers later chapters), `DELETE /api/books/:id/reviews/:userId` (writer/admin) |
| `cart.php`, `cart_action.php` | `/cart` (`Cart.jsx`) | `GET/POST /api/cart`, `DELETE /api/cart/:bookId`, `POST /api/cart/checkout`, `GET /api/orders/:id` |
| `info.php` | `/info` (`Info.jsx`) | `GET /api/info/stats`, `POST /api/feedback` |

Members-only pages (Account, Reading List, Create, Cart) are wrapped in `<RequireAuth>`, which sends guests to `/login?redirect=...`. The API checks the session again for every members-only request and answers `401` if there isn't one.

## What is better than the base version (for the report's "Modern enhancements" section)

1. **React single-page app.** Moving between pages, filtering, adding to the reading list or cart and posting reviews all happen without a full page reload. Browse filters stay in the URL, so results can still be bookmarked and shared. Each page is code-split, so the first visit downloads less JavaScript.
2. **Tailwind CSS.** The layout is utility-first and responsive: a mobile menu, a sticky header, card layouts and tables that scroll sideways on phones. The palette is kept as theme tokens, so it matches the base version's colours.
3. **One set of validation rules.** `shared/index.js` holds every rule (usernames, passwords, Luhn card check, review lengths, book fields and so on). The browser imports it for instant inline errors, and the server runs the same functions again before touching the database, so the two can't drift apart. The base version had these rules written twice, once in `js/forms.js` and once in PHP.
4. **A clean JSON API.** Express routes return JSON and the right HTTP status codes (400 field errors, 401 not logged in, 403 not yours, 404). The same API could serve a mobile app later.
5. **SQLite.** The whole database is one file. It needs no server setup, is created automatically on first run, and `npm run db:reset` replaces the phpMyAdmin import steps. It still uses foreign keys with `ON DELETE CASCADE`, `CHECK` constraints, transactions for multi-step writes (checkout, new book plus tags, deleting an account) and upserts (`ON CONFLICT ... DO UPDATE`).
6. **Security kept at least as strong.** Every query is a prepared statement. Passwords are hashed with bcrypt. The session is a signed `httpOnly`, `SameSite=Lax` cookie. Uploads are checked by their real file contents, are limited to 2 MB and get random names. Login redirects only go to our own pages, and LIKE searches escape `%` and `_`.
7. **UX extras.** Toast messages, a password strength meter, card number and expiry auto-formatting, a cover/photo preview before upload, a reader text size remembered in the browser, arrow-key chapter navigation and a "skip to content" link.

## Notes

- The base version's feedback form also calls `mail()` to `webmaster@localhost`. Here feedback is saved to the `feedback` table (the admin sees it on the Account page), and the server logs a line in place of the local mailbox.
- `npm install` may warn that `better-sqlite3` and `esbuild` install scripts were not run. Both ship prebuilt binaries for Windows, macOS and Linux, so this is safe to ignore.
- Uploaded images go to `server/uploads/` and the database file to `server/data/`. Both are git-ignored.
