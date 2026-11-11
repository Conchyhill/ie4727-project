# IE4727 Library: Web-Novel Reading Portal

An online library for web novels (Theme 6 of IE4727). Visitors can browse books by genre, see what is trending and read the first chapters for free. Members can also:

- keep a reading list that remembers their progress
- write reviews
- buy books to unlock every chapter
- search by serial number
- publish their own books

Built with **HTML, CSS, JavaScript, PHP and MySQL** only. There are no frameworks or libraries.

---

## Getting started: from a fresh install to a running site

Follow these steps once on a new computer. They take about 15 minutes. After that, see [Running the site](#1-running-the-site) for everyday use.

### What you need
- A Windows PC. XAMPP also exists for macOS and Linux; the steps are similar but the paths differ.
- **XAMPP with PHP 8.0 or newer.** It bundles Apache (the web server), PHP and MySQL/MariaDB (the database) in one installer.
- **Git**, to download the code. You can also use GitHub Desktop or a ZIP download (see step 2).
- A web browser.

### Step 1: Install XAMPP
1. Download the Windows installer from **https://www.apachefriends.org** (any 8.x version).
2. Run it. If Windows warns about *User Account Control*, click **OK**. This is why the next point matters.
3. Install to the default folder, **`C:\xampp`**. Avoid `C:\Program Files`, because Windows permissions there can stop XAMPP working properly.
4. On the components screen, keep at least **Apache**, **MySQL**, **PHP** and **phpMyAdmin** ticked. You can untick the rest.
5. When the installer finishes, let it open the **XAMPP Control Panel** (or open it later from the Start menu).

### Step 2: Put the code inside XAMPP's web folder
Apache only serves files inside **`C:\xampp\htdocs`**, so the project must go in there.

**Option A: Git (recommended, so you can pull your partner's changes later).** Open *Command Prompt*, *PowerShell* or *Git Bash* and run:
```
cd C:\xampp\htdocs
git clone https://github.com/Conchyhill/ie4727-project.git
```

**Option B: no Git.** On the GitHub page click **Code → Download ZIP**. Extract the ZIP into `C:\xampp\htdocs`, then rename the extracted folder from `ie4727-project-main` to `ie4727-project`.

Either way, you should now have this file: **`C:\xampp\htdocs\ie4727-project\index.php`**

> The folder can live deeper inside `htdocs` if you like. This team's copy is at `C:\xampp\htdocs\IE4727\IE4727_Project\ie4727-project`. The address in step 5 must then match: `http://localhost/IE4727/IE4727_Project/ie4727-project/`.

### Step 3: Start Apache and MySQL
1. Open the **XAMPP Control Panel**.
2. Click **Start** next to **Apache**, then **Start** next to **MySQL**.
3. Both module names should turn **green**, with port numbers shown (Apache `80, 443`, MySQL `3306`).
4. If Windows Firewall asks, click **Allow access**.

If one of them won't start, look at the red text in the log at the bottom of the panel:
- **Apache, "Port 80 in use":** another program (Skype, IIS, another web server) is using port 80.
  1. Click Apache's **Config → Apache (httpd.conf)**.
  2. Change `Listen 80` to `Listen 8080` and save.
  3. Start Apache again.
  4. From now on, add `:8080` to every address, e.g. `http://localhost:8080/ie4727-project/`.
- **MySQL, "Port 3306 in use":** another MySQL server is already running on the PC. Stop it in *Windows Services*, or uninstall it.

### Step 4: Create the database
The site needs a database called `novel_portal`. The SQL files in the `sql/` folder create it for you.

1. In the Control Panel, click **Admin** on the **MySQL** row. **phpMyAdmin** opens in your browser (`http://localhost/phpmyadmin`).
2. **Don't click any database in the left sidebar.** Stay on the main page. The script creates its own database.
3. Click the **Import** tab at the top.
4. Click **Choose File**, select **`C:\xampp\htdocs\ie4727-project\sql\schema.sql`**, scroll down and click **Import** (or **Go** in older versions). You should see a green "Import has been successfully finished" message.
5. Repeat step 4 with **`sql\seed.sql`**, which adds the sample users, books and chapters.
6. Refresh phpMyAdmin. **`novel_portal`** should appear in the left sidebar. Click it to check it has 13 tables (`books`, `chapters`, `users`, and so on).

> Always import **`schema.sql` first, then `seed.sql`**. Importing `schema.sql` again later wipes the database and starts it fresh.

### Step 5: Open the site
Go to **http://localhost/ie4727-project/** in your browser. You should see the Home page with the Trending row and book covers.

- Always open pages through `http://localhost/...`. Double-clicking `index.php` in File Explorer won't work, because PHP only runs when Apache serves the file.

### Step 6: Log in and try it out
Click **Login** in the nav bar and use one of the sample accounts:

| Username | Password | Try this |
|---|---|---|
| `alice` | `password123` | Open **Reading List** to see her progress. Open **Shopping Cart** and pay with card `4242 4242 4242 4242` (any future expiry, e.g. `12/30`, any 3-digit code) to buy a book |
| `admin` | `admin123` | Click your username (**admin**, top right) to open the Account page and scroll down to **Site statistics** |

You can also create your own account from the **Sign up** tab.

### Something went wrong?

| What you see | Cause and fix |
|---|---|
| `Fatal error: Uncaught mysqli_sql_exception: Unknown database 'novel_portal'` | The database wasn't created. Do **step 4** |
| `…No connection could be made because the target machine actively refused it` | MySQL isn't running. Start it in the Control Panel (**step 3**) |
| `…Access denied for user 'root'@'localhost'` | Your MySQL `root` account has a password. Put it in `includes/db.php`, in the line `new mysqli('localhost', 'root', '', 'novel_portal')`, replacing the empty `''` |
| **"Object not found!"** / 404 | The address doesn't match the folder. Check the folder name in `C:\xampp\htdocs` (**step 2**) and the port (`:8080` if you changed it) |
| The page shows raw PHP code, or the browser can't connect | Apache isn't running, or the file was opened from File Explorer. Start Apache and use `http://localhost/...` |
| "Trending: No views recorded for this period yet" | The sample data is more than a day old. Re-import `schema.sql` then `seed.sql`, or read a few chapters to create views for today |
| Uploading a cover or profile photo fails | Check that `uploads/covers` and `uploads/avatars` exist inside the project folder. They are included in the repository |

### Getting your partner's latest changes
```
cd C:\xampp\htdocs\ie4727-project
git pull
```
If the pull changed `sql/schema.sql` or `sql/seed.sql`, re-import both files (**step 4**) so your database matches the code. This also resets your local test data.

---

## Contents

1. [Running the site](#1-running-the-site)
2. [How a page works (the big picture)](#2-how-a-page-works-the-big-picture)
3. [Folder map](#3-folder-map)
4. [The 10 pages](#4-the-10-pages)
5. [Handler scripts (no page of their own)](#5-handler-scripts-no-page-of-their-own)
6. [`includes/`: shared PHP code](#6-includes-shared-php-code)
7. [`js/`: JavaScript](#7-js-javascript)
8. [`css/`: the stylesheet](#8-css-the-stylesheet)
9. [`sql/`: the database](#9-sql-the-database)
10. [`images/`, `uploads/`, `archives/`](#10-images-uploads-archives)
11. [How the pages link together](#11-how-the-pages-link-together)
12. [Walkthroughs: what happens when you…](#12-walkthroughs-what-happens-when-you)
13. [Adding a new page](#13-adding-a-new-page)
14. [Glossary](#14-glossary)

---

## 1. Running the site

Day to day, after the one-time [Getting started](#getting-started-from-a-fresh-install-to-a-running-site) setup:

1. Open the **XAMPP Control Panel** and start **Apache** and **MySQL**.
2. Visit **http://localhost/ie4727-project/**, or wherever your folder sits inside `htdocs`.
3. When you're finished, click **Stop** on both.

To **reset the data**, re-import `sql/schema.sql` and then `sql/seed.sql` in phpMyAdmin (Getting started, step 4).

Sample accounts created by `seed.sql`:

| Username | Password | Notes |
|---|---|---|
| `admin` | `admin123` | Admin: sees site statistics on the Account page |
| `alice` | `password123` | Member with books in her reading list and cart |
| `bob`, `chen` | `password123` | Members who have written some of the sample books |

> Importing `schema.sql` again **deletes everything** and recreates empty tables. Import `seed.sql` after it to get the sample data back. The sample dates are relative to the moment you import, so re-import before a demo to make "Trending today" look fresh.

---

## 2. How a page works (the big picture)

When you open a page such as `book.php?id=1`:

```
 Browser                        Apache + PHP                         MySQL
 -------                        ------------                         -----
 asks for book.php?id=1  --->   book.php runs from top to bottom:
                                 1. loads includes/init.php
                                    (database connection, helper
                                     functions, login session)
                                 2. reads ?id=1 from the URL ($_GET)
                                 3. asks the database for book 1  --->  SELECT ... FROM books
                                                                  <---  the row for book 1
                                 4. prints the HTML: header.php,
                                    the page content, footer.php
 receives plain HTML     <---
 loads css/style.css and the js/ file named by the page
 JavaScript adds behaviour (validation, buttons, ...)
```

The ideas used throughout the project:

- **PHP runs on the server, JavaScript runs in the browser.** The browser never sees PHP code, only the HTML that PHP prints.
- **Every page starts with `require 'includes/init.php';`**. That one line loads the database connection, the helper functions and the login session.
- **Forms send data to PHP**, which checks it and saves it to the database:
  - Searches and filters use **GET**, so the data appears in the URL and you can bookmark it.
  - Anything that changes data (log in, buy, review) uses **POST**.
- **After a successful POST, PHP redirects** to a normal page. Refreshing the page then won't submit the form twice. This is called Post/Redirect/Get.
- **Validation happens twice:**
  1. HTML5 attributes and `js/forms.js` give instant feedback in the browser.
  2. PHP checks everything again on the server, because browser checks can be bypassed.

---

## 3. Folder map

```
ie4727-project/
├── index.php            Home page
├── browse.php           Browse + search
├── book.php             Book information
├── read.php             Chapter reader
├── login.php            Sign in + sign up
├── account.php          Account settings (+ admin statistics)
├── reading_list.php     Library + history
├── create.php           Publish / edit books, add chapters
├── cart.php             Shopping cart + checkout
├── info.php             About, Help, Terms, Privacy, Contact, Feedback
│
├── logout.php           \
├── list_action.php       }  Handler scripts: do one job, then redirect back
├── cart_action.php      /
│
├── includes/            PHP code shared by every page (never opened directly)
│   ├── init.php           loads everything below
│   ├── db.php             database connection + query helpers
│   ├── auth.php           login sessions
│   ├── functions.php      small helper functions
│   ├── header.php         <head> + navigation bar
│   └── footer.php         footer
│
├── js/                  Browser-side JavaScript
│   ├── home.js            Trending scroll buttons (Home)
│   ├── browse.js          auto-apply filters (Browse)
│   ├── reader.js          text size, arrow keys, chapter picker (Reader)
│   └── forms.js           form validation and form extras (6 pages)
│
├── css/style.css        The one stylesheet for the whole site
├── sql/
│   ├── schema.sql         creates the database and its 13 tables
│   └── seed.sql           sample users, books, chapters, reviews, orders
├── images/              Logo, placeholder cover, default profile picture
├── uploads/             Images uploaded through the site (covers/, avatars/)
├── archives/            Early design experiments (not used by the site)
├── .gitignore           tells Git not to save uploaded images
└── README.md            this file
```

---

## 4. The 10 pages

Each entry lists **what the user sees**, **what it reads or changes in the database** and **which files it uses or links to**. Pages marked **(members)** send logged-out visitors to `login.php` first.

### `index.php`: Home
- **Shows** three sections:
  - **Trending:** the 10 most-viewed books today or this week. A scrolling row with rank badges.
  - **Recently Updated:** books with the newest chapters, showing that chapter's title and "x hours ago".
  - **Top Genres:** genre tags with book counts.
- **URL options:** `?period=today` or `?period=week` switches the Trending list. The page reloads, with no AJAX.
- **Database:** only reads.
  - Trending adds up `book_views_daily` per book (`SUM … GROUP BY`).
  - Recently Updated sorts by each book's newest chapter.
  - Top Genres counts books per genre.
- **Uses:** `js/home.js` for the ◀ ▶ scroll buttons.
- **Links to:** `book.php` (each card), `browse.php?sort=views` ("See all") and `browse.php?genre[]=…` (genre tags).

### `browse.php`: Browse and search
- **Shows:**
  - A filter sidebar: keywords, genre checkboxes, status (all / ongoing / completed), sort (popularity / latest update / rating).
  - A list of matching books with cover, tags, synopsis, rating and chapter count.
  - Page numbers, 10 books per page.
- **Members only:** an *Advanced search* box with **serial number** (e.g. `NB-000003`, or just `3`), author and language. Searching by serial number is a requirement of the project brief. Guests see a "Log in" link instead, and PHP ignores those fields for guests.
- **How it searches:** all filters arrive in the URL (`$_GET`). PHP builds one `SELECT` with a `WHERE` condition for each filter that was filled in.
- **Database:** only reads (books, genres, tags, reviews, chapters, reading_list).
- **Uses:** `js/browse.js`, which re-runs the search as soon as you tick a box.
- **Links to:**
  - `book.php` for each result.
  - The nav bar's search box also submits here (`browse.php?q=…`).
  - "+ Add" posts to `list_action.php`.

### `book.php?id=N`: Book information
- **Shows:**
  - Breadcrumb (Home / Genre / Title), cover, author, genre, status.
  - Stats: rating, chapters, views, price, language, serial number.
  - Tags and synopsis.
  - The **Table of Contents table**, where each chapter is marked Free / Unlocked / 🔒 Locked.
  - The reviews.
- **Buttons change depending on who is looking:**
  - **Start reading / Continue Ch. N:** goes to `read.php`.
  - **+ Add to reading list / ✓ In Library:** posts to `list_action.php`.
  - **Buy full book:** posts to `cart_action.php`. Instead of this button you may see "In cart", "Owned", "Free to read", or "Edit book" if you wrote the book.
- **Review form (members, not the author):** posts back to `book.php` itself.
  - PHP checks the rating (1–5) and length (10–1000 characters).
  - It then runs `INSERT … ON DUPLICATE KEY UPDATE`. That makes a new review the first time, and **updates** your existing review after that.
- **Database:** reads books, chapters, tags, reviews, reading_list, orders and cart_items. Writes to `reviews`.
- **Uses:** `js/forms.js` for the star picker validation and character counter.

### `read.php?book=N&ch=M`: Chapter reader
- **Shows:**
  - The chapter text.
  - ‹ Previous / Next › buttons and a drop-down to jump to any chapter.
  - A− / A+ text-size buttons.
- **Locked chapters:** chapters 1–3 are free for everyone. Later chapters are readable only if one of these is true:
  - you bought the book
  - you wrote it
  - it costs $0

  Otherwise the page shows a "This chapter is locked" panel with a log in / add to cart button. This check is `can_read_chapter()` in `includes/functions.php`.
- **Database, each time a chapter is read:**
  - `UPDATE books SET views = views + 1` (all-time views).
  - Adds 1 to today's row in `book_views_daily`. This feeds Trending.
  - For members, saves the **furthest** chapter reached in `reading_list`. This feeds the History tab and the progress bars.
- **Uses:** `js/reader.js`.

### `login.php`: Sign in and Sign up
- **Shows:** two tabs. `?tab=signup` opens the Sign up tab. `js/forms.js` switches tabs without reloading.
- **Sign in:**
  - Accepts a username *or* email.
  - Checks the password with `password_verify()`.
  - Logs you in with `login_user()` and sends you back to the page you came from (the `redirect` value).
  - "Remember my username" saves a **cookie** so the username is filled in next time.
- **Sign up:**
  - Checks the username format, email, password strength and that both passwords match.
  - Checks the **database** to see whether the username or email is already taken.
  - Then runs `INSERT INTO users`. The password is stored only as a hash (`password_hash()`), never as plain text.
- **Uses:** `js/forms.js` for inline errors, the password strength bar and the tabs.

### `account.php`: Account (members)
- **Shows:** your profile summary, then four separate forms. Each sends a hidden `action` value so PHP knows which one was submitted:
  - **Profile photo** (`action=photo`): uploads an image to `uploads/avatars/`, then `UPDATE users SET photo`.
  - **Account details** (`action=profile`): new username and email. PHP checks nobody else uses them, then runs `UPDATE`.
  - **Change password** (`action=password`): needs your current password.
  - **Delete account** (`action=delete`): needs your password, a ticked box and a JavaScript "Are you sure?". Your books are handed to the admin. The database then automatically deletes your reviews, list, cart and orders (`ON DELETE CASCADE`).
- **Order history table:** every purchase attempt, successful or failed.
- **Admin only:** site statistics, built from `COUNT`, `SUM`, `AVG` and `GROUP BY`:
  - totals
  - best sellers
  - orders per day for the last 7 days
  - stats per genre
  - the latest feedback messages
- **Uses:** `js/forms.js`.

### `reading_list.php`: Reading List (members)
- **Shows:** two tabs.
  - **Library** (`?tab=library`): books you saved with "+ Add" or bought.
  - **History** (`?tab=history`): books you have started reading, newest first.
- Each card shows a **progress bar** (e.g. 4/12 chapters), a Start / Continue / Read again button that goes to `read.php`, and **Remove**.
- **Remove** posts to `list_action.php`:
  - `action=remove` takes the book off the Library tab.
  - `action=forget` takes it off the History tab.
- **Database:** reads `reading_list` joined with `books`.

### `create.php`: Create (members)
This one file has three modes, picked by the URL:

| URL | What it does | Database |
|---|---|---|
| `create.php` | **New book** form: title, genre, language, price, status, up to 5 tags, synopsis, optional cover image | `INSERT INTO books` and `book_tags`. The serial number (`NB-000021`) is made from the new book's id |
| `create.php?edit=N` | Same form, pre-filled, for **your own** book | `UPDATE books`, then tags are replaced |
| `create.php?add_chapter=N` | **Add chapter** form: title and text | `INSERT INTO chapters` with the next chapter number |

- Below the form, the **My books** table lists your books with Edit and + Chapter links.
- After creating a book you are taken straight to "add your first chapter".
- After editing or adding a chapter you are taken to the book's page.
- **Uses:** `js/forms.js` (validation, cover preview, character counter, tag limit). Cover images are saved to `uploads/covers/`.

### `cart.php`: Shopping cart and checkout (members)
- **Shows:** a cart table (book, author, chapters, price, Remove) with the total, and a checkout form (name on card, card number, expiry, security code).
- **Payment is simulated.** The project brief says a real payment provider is assumed. After the card details pass validation:
  - card numbers starting with **4** are *approved* (try `4242 4242 4242 4242`)
  - any other valid number is *declined* (try `5555 5555 5555 4444`)
- **On success:**
  - saves an `orders` row (status `success`) and `order_items`
  - adds the books to your Library
  - empties the cart
  - redirects to `cart.php?order=N`, which shows a ✓ success panel
- **On failure:** saves an `orders` row with status `failed`, **keeps** the cart, and shows a ✗ failure panel.
- Card details are checked and then thrown away. They are never stored.
- **Uses:** `js/forms.js`. The card number check uses the Luhn checksum, and the expiry date must not be in the past. The "Remove" button asks for confirmation.

### `info.php`: About, Help, Terms, Privacy, Contact, Feedback
- **Shows:** one long page with a section for each footer link. The footer links use anchors such as `info.php#terms` to jump straight to the right section.
- **About** shows live counts of books, chapters, genres and members from the database.
- **Feedback form** (name, email, topic, message):
  - saves the message with `INSERT INTO feedback`
  - tries to email it with PHP's `mail()` to the site's own local account, `webmaster@localhost`

  If XAMPP's mail server isn't set up, the email silently fails, but the message is still saved and appears on the admin's Account page.
- **Uses:** `js/forms.js`.

---

## 5. Handler scripts (no page of their own)

These files receive a button click (a POST), do one job, then **redirect** you back to where you were. You never see them as pages.

| File | Called by | What it does |
|---|---|---|
| `logout.php` | "Logout" in the nav bar | Clears the session (logs you out), then goes to Home |
| `list_action.php` | "+ Add", "✓ In Library" and "Remove" buttons | `action=add`: puts the book in your Library. `action=remove`: takes it off the Library tab. `action=forget`: clears it from the History tab. Rows that end up in neither tab are deleted |
| `cart_action.php` | "Buy full book", "Add to cart" and "Remove" buttons | `action=add`: adds to `cart_items`, but refuses if you wrote the book, it's free, or you already own it. `action=remove`: deletes it from the cart |

Each form includes a hidden `back` field holding the page to return to. `safe_redirect()` checks that it points to one of our own pages.

---

## 6. `includes/`: shared PHP code

Pages load these with `require`. Visitors never open them directly.

### `init.php`: the starting point
Every page and handler begins with `require 'includes/init.php';`. It:
- defines `SITE_NAME` (change it here when the project title is decided)
- loads `db.php`, `functions.php` and `auth.php`, in that order

### `db.php`: talking to the database
- Opens the connection to the `novel_portal` database as `$db`, using XAMPP's default login: user `root`, no password.
- Provides three helpers that use **prepared statements**. The SQL and the user's values are sent separately, which prevents SQL injection:

| Function | Returns | Example |
|---|---|---|
| `db_query($sql, $types, $params)` | runs any query (used for INSERT / UPDATE / DELETE) | `db_query('DELETE FROM cart_items WHERE user_id = ?', 'i', [$id])` |
| `db_row(...)` | the first row as an array, or `null` | `db_row('SELECT * FROM books WHERE id = ?', 'i', [5])` |
| `db_all(...)` | all rows as a list of arrays | `db_all('SELECT name FROM genres')` |

- `$types` is one letter per `?` placeholder: `i` = integer, `s` = string, `d` = decimal number.

### `auth.php`: who is logged in
- Calls `session_start()`, so PHP remembers you between pages using a session cookie.

| Function | What it does |
|---|---|
| `current_user()` | The logged-in user's row (id, username, email, photo, role), or `null` for guests |
| `is_logged_in()` / `is_admin()` | Yes/no checks |
| `require_login()` | Put at the top of members-only pages. Guests are redirected to `login.php?redirect=<this page>` |
| `login_user($id)` | Logs someone in. Gets a new session id first, a security measure against session fixation |
| `safe_redirect($target)` | Redirects, but only to our own pages, so a link can't send users to another website |

### `functions.php`: small helpers

| Function | What it does |
|---|---|
| `FREE_CHAPTERS` | The number of free chapters (3) |
| `h($text)` | Makes text safe to print in HTML. **Use it on everything that came from a user or the database**, so a review containing `<script>` is shown as text and never runs |
| `param($_GET or $_POST, 'name')` | Reads one form or URL value safely; returns `''` if it's missing |
| `valid_email($email)` | The same email rule the browser uses |
| `format_views(27400000)` | Returns `"27.4M"` |
| `money(4.99)` | Returns `"$4.99"` |
| `time_ago($seconds)` | Returns e.g. `"3 hours ago"` |
| `stars(4.3)` | Returns `"★★★★☆ 4.3"` |
| `cover_url()` / `avatar_url()` | The uploaded image, or the placeholder image if there isn't one |
| `upload_image($field, $folder)` | Saves an uploaded image into `uploads/<folder>/` after checking it really is an image of 2 MB or less |
| `owns_book($user, $book)` | Has this user bought the book (a successful order)? |
| `can_read_chapter($book, $n)` | Combines the rules: free chapter, free book, author or buyer |
| `flash($message)` / `show_flash()` | Saves a one-time message such as "Added to your cart" in the session. The next page shows it once |
| `cart_count()` | The number of items in the cart, for the badge in the nav bar |

### `header.php`: top of every page
- Prints `<!DOCTYPE html>`, the `<head>` (title, `css/style.css`, and the page's own JS files) and the **navigation bar**.
- Before including it, a page sets:
  - `$pageTitle`, which becomes the browser tab title
  - optionally `$pageScripts`, e.g. `['forms.js']`
- The nav bar adapts to the visitor:
  - Logged out, it shows **Login**.
  - Logged in, it shows your **username** (a link to `account.php`) and **Logout**.
  - The cart shows a number badge when it has items.
  - The current page's link is underlined (`nav_class()`).
- Shows any flash message just above the page content.

### `footer.php`: bottom of every page
- Footer links (all go to sections of `info.php`), the logo and the copyright line, and the closing `</body></html>`.

---

## 7. `js/`: JavaScript

JavaScript adds behaviour in the browser. Every page still works without it, because PHP does the real work.

| File | Loaded by | What it does |
|---|---|---|
| `home.js` | `index.php` | `scrollTrending()` scrolls the Trending row when ◀ ▶ are clicked. `updateScrollButtons()` greys out a button at the end of the row |
| `browse.js` | `browse.php` | `submitFilters()` re-submits the filter form as soon as a checkbox, status or sort option changes. This is a normal page reload, not AJAX |
| `reader.js` | `read.php` | `changeFontSize()` handles the A− / A+ buttons and remembers your size in the browser's `localStorage`. `handleArrowKeys()` lets ← / → go to the previous / next chapter. Choosing from the chapter drop-down jumps there immediately |
| `forms.js` | `book.php`, `login.php`, `account.php`, `create.php`, `cart.php`, `info.php` | See below |

**`forms.js`** works on any form marked `novalidate`, which means "let our JavaScript show errors instead of the browser's pop-ups":
- `validateForm()` runs when the form is submitted. It calls `checkField()` on every field. If anything is wrong, it shows the message under that field (`showError()` puts it in the `<p class="fieldError">`) and stops the submit.
- `checkField()` covers:
  - HTML5 rules: required, email format, minimum length, pattern, number range
  - **passwords match** (`data-match`) and contain a letter and a number
  - **card number** passes the Luhn check (`luhnValid()`) and the **expiry** is not in the past
  - **image uploads** are JPG/PNG/GIF/WEBP and no bigger than 2 MB
  - at most 5 **tags** on the Create form
- Extras:
  - `updateStrength()`: the coloured password-strength bar
  - `updateCounter()`: "120 / 2000 characters" under text boxes
  - `previewImage()`: shows the chosen cover or photo before uploading
  - `showTab()`: switches between Sign in and Sign up
  - "Are you sure?" pop-ups for Delete account and Remove from cart
  - adds spaces to the card number as you type

---

## 8. `css/`: the stylesheet

`css/style.css` is the **only** stylesheet, shared by every page, so the whole site looks consistent. It is organised into commented sections, in order:

- nav bar, main container, book cards and the Trending row (Home), genre tags, footer
- buttons, flash messages, forms, tables, status chips
- one section per page: Browse, Book Information, Reviews, Reader, Login, Account, Reading List, Create, Cart, Info
- `@media (max-width: 800px)`: the **small-screen layout** for phones and narrow windows. Sidebars move above the content and the nav bar wraps

Colour palette (from `archives/template`): `#6d6758` brown-grey, `#b69f86` tan, `#302a1c` dark brown, `#bab19b` beige.

---

## 9. `sql/`: the database

### `schema.sql`
Creates the `novel_portal` database and its **13 tables**:

| Table | Stores | Used by |
|---|---|---|
| `users` | Members: username, email, hashed password, photo, role (member/admin) | login, account, every page's nav bar |
| `genres` | The 10 genres (one main genre per book) | home, browse, book, create |
| `tags` | Extra labels such as "Magic" or "Revenge" | browse, book, create |
| `book_tags` | Which tags each book has (links books ↔ tags) | browse, book, create |
| `books` | Each book: serial number, title, author, genre, synopsis, cover, status, price, total views | almost every page |
| `chapters` | Chapter number, title and text for each book | book, read, create, home |
| `reviews` | One star rating + comment per member per book | book, browse (average rating), home |
| `book_views_daily` | Views per book **per day** | home (Trending), read (adds views), account (admin) |
| `reading_list` | Each member's saved books and furthest chapter read | reading_list, read, book, browse |
| `cart_items` | What is in each member's cart | cart, book, nav badge |
| `orders` | Each checkout attempt: total and success/failed | cart, account |
| `order_items` | Which books were in each order | cart (ownership), account |
| `feedback` | Messages from the Feedback form | info, account (admin) |

The arrows below show which tables point to which (foreign keys):

```
users ──< books >── genres          (a user writes many books; a genre has many books)
books ──< chapters
books ──< book_tags >── tags
users ──< reviews >── books
users ──< reading_list >── books
users ──< cart_items >── books
users ──< orders ──< order_items >── books
books ──< book_views_daily
```

### `seed.sql`
Sample data so the site isn't empty:
- 5 users
- 20 books with 5–12 chapters each
- reviews, 7 days of view counts
- a reading list, a cart and a few orders

It was generated by a small script, so the chapter text is filler.

---

## 10. `images/`, `uploads/`, `archives/`

- **`images/`**: images that are part of the site:
  - `logo.png` (the site logo, used in the nav bar, the footer and as the favicon)
  - `covers/nb-000001.svg` to `nb-000020.svg` (our own drawn covers for the 20 sample books, linked from `sql/seed.sql`)
  - `cover_placeholder.svg` (shown when a book has no cover)
  - `avatar_default.svg` (shown when a user has no profile photo)
- **`uploads/covers/`** and **`uploads/avatars/`**: images that users upload on the Create and Account pages. They are given random file names. They are **not** saved to Git, and the hidden `.gitkeep` files keep the empty folders in the repository. See [Git files](#git-files-gitignore-and-gitkeep) below.
- **`archives/`**: early experiments kept for reference. Nothing here is used by the site.
  - `template/` is the original page skeleton and colour palette.
  - `grid study/` is a CSS grid test.

### Git files: `.gitignore` and `.gitkeep`

These two files don't affect the website at all. They only control what **Git** saves to the shared repository.

**`.gitkeep`: keeping empty folders**

Git only tracks *files*, never folders on their own. An empty folder is invisible to Git, so it would not exist in anyone's fresh clone. That is a problem here: `upload_image()` in `includes/functions.php` saves files into `uploads/covers/` and `uploads/avatars/`, and if those folders are missing, every cover and profile-photo upload fails.

The fix is to put a tiny empty file called `.gitkeep` inside each folder. Git now has a file to track, so the folder comes along with every clone. The name `.gitkeep` is only a convention: Git gives it no special meaning, and any file name would work. Files whose names start with a dot are hidden by default in File Explorer and macOS Finder, so you may not see them.

**`.gitignore`: files Git should leave alone**

`.gitignore` lists files that Git must **not** track. Ours contains:

```
# Files uploaded through the site (covers, profile photos)
uploads/*/*
!uploads/*/.gitkeep
```

| Line | Meaning |
|---|---|
| `# Files uploaded…` | A comment. Lines starting with `#` are ignored |
| `uploads/*/*` | Ignore **everything inside** any folder in `uploads/`, e.g. `uploads/covers/3f9a1c.jpg`. `*` means "any name" |
| `!uploads/*/.gitkeep` | `!` means "except". Do **not** ignore the `.gitkeep` files, so the folders themselves are still saved (see above) |

**Why not save uploaded images?** They are test data that belongs to whoever is running the site on their own computer, not part of the project's code:
- Committing them would copy your test covers and profile photos onto your partner's computer every time they `git pull`.
- The pictures wouldn't even match their database, because the database lives in each person's own MySQL, not in Git.
- They would make the repository bigger for no benefit.

Each person's uploads therefore stay on their own machine. Images the site really needs, such as the logo and placeholder cover, live in `images/` instead, which Git does save.

**Things to know**
- `git status` won't list uploaded images. That is expected, not a mistake.
- `.gitignore` only affects files Git isn't tracking yet. If an image was committed before the rule existed, remove it from Git (but keep it on disk) with `git rm --cached <file>`.
- To ignore something else later, such as an editor settings folder, add a line to `.gitignore` and commit the change.

---

## 11. How the pages link together

```
                         ┌──────────────── nav bar (on every page) ────────────────┐
                         │ Logo→Home  Browse  Create*  [Search]  Reading List*  Cart*  Login / Account* │
                         └─────────────────────────────────────────────────────────┘
                                    * members only: guests are sent to login.php

 index.php ──(book card)──────────────► book.php ──(Start/Continue, chapter row)──► read.php
     │                                    ▲  │                                         │
     └─(See all / genre tag)─► browse.php ┘  ├─(+ Add to reading list)─► list_action.php ─► back
                                (result)     ├─(Buy full book)─────────► cart_action.php ─► back
                                             ├─(Edit book, author only)─► create.php?edit=N
                                             └─(review form)─► book.php (posts to itself)

 read.php ──(locked chapter: Add to cart)──► cart_action.php ──► cart.php ──(Pay)──► cart.php?order=N
                                                                                     ├─ success ─► reading_list.php
                                                                                     └─ failed  ─► try again

 create.php ──(Create book)──► create.php?add_chapter=N ──(Publish)──► book.php?id=N

 footer (on every page): About · Feedback · Help · Terms · Privacy · Contact ──► info.php#section
```

---

## 12. Walkthroughs: what happens when you…

### …log in
1. You fill in the form on `login.php` and press **Sign in**.
2. `forms.js` checks that both fields are filled. If one isn't, it shows an error and stops.
3. The browser POSTs to `login.php`. PHP looks up the user (`db_row`) and checks the password with `password_verify()`.
4. If the password is right, `login_user()` stores your id in the **session**, `flash()` saves "Welcome back!", and `safe_redirect()` sends you to the page you came from.
5. On every later page, `header.php` calls `current_user()`, which finds your id in the session. That is why the nav bar now shows your name.

### …buy a book
1. On `book.php` you click **Buy full book**. That form POSTs to `cart_action.php` with `action=add`.
2. `cart_action.php` checks you are logged in and don't already own the book, then runs `INSERT INTO cart_items` and redirects back.
3. On `cart.php` you fill in the card form. `forms.js` checks the card number (Luhn) and expiry.
4. PHP checks everything again, then decides success or failure (does the number start with 4?).
5. Inside one **transaction**, it saves the `orders` + `order_items` rows. On success it also adds the books to `reading_list` and empties `cart_items`.
6. It redirects to `cart.php?order=N`, which reads that order back and shows the result panel.
7. Now `owns_book()` returns true, so `can_read_chapter()` unlocks every chapter in `read.php`.

### …read a chapter
1. `read.php?book=1&ch=5` loads the book and chapter 5.
2. `can_read_chapter()` decides whether you can read it. If not, you see the locked panel.
3. If you can, PHP adds a view to `books.views` and today's `book_views_daily` row, then updates your `reading_list.last_chapter`.
4. Those numbers later appear on Home (Trending), in your Reading List progress bars, and in the admin statistics.

### …publish a book
1. On `create.php` you fill in the form and choose a cover. `forms.js` previews the image and checks the size, type and tag count.
2. PHP validates every field, saves the cover with `upload_image()`, then inserts the book and its tags.
3. The serial number is set to `NB-` + the new book id, padded to 6 digits.
4. You are redirected to `create.php?add_chapter=N` to write chapter 1. Publishing it inserts into `chapters`.
5. The book now appears in **Recently Updated** on Home and in Browse.

---

## 13. Adding a new page

Copy this pattern so the new page gets the same nav bar, footer, login handling and styles:

```php
<?php
require 'includes/init.php';
require_login();                    // only if the page is for members

$books = db_all('SELECT id, title FROM books ORDER BY title');   // get data first

$pageTitle = 'My New Page';         // shown in the browser tab
$pageScripts = ['forms.js'];        // optional JS files from js/
require 'includes/header.php';
?>
            <section>
                <h2>My New Page</h2>
<?php foreach ($books as $book): ?>
                <p><a href="book.php?id=<?= $book['id'] ?>"><?= h($book['title']) ?></a></p>
<?php endforeach; ?>
            </section>
<?php require 'includes/footer.php'; ?>
```

Rules of thumb:
- Do all database work **before** `header.php`, so you can still redirect if needed.
- Always use `?` placeholders with the `db_*` functions. Never paste user input into SQL.
- Always print user or database text through `h()`.

---

## 14. Glossary

| Term | Meaning |
|---|---|
| **GET / POST** | The two ways a form sends data. GET puts it in the URL (`?q=moon`). It's good for searches, and PHP reads it from `$_GET`. POST sends it hidden in the request. It's used for anything that changes data, and PHP reads it from `$_POST` |
| **Session** | PHP's memory of a visitor between pages. A small cookie identifies you, and `$_SESSION` holds data such as your user id |
| **Cookie** | A small piece of text the browser stores and sends back with every request. Used here for the session and "remember my username" |
| **Prepared statement** | SQL written with `?` placeholders. The values are sent separately, so user input can never change the SQL itself (prevents SQL injection) |
| **Escaping (`h()`)** | Turning `<` into `&lt;` and so on, so user text is displayed instead of being run as HTML or JavaScript (prevents XSS) |
| **Hashing (`password_hash`)** | Turning a password into an irreversible code. We store only the hash; `password_verify()` checks a login attempt against it |
| **Redirect** | PHP telling the browser "go to this other page instead" (`header('Location: …')`) |
| **Post/Redirect/Get** | After handling a POST, redirect to a normal page so refreshing doesn't submit the form again |
| **Flash message** | A one-time notice stored in the session and shown on the next page, e.g. "Added to your cart" |
| **Transaction** | A group of database changes that either all succeed or all fail together (used at checkout) |
| **Foreign key / CASCADE** | A column that points to a row in another table. `ON DELETE CASCADE` means "if that row is deleted, delete mine too" |
| **GROUP BY / SUM / AVG / COUNT** | SQL that combines many rows into totals: Trending views, average ratings, admin statistics |
