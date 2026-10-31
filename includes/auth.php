<?php
// Session handling and login checks. Include after db.php.
session_start();

// Logged-in user's row, or null for guests
function current_user()
{
    static $user = false;
    if ($user === false) {
        $user = null;
        if (isset($_SESSION['user_id'])) {
            $user = db_row('SELECT id, username, email, photo, role FROM users WHERE id = ?', 'i', [$_SESSION['user_id']]);
            if ($user === null) {
                unset($_SESSION['user_id']);  // account was deleted
            }
        }
    }
    return $user;
}

function is_logged_in()
{
    return current_user() !== null;
}

function is_admin()
{
    $user = current_user();
    return $user !== null && $user['role'] === 'admin';
}

// Members-only pages: send guests to the login page, then back here afterwards
function require_login()
{
    if (!is_logged_in()) {
        flash('Please log in to continue.', 'error');
        header('Location: login.php?redirect=' . urlencode($_SERVER['REQUEST_URI']));
        exit;
    }
}

function login_user($userId)
{
    session_regenerate_id(true);  // new session id on login prevents session fixation
    $_SESSION['user_id'] = $userId;
}

// Only allow redirects back to our own pages (no "http://" or "//" external URLs)
// Accepts "book.php?id=1" or "/IE4727/.../book.php?id=1" (a path inside this site's folder).
function safe_redirect($target, $fallback = 'index.php')
{
    $base = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'])), '/') . '/';
    $isPage = is_string($target) && preg_match('#^[a-z_]+\.php(\?[^\r\n]*)?$#i', $target);
    $isLocalPath = is_string($target) && strpos($target, $base) === 0 && strpos($target, '//') === false
        && !preg_match('#[\r\n]#', $target);
    header('Location: ' . ($isPage || $isLocalPath ? $target : $fallback));
    exit;
}
