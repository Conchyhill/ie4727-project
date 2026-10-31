<?php
// Create: publish a new book, edit one of your books, or add a chapter to it.
//   create.php                 -> new book form + "My books" table
//   create.php?edit=ID         -> edit that book (UPDATE)
//   create.php?add_chapter=ID  -> add the next chapter (INSERT)
require 'includes/init.php';
require_login();

const LANGUAGES = ['English', 'Chinese', 'Malay', 'Tamil', 'Japanese', 'Korean', 'Other'];
const MAX_TAGS = 5;

$userId = current_user()['id'];
$editId = (int) param($_GET, 'edit');
$chapterBookId = (int) param($_GET, 'add_chapter');
$errors = [];

// A book the current member wrote, or null
function own_book($bookId, $userId)
{
    return db_row('SELECT * FROM books WHERE id = ? AND user_id = ?', 'ii', [$bookId, $userId]);
}

$editBook = $editId ? own_book($editId, $userId) : null;
$chapterBook = $chapterBookId ? own_book($chapterBookId, $userId) : null;
if (($editId && !$editBook) || ($chapterBookId && !$chapterBook)) {
    flash('You can only edit books that you have written.', 'error');
    header('Location: create.php');
    exit;
}
$mode = $chapterBook ? 'chapter' : ($editBook ? 'edit' : 'new');

$genres = db_all('SELECT id, name FROM genres ORDER BY name');
$allTags = db_all('SELECT id, name FROM tags ORDER BY name');

