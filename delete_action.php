<?php
// Deletes a book, a chapter or a review, then goes back to the page it came from.
// POST: type (book | chapter | review), book_id, plus number (chapter) or user_id (review), back
// Who may delete:
//   book    -> its author or the admin, but only while nobody has bought it
//   chapter -> the book's author or the admin; later chapters move up one number
//   review  -> the member who wrote it or the admin
require 'includes/init.php';

$back = isset($_POST['back']) ? $_POST['back'] : 'index.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    safe_redirect($back);
}
if (!is_logged_in()) {
    flash('Please log in first.', 'error');
    header('Location: login.php?redirect=' . urlencode($back));
    exit;
}

$user = current_user();
$type = param($_POST, 'type');
$bookId = (int) param($_POST, 'book_id');
$book = db_row('SELECT id, title, user_id, cover FROM books WHERE id = ?', 'i', [$bookId]);
$canManage = $book && ($book['user_id'] == $user['id'] || is_admin());

if ($book === null) {
    flash('That book does not exist.', 'error');
} elseif ($type === 'book') {
    // ---- DELETE BOOK ----
    $sales = (int) db_row(
        "SELECT COUNT(*) AS n FROM order_items oi JOIN orders o ON o.id = oi.order_id
         WHERE oi.book_id = ? AND o.status = 'success'",
        'i', [$bookId]
    )['n'];
    if (!$canManage) {
        flash('You can only delete books that you have written.', 'error');
    } elseif ($sales > 0) {
        // buyers would lose a book they paid for, and their order history would change
        flash('"' . $book['title'] . '" has been bought ' . $sales . ' time' . ($sales > 1 ? 's' : '')
            . ', so it cannot be deleted. You can still edit it or mark it as completed.', 'error');
    } else {
        // chapters, reviews, tags, views, reading lists and cart items go with it (ON DELETE CASCADE)
        db_query('DELETE FROM books WHERE id = ?', 'i', [$bookId]);
        // remove an uploaded cover file (seed covers in images/ are kept)
        if ($book['cover'] && strpos($book['cover'], 'uploads/covers/') === 0 && is_file(__DIR__ . '/' . $book['cover'])) {
            unlink(__DIR__ . '/' . $book['cover']);
        }
        flash('"' . $book['title'] . '" has been deleted.');
        // the book page no longer exists, so never go back there
        if (strpos($back, 'book.php') !== false || strpos($back, 'create.php?') !== false) {
            $back = $book['user_id'] == $user['id'] ? 'create.php' : 'browse.php';
        }
    }
} elseif ($type === 'chapter') {
    // ---- DELETE CHAPTER ----
    $number = (int) param($_POST, 'number');
    $chapter = db_row('SELECT title FROM chapters WHERE book_id = ? AND number = ?', 'ii', [$bookId, $number]);
    if (!$canManage) {
        flash('You can only delete chapters of books that you have written.', 'error');
    } elseif ($chapter === null) {
        flash('That chapter does not exist.', 'error');
    } else {
        $db->begin_transaction();
        db_query('DELETE FROM chapters WHERE book_id = ? AND number = ?', 'ii', [$bookId, $number]);
        // close the gap: chapter n+1 becomes n, and so on (ascending order avoids a duplicate number)
        db_query('UPDATE chapters SET number = number - 1 WHERE book_id = ? AND number > ? ORDER BY number',
            'ii', [$bookId, $number]);
        // readers who got past the deleted chapter keep the same place in the story
        db_query('UPDATE reading_list SET last_chapter = last_chapter - 1, updated_at = updated_at
                  WHERE book_id = ? AND last_chapter >= ?', 'ii', [$bookId, $number]);
        db_query('DELETE FROM reading_list WHERE book_id = ? AND in_library = 0 AND last_chapter = 0', 'i', [$bookId]);
        $db->commit();
        flash('Chapter ' . $number . ' ("' . $chapter['title'] . '") has been deleted. Later chapters were renumbered.');
    }
    // the chapter's own pages (reader, edit form) may now show a different chapter, so go to the contents
    $back = 'book.php?id=' . $bookId . '#chapters';
} elseif ($type === 'review') {
    // ---- DELETE REVIEW ----
    $reviewerId = (int) param($_POST, 'user_id');
    $review = db_row('SELECT 1 FROM reviews WHERE book_id = ? AND user_id = ?', 'ii', [$bookId, $reviewerId]);
    if ($reviewerId != $user['id'] && !is_admin()) {
        flash('You can only delete your own reviews.', 'error');
    } elseif ($review === null) {
        flash('That review does not exist.', 'error');
    } else {
        db_query('DELETE FROM reviews WHERE book_id = ? AND user_id = ?', 'ii', [$bookId, $reviewerId]);
        flash($reviewerId == $user['id'] ? 'Your review has been deleted.' : 'The review has been deleted.');
    }
} else {
    flash('Nothing was deleted.', 'error');
}

safe_redirect($back);
