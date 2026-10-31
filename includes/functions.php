<?php
// Helper functions shared by the pages.

// Chapters 1..FREE_CHAPTERS of every book can be read without buying it
const FREE_CHAPTERS = 3;

// Escape text for HTML output
function h($text)
{
    return htmlspecialchars((string) $text, ENT_QUOTES, 'UTF-8');
}

// Trimmed string from $_GET / $_POST, or '' when missing (or not a string, e.g. ?q[]=x)
function param($source, $key)
{
    return isset($source[$key]) && is_string($source[$key]) ? trim($source[$key]) : '';
}

// Same rule as the browser's <input type="email"> check, so "name@localhost" passes on both sides
function valid_email($email)
{
    return strlen($email) <= 100 && preg_match(
        "/^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/",
        $email
    ) === 1;
}

// 27400000 -> "27.4M", 980500 -> "980.5K"
function format_views($n)
{
    if ($n >= 1000000) {
        return round($n / 1000000, 1) . 'M';
    }
    if ($n >= 1000) {
        return round($n / 1000, 1) . 'K';
    }
    return (string) $n;
}

function money($amount)
{
    return '$' . number_format((float) $amount, 2);
}

// Seconds come from TIMESTAMPDIFF in SQL so PHP and MySQL time zones can't disagree
function time_ago($seconds)
{
    $units = [86400 * 30 => 'month', 86400 * 7 => 'week', 86400 => 'day', 3600 => 'hour', 60 => 'minute'];
    foreach ($units as $size => $name) {
        if ($seconds >= $size) {
            $n = intdiv($seconds, $size);
            return $n . ' ' . $name . ($n > 1 ? 's' : '') . ' ago';
        }
    }
    return 'just now';
}

// 4.3 -> "★★★★☆ 4.3", or "No ratings" when there are none
function stars($rating)
{
    if ($rating === null) {
        return 'No ratings';
    }
    $full = (int) round($rating);
    return str_repeat('&#9733;', $full) . str_repeat('&#9734;', 5 - $full) . ' ' . number_format($rating, 1);
}

function cover_url($cover)
{
    return $cover ? $cover : 'images/cover_placeholder.svg';
}

function avatar_url($photo)
{
    return $photo ? $photo : 'images/avatar_default.svg';
}

// Save an uploaded image to uploads/$folder. Returns [path, error]; both null when no file was chosen.
function upload_image($field, $folder)
{
    if (!isset($_FILES[$field]) || $_FILES[$field]['error'] === UPLOAD_ERR_NO_FILE) {
        return [null, null];
    }
    $file = $_FILES[$field];
    if ($file['error'] !== UPLOAD_ERR_OK) {
        return [null, 'The image could not be uploaded.'];
    }
    if ($file['size'] > 2 * 1024 * 1024) {
        return [null, 'Images must be 2 MB or smaller.'];
    }
    // Check the real file contents, not just the extension the browser sent
    $info = @getimagesize($file['tmp_name']);
    $types = [IMAGETYPE_JPEG => 'jpg', IMAGETYPE_PNG => 'png', IMAGETYPE_GIF => 'gif', IMAGETYPE_WEBP => 'webp'];
    if ($info === false || !isset($types[$info[2]])) {
        return [null, 'Only JPG, PNG, GIF or WEBP images are allowed.'];
    }
    $path = 'uploads/' . $folder . '/' . bin2hex(random_bytes(8)) . '.' . $types[$info[2]];
    if (!move_uploaded_file($file['tmp_name'], __DIR__ . '/../' . $path)) {
        return [null, 'The image could not be saved.'];
    }
    return [$path, null];
}

// Has this user bought the book (in a successful order)?
function owns_book($userId, $bookId)
{
    return db_row(
        "SELECT 1 FROM orders o JOIN order_items oi ON oi.order_id = o.id
         WHERE o.user_id = ? AND oi.book_id = ? AND o.status = 'success' LIMIT 1",
        'ii', [$userId, $bookId]
    ) !== null;
}

// Free chapters, free books, the author and buyers can read; $book needs id, user_id and price
function can_read_chapter($book, $chapterNumber)
{
    if ($chapterNumber <= FREE_CHAPTERS || (float) $book['price'] == 0) {
        return true;
    }
    $user = current_user();
    if ($user === null) {
        return false;
    }
    return $user['id'] == $book['user_id'] || owns_book($user['id'], $book['id']);
}

// One-off message shown on the next page load (e.g. after a redirect)
function flash($message, $type = 'success')
{
    $_SESSION['flash'] = [$message, $type];
}

function show_flash()
{
    if (isset($_SESSION['flash'])) {
        [$message, $type] = $_SESSION['flash'];
        unset($_SESSION['flash']);
        echo '<p class="flash flash-' . h($type) . '">' . h($message) . '</p>';
    }
}

// Number of items in the member's cart, for the nav badge
function cart_count()
{
    $user = current_user();
    if ($user === null) {
        return 0;
    }
    return (int) db_row('SELECT COUNT(*) AS n FROM cart_items WHERE user_id = ?', 'i', [$user['id']])['n'];
}
