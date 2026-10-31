<?php
// Adds or removes a book from the member's reading list, then goes back to the page it came from.
// POST: book_id, action (add | remove | forget), back (page to return to)
require 'includes/init.php';

$back = isset($_POST['back']) ? $_POST['back'] : 'reading_list.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    safe_redirect($back);
}
if (!is_logged_in()) {
    flash('Please log in to use your reading list.', 'error');
    header('Location: login.php?redirect=' . urlencode($back));
    exit;
}

$userId = current_user()['id'];
$bookId = isset($_POST['book_id']) ? (int) $_POST['book_id'] : 0;
$action = isset($_POST['action']) ? $_POST['action'] : '';
$book = db_row('SELECT title FROM books WHERE id = ?', 'i', [$bookId]);

if ($book === null) {
    flash('That book does not exist.', 'error');
} elseif ($action === 'add') {
    db_query('INSERT INTO reading_list (user_id, book_id, in_library) VALUES (?, ?, 1)
              ON DUPLICATE KEY UPDATE in_library = 1', 'ii', [$userId, $bookId]);
    flash('"' . $book['title'] . '" was added to your library.');
} elseif ($action === 'remove' || $action === 'forget') {
    // remove = take off the Library tab, forget = clear from the History tab
    $column = $action === 'remove' ? 'in_library = 0' : 'last_chapter = 0';
    db_query("UPDATE reading_list SET $column WHERE user_id = ? AND book_id = ?", 'ii', [$userId, $bookId]);
    // a row that is in neither tab is no longer needed
    db_query('DELETE FROM reading_list WHERE user_id = ? AND book_id = ? AND in_library = 0 AND last_chapter = 0',
        'ii', [$userId, $bookId]);
    flash('"' . $book['title'] . '" was removed from your ' . ($action === 'remove' ? 'library.' : 'history.'));
}

safe_redirect($back, 'reading_list.php');
