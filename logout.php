<?php
// Ends the session and returns to Home. POST only, so a link or prefetch can't log someone out.
require 'includes/init.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $_SESSION = [];
    session_destroy();
    session_start();
    flash('You have been logged out.');
}
header('Location: index.php');
exit;
