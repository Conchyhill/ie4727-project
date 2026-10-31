<?php
// Chapter reader. Free chapters are open to everyone; later chapters need the book to be bought.
// Each read adds a view (all-time and today's count) and updates the member's reading progress.
require 'includes/init.php';

$bookId = (int) param($_GET, 'book');
$number = max(1, (int) param($_GET, 'ch'));
$user = current_user();

$book = db_row('SELECT id, title, user_id, price FROM books WHERE id = ?', 'i', [$bookId]);
$chapter = $book ? db_row('SELECT number, title, content, created_at FROM chapters WHERE book_id = ? AND number = ?', 'ii', [$bookId, $number]) : null;

if ($chapter === null) {
    http_response_code(404);
    $pageTitle = 'Chapter not found';
    require 'includes/header.php';
    echo '<section><h2>Chapter not found</h2><p>This chapter does not exist. ';
    echo $book ? '<a href="book.php?id=' . $bookId . '">Back to ' . h($book['title']) . '</a>' : '<a href="browse.php">Browse books</a>';
    echo '.</p></section>';
    require 'includes/footer.php';
    exit;
}

$allChapters = db_all('SELECT number, title FROM chapters WHERE book_id = ? ORDER BY number', 'i', [$bookId]);
$lastNumber = (int) end($allChapters)['number'];
$canRead = can_read_chapter($book, $number);

if ($canRead) {
    db_query('UPDATE books SET views = views + 1 WHERE id = ?', 'i', [$bookId]);
    db_query('INSERT INTO book_views_daily (book_id, view_date, views) VALUES (?, CURDATE(), 1)
              ON DUPLICATE KEY UPDATE views = views + 1', 'i', [$bookId]);
    if ($user) {
        // History keeps the furthest chapter reached; reading doesn't add the book to the Library tab
        db_query('INSERT INTO reading_list (user_id, book_id, in_library, last_chapter) VALUES (?, ?, 0, ?)
                  ON DUPLICATE KEY UPDATE last_chapter = GREATEST(last_chapter, VALUES(last_chapter)), updated_at = NOW()',
            'iii', [$user['id'], $bookId, $number]);
    }
}

$inCart = $user && db_row('SELECT 1 FROM cart_items WHERE user_id = ? AND book_id = ?', 'ii', [$user['id'], $bookId]) !== null;
$here = 'read.php?book=' . $bookId . '&ch=' . $number;

$pageTitle = 'Ch. ' . $number . ': ' . $chapter['title'] . ' - ' . $book['title'];
$pageScripts = ['reader.js'];
require 'includes/header.php';

// Previous / chapter picker / next, shown above and below the text
function chapter_nav($bookId, $number, $lastNumber, $allChapters, $position)
{
    ?>
            <nav class="chapterNav" aria-label="Chapter navigation">
<?php if ($number > 1): ?>
                <a class="btn btnSecondary" href="read.php?book=<?= $bookId ?>&amp;ch=<?= $number - 1 ?>" rel="prev" data-nav="prev">&lsaquo; Previous</a>
<?php else: ?>
                <span class="btn btnSecondary disabled">&lsaquo; Previous</span>
<?php endif; ?>
                <form action="read.php" method="get" class="chapterPicker">
                    <input type="hidden" name="book" value="<?= $bookId ?>">
                    <label for="chapterSelect<?= $position ?>" class="visuallyHidden">Jump to chapter</label>
                    <select name="ch" id="chapterSelect<?= $position ?>" class="chapterSelect">
<?php foreach ($allChapters as $c): ?>
                        <option value="<?= $c['number'] ?>"<?= $c['number'] == $number ? ' selected' : '' ?>>Ch. <?= $c['number'] ?>: <?= h($c['title']) ?></option>
<?php endforeach; ?>
                    </select>
                    <noscript><button type="submit" class="btn">Go</button></noscript>
                </form>
<?php if ($number < $lastNumber): ?>
                <a class="btn" href="read.php?book=<?= $bookId ?>&amp;ch=<?= $number + 1 ?>" rel="next" data-nav="next">Next &rsaquo;</a>
<?php else: ?>
                <span class="btn disabled">Next &rsaquo;</span>
<?php endif; ?>
            </nav>
<?php
}
?>
            <nav class="breadcrumb" aria-label="Breadcrumb">
                <a href="index.php">Home</a> /
                <a href="book.php?id=<?= $bookId ?>"><?= h($book['title']) ?></a> /
                <span>Chapter <?= $number ?></span>
            </nav>

            <?php chapter_nav($bookId, $number, $lastNumber, $allChapters, 'Top'); ?>

            <article class="reader" id="reader">
                <div class="readerTools">
                    <span>Text size</span>
                    <button type="button" class="btn btnSecondary" data-font="-1" aria-label="Smaller text">A&minus;</button>
                    <button type="button" class="btn btnSecondary" data-font="1" aria-label="Larger text">A+</button>
                </div>
                <h1>Chapter <?= $number ?>: <?= h($chapter['title']) ?></h1>
                <p class="chapterDate">Published <?= date('j M Y', strtotime($chapter['created_at'])) ?></p>

<?php if ($canRead): ?>
                <div class="chapterText">
<?php foreach (preg_split('/\R\s*\R/', trim($chapter['content'])) as $paragraph): ?>
                    <p><?= nl2br(h(trim($paragraph))) ?></p>
<?php endforeach; ?>
                </div>
<?php else: ?>
                <!-- LOCKED CHAPTER -->
                <div class="lockedPanel">
                    <p class="lockIcon">&#128274;</p>
                    <h2>This chapter is locked</h2>
                    <p>Chapters 1&ndash;<?= FREE_CHAPTERS ?> are free. Buy <strong><?= h($book['title']) ?></strong>
                        for <?= money($book['price']) ?> to read all <?= count($allChapters) ?> chapters.</p>
<?php if (!$user): ?>
                    <a class="btn" href="login.php?redirect=<?= urlencode($here) ?>">Log in to buy</a>
<?php elseif ($inCart): ?>
                    <a class="btn" href="cart.php">Go to cart &rsaquo;</a>
<?php else: ?>
                    <form action="cart_action.php" method="post">
                        <input type="hidden" name="book_id" value="<?= $bookId ?>">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="back" value="cart.php">
                        <button type="submit" class="btn">Add to cart &middot; <?= money($book['price']) ?></button>
                    </form>
<?php endif; ?>
                </div>
<?php endif; ?>
            </article>

            <?php chapter_nav($bookId, $number, $lastNumber, $allChapters, 'Bottom'); ?>
<?php require 'includes/footer.php'; ?>
