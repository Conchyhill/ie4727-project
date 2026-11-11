<?php
// Book information: details, reading list / cart buttons, chapter table and reviews.
require 'includes/init.php';

$bookId = (int) param($_GET, 'id');
$user = current_user();

$book = db_row(
    'SELECT b.*, u.username AS author, g.name AS genre, g.slug AS genre_slug,
            (SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id) AS avg_rating,
            (SELECT COUNT(*) FROM reviews r WHERE r.book_id = b.id) AS review_count
     FROM books b
     JOIN users u ON u.id = b.user_id
     JOIN genres g ON g.id = b.genre_id
     WHERE b.id = ?',
    'i', [$bookId]
);

if ($book === null) {
    http_response_code(404);
    $pageTitle = 'Book not found';
    require 'includes/header.php';
    echo '<section><h2>Book not found</h2><p>This book does not exist or has been removed. <a href="browse.php">Browse all books</a>.</p></section>';
    require 'includes/footer.php';
    exit;
}

$isAuthor = $user && $user['id'] == $book['user_id'];
$isAdmin = is_admin();
$canManage = $isAuthor || $isAdmin;  // may delete chapters and the book (only the author may edit them)

// ---- Review form (POST to this page) ----
$reviewErrors = [];
$reviewRating = '';
$reviewComment = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && param($_POST, 'action') === 'review') {
    $reviewRating = (int) param($_POST, 'rating');
    $reviewComment = param($_POST, 'comment');
    if (!$user) {
        $reviewErrors[] = 'Please log in to write a review.';
    } elseif ($isAuthor) {
        $reviewErrors[] = 'You cannot review your own book.';
    }
    if ($reviewRating < 1 || $reviewRating > 5) {
        $reviewErrors[] = 'Choose a rating from 1 to 5 stars.';
    }
    if (mb_strlen($reviewComment) < 10 || mb_strlen($reviewComment) > 1000) {
        $reviewErrors[] = 'Your review must be between 10 and 1000 characters.';
    }
    if (!$reviewErrors) {
        // one review per member per book: a second submit replaces the first
        db_query(
            'INSERT INTO reviews (book_id, user_id, rating, comment) VALUES (?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment), created_at = NOW()',
            'iiis', [$bookId, $user['id'], $reviewRating, $reviewComment]
        );
        flash('Thanks, your review has been saved.');
        header('Location: book.php?id=' . $bookId . '#reviews');
        exit;
    }
}

$tags = db_all('SELECT t.name FROM book_tags bt JOIN tags t ON t.id = bt.tag_id WHERE bt.book_id = ? ORDER BY t.name', 'i', [$bookId]);
$chapters = db_all('SELECT number, title, created_at FROM chapters WHERE book_id = ? ORDER BY number', 'i', [$bookId]);
$reviews = db_all(
    'SELECT r.user_id, r.rating, r.comment, r.created_at, u.username, u.photo
     FROM reviews r JOIN users u ON u.id = r.user_id
     WHERE r.book_id = ? ORDER BY r.created_at DESC',
    'i', [$bookId]
);

// What this member has done with the book so far
$listRow = null;
$owned = false;
$inCart = false;
$myReview = null;
if ($user) {
    $listRow = db_row('SELECT in_library, last_chapter FROM reading_list WHERE user_id = ? AND book_id = ?', 'ii', [$user['id'], $bookId]);
    $owned = owns_book($user['id'], $bookId);
    $inCart = db_row('SELECT 1 FROM cart_items WHERE user_id = ? AND book_id = ?', 'ii', [$user['id'], $bookId]) !== null;
    foreach ($reviews as $review) {
        if ($review['user_id'] == $user['id']) {
            $myReview = $review;
        }
    }
    if ($myReview && !$reviewErrors) {
        $reviewRating = $myReview['rating'];
        $reviewComment = $myReview['comment'];
    }
}
// a book that readers have paid for can't be deleted (see delete_action.php)
$sales = $canManage ? (int) db_row(
    "SELECT COUNT(*) AS n FROM order_items oi JOIN orders o ON o.id = oi.order_id
     WHERE oi.book_id = ? AND o.status = 'success'",
    'i', [$bookId]
)['n'] : 0;
$isFree = (float) $book['price'] == 0;
$fullAccess = $isFree || $isAuthor || $owned;
$continueChapter = $listRow && $listRow['last_chapter'] > 0 ? (int) $listRow['last_chapter'] : 1;
$here = 'book.php?id=' . $bookId;

