<?php
// Member's reading list: Library tab (saved books) and History tab (recently read), with progress.
require 'includes/init.php';
require_login();

$userId = current_user()['id'];
$tab = param($_GET, 'tab') === 'history' ? 'history' : 'library';
$condition = $tab === 'history' ? 'rl.last_chapter > 0' : 'rl.in_library = 1';

$books = db_all(
    "SELECT b.id, b.title, b.cover, g.name AS genre, rl.last_chapter, rl.in_library,
            (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS total_chapters,
            TIMESTAMPDIFF(SECOND, rl.updated_at, NOW()) AS seconds_ago
     FROM reading_list rl
     JOIN books b ON b.id = rl.book_id
     JOIN genres g ON g.id = b.genre_id
     WHERE rl.user_id = ? AND $condition
     ORDER BY rl.updated_at DESC",
    'i', [$userId]
);
$counts = db_row(
    'SELECT SUM(in_library = 1) AS library, SUM(last_chapter > 0) AS history FROM reading_list WHERE user_id = ?',
    'i', [$userId]
);
$here = 'reading_list.php?tab=' . $tab;

$pageTitle = 'Reading List';
require 'includes/header.php';
?>
            <section>
                <div class="sectionHeader">
                    <h2>Reading List</h2>
                    <div class="periodToggle">
                        <a href="reading_list.php?tab=library"<?= $tab === 'library' ? ' class="active"' : '' ?>>Library (<?= (int) $counts['library'] ?>)</a>
                        <a href="reading_list.php?tab=history"<?= $tab === 'history' ? ' class="active"' : '' ?>>History (<?= (int) $counts['history'] ?>)</a>
                    </div>
                </div>

<?php if (!$books): ?>
                <p class="emptyNote">
                    <?= $tab === 'library'
                        ? 'Your library is empty. Use "+ Add" on any book to save it here.'
                        : 'You haven\'t read any chapters yet.' ?>
                    <a href="browse.php">Browse books</a>.
                </p>
<?php endif; ?>

                <div class="bookGrid">
<?php foreach ($books as $book): ?>
<?php
    $total = max(1, (int) $book['total_chapters']);
    $read = min((int) $book['last_chapter'], $total);
    $next = min($read + 1, $total);
?>
                    <div class="bookCard listCard">
                        <a href="book.php?id=<?= $book['id'] ?>">
                            <img src="<?= h(cover_url($book['cover'])) ?>" alt="Cover of <?= h($book['title']) ?>">
                        </a>
                        <a class="bookName" href="book.php?id=<?= $book['id'] ?>"><?= h($book['title']) ?></a>
                        <span class="bookGenre"><?= h($book['genre']) ?></span>
                        <div class="progress" title="<?= $read ?> of <?= $book['total_chapters'] ?> chapters read">
                            <span style="width: <?= round($read / $total * 100) ?>%"></span>
                        </div>
                        <span class="progressText"><?= $read ?>/<?= $book['total_chapters'] ?>
                            <?= $tab === 'history' ? '&middot; ' . time_ago($book['seconds_ago']) : '' ?></span>
                        <a class="btn btnSmall" href="read.php?book=<?= $book['id'] ?>&amp;ch=<?= $read === 0 || $read >= $total ? 1 : $next ?>">
                            <?= $read === 0 ? 'Start' : ($read >= $total ? 'Read again' : 'Continue Ch. ' . $next) ?></a>
                        <form action="list_action.php" method="post">
                            <input type="hidden" name="book_id" value="<?= $book['id'] ?>">
                            <input type="hidden" name="action" value="<?= $tab === 'history' ? 'forget' : 'remove' ?>">
                            <input type="hidden" name="back" value="<?= h($here) ?>">
                            <button type="submit" class="linkButton">Remove</button>
                        </form>
                    </div>
<?php endforeach; ?>
                </div>
            </section>
<?php require 'includes/footer.php'; ?>
