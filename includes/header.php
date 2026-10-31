<?php
// Page head and navigation bar. Set $pageTitle (and optionally $pageScripts) before including.
$pageScripts = isset($pageScripts) ? $pageScripts : [];
$currentPage = basename($_SERVER['SCRIPT_NAME']);
$navUser = current_user();
$cartCount = cart_count();

// class="active" for the nav link of the current page
function nav_class($page)
{
    global $currentPage;
    return $currentPage === $page ? ' class="active"' : '';
}
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title><?= h($pageTitle) ?> | <?= h(SITE_NAME) ?></title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/style.css">
<?php foreach ($pageScripts as $script): ?>
        <script src="js/<?= h($script) ?>" defer></script>
<?php endforeach; ?>
    </head>
    <body>
        <!-- NAVIGATION BAR (layout per Wireframe: logo, Browse, Create, search, Reading list, Cart, Login) -->
        <!-- Create, Reading List and Cart require login; require_login() on those pages sends guests to login.php -->
        <div id="navBar">
            <div class="navBarInner">
                <ul class="navBarLeft">
                    <li><a href="index.php"><img src="images/logo_placeholder.jpg" alt="Home" width="50" height="50"></a></li>
                    <li><a href="browse.php"<?= nav_class('browse.php') ?>>Browse</a></li>
                    <li><a href="create.php"<?= nav_class('create.php') ?>>Create</a></li>
                </ul>
                <form class="navSearch" action="browse.php" method="get">
                    <input type="search" name="q" placeholder="Search books, authors..." aria-label="Search books"
                           value="<?= $currentPage === 'browse.php' ? h(param($_GET, 'q')) : '' ?>" required>
                    <button type="submit">Search</button>
                </form>
                <ul class="navBarRight">
                    <li><a href="reading_list.php"<?= nav_class('reading_list.php') ?>>Reading List</a></li>
                    <li>
                        <a href="cart.php"<?= nav_class('cart.php') ?>>Shopping Cart<?php if ($cartCount > 0): ?>
                            <span class="cartBadge"><?= $cartCount ?></span><?php endif; ?></a>
                    </li>
<?php if ($navUser): ?>
                    <li><a href="account.php"<?= nav_class('account.php') ?>><?= h($navUser['username']) ?></a></li>
                    <li>
                        <form action="logout.php" method="post" class="logoutForm">
                            <button type="submit">Logout</button>
                        </form>
                    </li>
<?php else: ?>
                    <li><a href="login.php"<?= nav_class('login.php') ?>>Login</a></li>
<?php endif; ?>
                </ul>
            </div>
        </div>

        <main class="container">
<?php show_flash(); ?>