$pageTitle = $book['title'];
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
            <nav class="breadcrumb" aria-label="Breadcrumb">
                <a href="index.php">Home</a> /
                <a href="browse.php?genre[]=<?= h($book['genre_slug']) ?>"><?= h($book['genre']) ?></a> /
                <span><?= h($book['title']) ?></span>
            </nav>

            <!-- BOOK DETAILS -->
            <section class="bookInfo">
                <img class="bookInfoCover" src="<?= h(cover_url($book['cover'])) ?>" alt="Cover of <?= h($book['title']) ?>">
                <div class="bookInfoText">
                    <h1><?= h($book['title']) ?></h1>
                    <p class="byline">by <?= h($book['author']) ?></p>
                    <ul class="miniTags">
                        <li class="genreChip"><?= h($book['genre']) ?></li>
                        <li class="status status-<?= $book['status'] ?>"><?= ucfirst($book['status']) ?></li>
                    </ul>
                    <dl class="statGrid">
                        <div><dt>Rating</dt><dd><?= stars($book['avg_rating'] === null ? null : (float) $book['avg_rating']) ?>
                            <small>(<?= $book['review_count'] ?>)</small></dd></div>
                        <div><dt>Chapters</dt><dd><?= count($chapters) ?></dd></div>
                        <div><dt>Views</dt><dd><?= format_views($book['views']) ?></dd></div>
                        <div><dt>Price</dt><dd><?= $isFree ? 'Free' : money($book['price']) ?></dd></div>
                        <div><dt>Language</dt><dd><?= h($book['language']) ?></dd></div>
                        <div><dt>Serial no.</dt><dd><?= h($book['serial_no']) ?></dd></div>
                    </dl>

                    <div class="bookActions">
<?php if ($chapters): ?>
                        <a class="btn" href="read.php?book=<?= $bookId ?>&amp;ch=<?= $continueChapter ?>">
                            <?= $continueChapter > 1 ? 'Continue Ch. ' . $continueChapter : 'Start reading' ?></a>
<?php endif; ?>

<?php if ($listRow && $listRow['in_library']): ?>
                        <form action="list_action.php" method="post">
                            <input type="hidden" name="book_id" value="<?= $bookId ?>">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="back" value="<?= h($here) ?>">
                            <button type="submit" class="btn btnDone" title="Click to remove">&#10003; In Library</button>
                        </form>
<?php else: ?>
                        <form action="list_action.php" method="post">
                            <input type="hidden" name="book_id" value="<?= $bookId ?>">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="back" value="<?= h($here) ?>">
                            <button type="submit" class="btn btnSecondary">+ Add to reading list</button>
                        </form>
<?php endif; ?>

<?php if ($isAuthor): ?>
                        <a class="btn btnSecondary" href="create.php?edit=<?= $bookId ?>">Edit book</a>
<?php elseif ($isFree): ?>
                        <span class="btn btnDone">Free to read</span>
<?php elseif ($owned): ?>
                        <span class="btn btnDone">&#10003; Owned</span>
<?php elseif ($inCart): ?>
                        <a class="btn btnSecondary" href="cart.php">In cart &rsaquo; Checkout</a>
<?php else: ?>
                        <form action="cart_action.php" method="post">
                            <input type="hidden" name="book_id" value="<?= $bookId ?>">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="back" value="<?= h($here) ?>">
                            <button type="submit" class="btn btnSecondary">Buy full book &middot; <?= money($book['price']) ?></button>
                        </form>
<?php endif; ?>

<?php if ($canManage && $sales === 0): ?>
                        <form action="delete_action.php" method="post">
                            <input type="hidden" name="type" value="book">
                            <input type="hidden" name="book_id" value="<?= $bookId ?>">
                            <input type="hidden" name="back" value="<?= h($here) ?>">
                            <button type="submit" class="btn btnDanger"
                                    data-confirm="Delete &quot;<?= h($book['title']) ?>&quot; with all its chapters and reviews? This cannot be undone.">Delete book</button>
                        </form>
<?php endif; ?>
                    </div>
<?php if (!$fullAccess): ?>
                    <p class="hint">The first <?= FREE_CHAPTERS ?> chapters are free. Buy the book to unlock the rest.</p>
<?php endif; ?>

<?php if ($tags): ?>
                    <ul class="tagList smallTags">
<?php foreach ($tags as $tag): ?>
                        <li><span><?= h($tag['name']) ?></span></li>
<?php endforeach; ?>
                    </ul>
<?php endif; ?>
                </div>
            </section>

            <section>
                <h2>Synopsis</h2>
                <p class="synopsisFull"><?= nl2br(h($book['synopsis'])) ?></p>
            </section>

            <!-- TABLE OF CONTENTS -->
            <section id="chapters">
                <h2>Table of Contents</h2>
<?php if ($isAuthor): ?>
                <p><a class="btn btnSecondary btnSmall" href="create.php?add_chapter=<?= $bookId ?>">+ Add chapter</a></p>
<?php endif; ?>
<?php if (!$chapters): ?>
                <p class="emptyNote">No chapters have been published yet.</p>
<?php else: ?>
                <table class="dataTable chapterTable">
                    <thead>
                        <tr><th scope="col">#</th><th scope="col">Chapter</th><th scope="col">Released</th><th scope="col">Access</th>
<?php if ($canManage): ?>
                            <th scope="col">Manage</th>
<?php endif; ?>
                        </tr>
                    </thead>
                    <tbody>