// Form values: from the POST if the form was just submitted, else from the book being edited
$values = ['title' => '', 'genre_id' => '', 'language' => 'English', 'status' => 'ongoing', 'price' => '2.99', 'synopsis' => '', 'tags' => []];
if ($editBook) {
    $values = array_merge($values, array_intersect_key($editBook, $values));
    $values['tags'] = array_column(db_all('SELECT tag_id FROM book_tags WHERE book_id = ?', 'i', [$editId]), 'tag_id');
}
$chapterTitle = '';
$chapterContent = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($mode === 'new' || $mode === 'edit')) {
    // ---- NEW BOOK / EDIT BOOK ----
    $values['title'] = param($_POST, 'title');
    $values['genre_id'] = (int) param($_POST, 'genre_id');
    $values['language'] = param($_POST, 'language');
    $values['status'] = param($_POST, 'status');
    $values['price'] = param($_POST, 'price');
    $values['synopsis'] = param($_POST, 'synopsis');
    $values['tags'] = isset($_POST['tags']) ? array_map('intval', (array) $_POST['tags']) : [];

    if (mb_strlen($values['title']) < 2 || mb_strlen($values['title']) > 150) {
        $errors[] = 'The title must be between 2 and 150 characters.';
    }
    if (!in_array($values['genre_id'], array_map('intval', array_column($genres, 'id')))) {
        $errors[] = 'Choose a genre.';
    }
    if (!in_array($values['language'], LANGUAGES)) {
        $errors[] = 'Choose a language.';
    }
    if (!in_array($values['status'], ['ongoing', 'completed'])) {
        $errors[] = 'Choose whether the book is ongoing or completed.';
    }
    if (!preg_match('/^\d{1,2}(\.\d{1,2})?$/', $values['price'])) {
        $errors[] = 'Price must be between 0.00 and 99.99.';
    }
    if (mb_strlen($values['synopsis']) < 30 || mb_strlen($values['synopsis']) > 2000) {
        $errors[] = 'The synopsis must be between 30 and 2000 characters.';
    }
    $validTagIds = array_map('intval', array_column($allTags, 'id'));
    $values['tags'] = array_values(array_unique(array_intersect($values['tags'], $validTagIds)));
    if (count($values['tags']) > MAX_TAGS) {
        $errors[] = 'Choose at most ' . MAX_TAGS . ' tags.';
    }
    // same title as another of this author's books?
    if (db_row('SELECT 1 FROM books WHERE user_id = ? AND title = ? AND id <> ?', 'isi', [$userId, $values['title'], $editId])) {
        $errors[] = 'You already have a book with this title.';
    }

    $cover = null;
    if (!$errors) {
        [$cover, $uploadError] = upload_image('cover', 'covers');
        if ($uploadError) {
            $errors[] = $uploadError;
        }
    }

    if (!$errors) {
        $db->begin_transaction();
        if ($mode === 'new') {
            // insert with a temporary serial, then derive the real one from the new id (NB-000021)
            db_query(
                'INSERT INTO books (serial_no, title, user_id, genre_id, language, synopsis, cover, status, price)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                'ssiissssd',
                ['TMP-' . bin2hex(random_bytes(4)), $values['title'], $userId, $values['genre_id'], $values['language'],
                    $values['synopsis'], $cover, $values['status'], $values['price']]
            );
            $bookId = $db->insert_id;
            db_query("UPDATE books SET serial_no = CONCAT('NB-', LPAD(id, 6, '0')) WHERE id = ?", 'i', [$bookId]);
        } else {
            $bookId = $editId;
            db_query(
                'UPDATE books SET title = ?, genre_id = ?, language = ?, synopsis = ?, status = ?, price = ?,
                        cover = COALESCE(?, cover)
                 WHERE id = ? AND user_id = ?',
                'sisssdsii',
                [$values['title'], $values['genre_id'], $values['language'], $values['synopsis'], $values['status'],
                    $values['price'], $cover, $bookId, $userId]
            );
            db_query('DELETE FROM book_tags WHERE book_id = ?', 'i', [$bookId]);
        }
        foreach ($values['tags'] as $tagId) {
            db_query('INSERT INTO book_tags (book_id, tag_id) VALUES (?, ?)', 'ii', [$bookId, $tagId]);
        }
        $db->commit();

        if ($mode === 'new') {
            flash('"' . $values['title'] . '" has been created. Now add your first chapter.');
            header('Location: create.php?add_chapter=' . $bookId);
        } else {
            flash('"' . $values['title'] . '" has been updated.');
            header('Location: book.php?id=' . $bookId);
        }
        exit;
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && $mode === 'chapter') {
    // ---- ADD CHAPTER ----
    $chapterTitle = param($_POST, 'chapter_title');
    $chapterContent = param($_POST, 'content');
    if (mb_strlen($chapterTitle) < 1 || mb_strlen($chapterTitle) > 150) {
        $errors[] = 'The chapter title must be between 1 and 150 characters.';
    }
    if (mb_strlen($chapterContent) < 100) {
        $errors[] = 'The chapter text must be at least 100 characters.';
    }
    if (!$errors) {
        $next = (int) db_row('SELECT COALESCE(MAX(number), 0) + 1 AS n FROM chapters WHERE book_id = ?', 'i', [$chapterBookId])['n'];
        db_query('INSERT INTO chapters (book_id, number, title, content) VALUES (?, ?, ?, ?)', 'iiss',
            [$chapterBookId, $next, $chapterTitle, $chapterContent]);
        flash('Chapter ' . $next . ' of "' . $chapterBook['title'] . '" has been published.');
        header('Location: book.php?id=' . $chapterBookId);
        exit;
    }
}

$myBooks = db_all(
    'SELECT b.id, b.serial_no, b.title, b.status, b.views, g.name AS genre,
            COUNT(c.id) AS chapters,
            (SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id) AS avg_rating
     FROM books b
     JOIN genres g ON g.id = b.genre_id
     LEFT JOIN chapters c ON c.book_id = b.id
     WHERE b.user_id = ?
     GROUP BY b.id
     ORDER BY b.created_at DESC',
    'i', [$userId]
);

$pageTitle = $mode === 'chapter' ? 'Add chapter' : ($mode === 'edit' ? 'Edit book' : 'Create');
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
<?php if ($mode === 'chapter'): ?>
<?php $nextNumber = (int) db_row('SELECT COALESCE(MAX(number), 0) + 1 AS n FROM chapters WHERE book_id = ?', 'i', [$chapterBookId])['n']; ?>
            <!-- ADD CHAPTER -->
            <section>
                <h2>Add Chapter <?= $nextNumber ?> to &ldquo;<?= h($chapterBook['title']) ?>&rdquo;</h2>
                <form action="create.php?add_chapter=<?= $chapterBookId ?>" method="post" class="stackForm wideForm" id="chapterForm" novalidate>
<?php foreach ($errors as $error): ?>
                    <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                    <label for="chapterTitle">Chapter title</label>
                    <input type="text" id="chapterTitle" name="chapter_title" value="<?= h($chapterTitle) ?>" required maxlength="150">
                    <p class="fieldError"></p>
                    <label for="content">Chapter text <span class="hint">(leave a blank line between paragraphs)</span></label>
                    <textarea id="content" name="content" rows="18" required minlength="100"><?= h($chapterContent) ?></textarea>
                    <span class="charCount" data-for="content"></span>
                    <p class="fieldError"></p>
                    <div class="formActions">
                        <button type="submit" class="btn">Publish chapter</button>
                        <a class="btn btnSecondary" href="book.php?id=<?= $chapterBookId ?>">Cancel</a>
                    </div>
                </form>
            </section>
<?php else: ?>
            <!-- NEW / EDIT BOOK -->
            <section>
                <h2><?= $mode === 'edit' ? 'Edit &ldquo;' . h($editBook['title']) . '&rdquo;' : 'Publish a new book' ?></h2>
                <form action="create.php<?= $mode === 'edit' ? '?edit=' . $editId : '' ?>" method="post" enctype="multipart/form-data"
                      class="createForm" id="bookForm" novalidate>
<?php foreach ($errors as $error): ?>
                    <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                    <div class="createFields stackForm">
                        <label for="title">Title</label>
                        <input type="text" id="title" name="title" value="<?= h($values['title']) ?>" required minlength="2" maxlength="150">
                        <p class="fieldError"></p>

                        <div class="fieldRow">
                            <div>
                                <label for="genre">Genre</label>
                                <select id="genre" name="genre_id" required>
                                    <option value="">Choose a genre</option>
<?php foreach ($genres as $genre): ?>
                                    <option value="<?= $genre['id'] ?>"<?= $values['genre_id'] == $genre['id'] ? ' selected' : '' ?>><?= h($genre['name']) ?></option>
<?php endforeach; ?>
                                </select>
                                <p class="fieldError"></p>
                            </div>
                            <div>
                                <label for="language">Language</label>
                                <select id="language" name="language" required>
<?php foreach (LANGUAGES as $language): ?>
                                    <option<?= $values['language'] === $language ? ' selected' : '' ?>><?= $language ?></option>
<?php endforeach; ?>
                                </select>
                                <p class="fieldError"></p>
                            </div>
                            <div>
                                <label for="price">Price (SGD)</label>
                                <input type="number" id="price" name="price" value="<?= h($values['price']) ?>" min="0" max="99.99" step="0.01" required>
                                <p class="fieldError"></p>
                            </div>
                        </div>

                        <fieldset>
                            <legend>Status</legend>
                            <label class="checkLabel"><input type="radio" name="status" value="ongoing"<?= $values['status'] === 'ongoing' ? ' checked' : '' ?> required> Ongoing</label>
                            <label class="checkLabel"><input type="radio" name="status" value="completed"<?= $values['status'] === 'completed' ? ' checked' : '' ?>> Completed</label>
                        </fieldset>

                        <fieldset id="tagPicker" data-max="<?= MAX_TAGS ?>">
                            <legend>Tags <span class="hint">(up to <?= MAX_TAGS ?>)</span></legend>
                            <div class="tagChecks">
<?php foreach ($allTags as $tag): ?>
                                <label class="checkLabel"><input type="checkbox" name="tags[]" value="<?= $tag['id'] ?>"<?= in_array($tag['id'], $values['tags']) ? ' checked' : '' ?>> <?= h($tag['name']) ?></label>
<?php endforeach; ?>
                            </div>
                            <p class="fieldError"></p>
                        </fieldset>

                        <label for="synopsis">Synopsis</label>
                        <textarea id="synopsis" name="synopsis" rows="6" required minlength="30" maxlength="2000"><?= h($values['synopsis']) ?></textarea>
                        <span class="charCount" data-for="synopsis"></span>
                        <p class="fieldError"></p>
                    </div>

                    <div class="createCover">
                        <label for="cover">Cover image <span class="hint">(3:4, max 2 MB, optional)</span></label>
                        <img id="coverPreview" src="<?= h(cover_url($editBook ? $editBook['cover'] : null)) ?>" alt="Cover preview">
                        <input type="file" id="cover" name="cover" accept="image/jpeg,image/png,image/gif,image/webp"
                               data-max-size="2097152" data-preview="coverPreview">
                        <p class="fieldError"></p>
                    </div>

                    <div class="formActions">
                        <button type="submit" class="btn"><?= $mode === 'edit' ? 'Save changes' : 'Create book' ?></button>
<?php if ($mode === 'edit'): ?>
                        <a class="btn btnSecondary" href="book.php?id=<?= $editId ?>">Cancel</a>
<?php endif; ?>
                    </div>
                </form>
            </section>
<?php endif; ?>

            <!-- MY BOOKS -->
            <section>
                <h2>My books</h2>
<?php if (!$myBooks): ?>
                <p class="emptyNote">You haven't published any books yet. Use the form above to create your first one.</p>
<?php else: ?>
                <table class="dataTable">
                    <thead>
                        <tr><th scope="col">Title</th><th scope="col">Serial no.</th><th scope="col">Genre</th><th scope="col">Chapters</th>
                            <th scope="col">Views</th><th scope="col">Rating</th><th scope="col">Status</th><th scope="col">Actions</th></tr>
                    </thead>
                    <tbody>
<?php foreach ($myBooks as $book): ?>
                        <tr>
                            <td><a href="book.php?id=<?= $book['id'] ?>"><?= h($book['title']) ?></a></td>
                            <td><?= h($book['serial_no']) ?></td>
                            <td><?= h($book['genre']) ?></td>
                            <td><?= $book['chapters'] ?></td>
                            <td><?= format_views($book['views']) ?></td>
                            <td><?= $book['avg_rating'] === null ? '-' : number_format($book['avg_rating'], 1) ?></td>
                            <td><span class="status status-<?= $book['status'] ?>"><?= ucfirst($book['status']) ?></span></td>
                            <td class="actions">
                                <a href="create.php?edit=<?= $book['id'] ?>">Edit</a>
                                <a href="create.php?add_chapter=<?= $book['id'] ?>">+ Chapter</a>
                            </td>
                        </tr>
<?php endforeach; ?>
                    </tbody>
                </table>
<?php endif; ?>
            </section>
<?php require 'includes/footer.php'; ?>
