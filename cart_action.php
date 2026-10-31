<?php
// Adds or removes a book from the shopping cart, then goes back to the page it came from.
// POST: book_id, action (add | remove), back (page to return to)
require 'includes/init.php';

$back = isset($_POST['back']) ? $_POST['back'] : 'cart.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    safe_redirect($back);
}
if (!is_logged_in()) {
    flash('Please log in to buy books.', 'error');
    header('Location: login.php?redirect=' . urlencode($back));
    exit;
}

$userId = current_user()['id'];
$bookId = isset($_POST['book_id']) ? (int) $_POST['book_id'] : 0;
$action = isset($_POST['action']) ? $_POST['action'] : '';
$book = db_row('SELECT id, title, user_id, price FROM books WHERE id = ?', 'i', [$bookId]);

if ($book === null) {
    flash('That book does not exist.', 'error');
} elseif ($action === 'add') {
    if ($book['user_id'] == $userId) {
        flash('You are the author of this book, so you can already read all of it.', 'error');
    } elseif ((float) $book['price'] == 0) {
        flash('This book is free to read.', 'error');
    } elseif (owns_book($userId, $bookId)) {
        flash('You already own this book.', 'error');
    } else {
        db_query('INSERT IGNORE INTO cart_items (user_id, book_id) VALUES (?, ?)', 'ii', [$userId, $bookId]);
        flash('"' . $book['title'] . '" was added to your cart.');
    }
} elseif ($action === 'remove') {
    db_query('DELETE FROM cart_items WHERE user_id = ? AND book_id = ?', 'ii', [$userId, $bookId]);
    flash('"' . $book['title'] . '" was removed from your cart.');
}

safe_redirect($back, 'cart.php');