<?php foreach ($chapters as $chapter): ?>
<?php $readable = $fullAccess || $chapter['number'] <= FREE_CHAPTERS; ?>
                        <tr<?= $listRow && $chapter['number'] <= $listRow['last_chapter'] ? ' class="readRow"' : '' ?>>
                            <td><?= $chapter['number'] ?></td>
                            <td><a href="read.php?book=<?= $bookId ?>&amp;ch=<?= $chapter['number'] ?>"><?= h($chapter['title']) ?></a></td>
                            <td><?= date('j M Y', strtotime($chapter['created_at'])) ?></td>
                            <td><?= $readable ? ($chapter['number'] <= FREE_CHAPTERS && !$fullAccess ? 'Free' : 'Unlocked') : '&#128274; Locked' ?></td>
<?php if ($canManage): ?>
                            <td class="actions">
<?php if ($isAuthor): ?>
                                <a href="create.php?edit_chapter=<?= $bookId ?>&amp;ch=<?= $chapter['number'] ?>">Edit</a>
<?php endif; ?>
                                <form action="delete_action.php" method="post" class="removeForm">
                                    <input type="hidden" name="type" value="chapter">
                                    <input type="hidden" name="book_id" value="<?= $bookId ?>">
                                    <input type="hidden" name="number" value="<?= $chapter['number'] ?>">
                                    <button type="submit" class="linkButton"
                                            data-confirm="Delete Chapter <?= $chapter['number'] ?> (&quot;<?= h($chapter['title']) ?>&quot;)? Later chapters will be renumbered. This cannot be undone.">Delete</button>
                                </form>
                            </td>
<?php endif; ?>
                        </tr>
<?php endforeach; ?>
                    </tbody>
                </table>
<?php endif; ?>
            </section>

            <!-- REVIEWS -->
            <section id="reviews">
                <h2>Reviews (<?= count($reviews) ?>)</h2>

<?php if ($user && !$isAuthor): ?>
                <form action="book.php?id=<?= $bookId ?>#reviews" method="post" class="reviewForm" id="reviewForm" novalidate>
                    <h3><?= $myReview ? 'Update your review' : 'Write a review' ?></h3>
<?php foreach ($reviewErrors as $error): ?>
                    <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                    <input type="hidden" name="action" value="review">
                    <fieldset class="starPicker">
                        <legend>Your rating</legend>
<?php for ($s = 5; $s >= 1; $s--): ?>
                        <input type="radio" id="star<?= $s ?>" name="rating" value="<?= $s ?>"<?= (int) $reviewRating === $s ? ' checked' : '' ?> required>
                        <label for="star<?= $s ?>" title="<?= $s ?> star<?= $s > 1 ? 's' : '' ?>">&#9733;</label>
<?php endfor; ?>
                    </fieldset>
                    <p class="fieldError"></p>
                    <label for="comment">Your review</label>
                    <textarea id="comment" name="comment" rows="4" minlength="10" maxlength="1000" required
                              placeholder="What did you think of this book?"><?= h($reviewComment) ?></textarea>
                    <span class="charCount" data-for="comment"></span>
                    <p class="fieldError"></p>
                    <button type="submit" class="btn"><?= $myReview ? 'Update review' : 'Post review' ?></button>
                </form>
<?php elseif (!$user): ?>
                <p class="hint"><a href="login.php?redirect=<?= urlencode($here . '#reviews') ?>">Log in</a> to write a review.</p>
<?php endif; ?>

<?php if (!$reviews): ?>
                <p class="emptyNote">No reviews yet. Be the first to share your thoughts.</p>
<?php endif; ?>
                <ul class="reviewList">
<?php foreach ($reviews as $review): ?>
                    <li>
                        <img class="avatar" src="<?= h(avatar_url($review['photo'])) ?>" alt="" width="44" height="44">
                        <div>
                            <p class="reviewHead"><strong><?= h($review['username']) ?></strong>
                                <span class="rating"><?= str_repeat('&#9733;', $review['rating']) . str_repeat('&#9734;', 5 - $review['rating']) ?></span>
                                <small><?= date('j M Y', strtotime($review['created_at'])) ?></small></p>
                            <p><?= nl2br(h($review['comment'])) ?></p>
<?php if ($user && ($review['user_id'] == $user['id'] || $isAdmin)): ?>
                            <form action="delete_action.php" method="post" class="removeForm">
                                <input type="hidden" name="type" value="review">
                                <input type="hidden" name="book_id" value="<?= $bookId ?>">
                                <input type="hidden" name="user_id" value="<?= $review['user_id'] ?>">
                                <input type="hidden" name="back" value="<?= h($here . '#reviews') ?>">
                                <button type="submit" class="linkButton"
                                        data-confirm="<?= $review['user_id'] == $user['id'] ? 'Delete your review?' : 'Delete the review by ' . h($review['username']) . '?' ?>">Delete<?= $review['user_id'] == $user['id'] ? ' my review' : '' ?></button>
                            </form>
<?php endif; ?>
                        </div>
                    </li>
<?php endforeach; ?>
                </ul>
            </section>
<?php require 'includes/footer.php'; ?>
