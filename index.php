<?php
// Home page: Trending (top 10 by views today / this week), Recently Updated, Top Genres
require 'includes/init.php';

$period = isset($_GET['period']) && $_GET['period'] === 'week' ? 'week' : 'today';
$days = $period === 'week' ? 6 : 0;  // today only, or today plus the previous 6 days

// TRENDING: sum of daily views over the selected period
$trending = db_all(
    'SELECT b.id, b.title, b.cover, SUM(v.views) AS period_views,
            (SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id) AS avg_rating
     FROM books b
     JOIN book_views_daily v ON v.book_id = b.id AND v.view_date >= CURDATE() - INTERVAL ? DAY
     GROUP BY b.id
     ORDER BY period_views DESC
     LIMIT 10',
    'i', [$days]
);

// RECENTLY UPDATED: books ordered by their newest chapter
$recent = db_all(
    'SELECT b.id, b.title, b.cover, g.name AS genre, c.number, c.title AS chapter_title,
            TIMESTAMPDIFF(SECOND, c.created_at, NOW()) AS seconds_ago
     FROM books b
     JOIN genres g ON g.id = b.genre_id
     JOIN chapters c ON c.book_id = b.id
          AND c.number = (SELECT MAX(c2.number) FROM chapters c2 WHERE c2.book_id = b.id)
     ORDER BY c.created_at DESC
     LIMIT 8'
);

// TOP GENRES: total views of all books in each genre
$genres = db_all(
    'SELECT g.name, g.slug, COUNT(b.id) AS book_count, COALESCE(SUM(b.views), 0) AS total_views
     FROM genres g
     LEFT JOIN books b ON b.genre_id = g.id
     GROUP BY g.id
     ORDER BY total_views DESC'
);

$pageTitle = 'Home';
$pageScripts = ['home.js'];
require 'includes/header.php';
?>
            <!-- TRENDING (horizontal scrolling top 10) -->
            <section class="trending">
                <div class="sectionHeader">
                    <h2>Trending</h2>
                    <div class="periodToggle">
                        <a href="index.php?period=today"<?= $period === 'today' ? ' class="active"' : '' ?>>Today</a>
                        <a href="index.php?period=week"<?= $period === 'week' ? ' class="active"' : '' ?>>This week</a>
                    </div>
                    <a class="seeAll" href="browse.php?sort=views">See all &rsaquo;</a>
                </div>
                <div class="scrollRow">
                    <button type="button" class="scrollBtn scrollPrev" aria-label="Scroll left">&lsaquo;</button>
                    <ol class="trendingList" id="trendingList">
<?php foreach ($trending as $i => $book): ?>
                        <li>
                            <a class="bookCard" href="book.php?id=<?= $book['id'] ?>">
                                <span class="rankBadge"><?= $i + 1 ?></span>
                                <img src="<?= h(cover_url($book['cover'])) ?>" alt="Cover of <?= h($book['title']) ?>">
                                <span class="bookName"><?= h($book['title']) ?></span>
                                <span class="bookStats">&#9733; <?= $book['avg_rating'] === null ? '-' : number_format($book['avg_rating'], 1) ?>
                                    &middot; <?= format_views($book['period_views']) ?> views</span>
                            </a>
                        </li>
<?php endforeach; ?>
                    </ol>
                    <button type="button" class="scrollBtn scrollNext" aria-label="Scroll right">&rsaquo;</button>
                </div>
<?php if (!$trending): ?>
                <p class="emptyNote">No views recorded for this period yet.</p>
<?php endif; ?>
            </section>

            <!-- RECENTLY UPDATED -->
            <section class="recentUpdates">
                <h2>Recently Updated</h2>
                <div class="bookGrid">
<?php foreach ($recent as $book): ?>
                    <a class="bookCard" href="book.php?id=<?= $book['id'] ?>">
                        <img src="<?= h(cover_url($book['cover'])) ?>" alt="Cover of <?= h($book['title']) ?>">
                        <span class="bookName"><?= h($book['title']) ?></span>
                        <span class="bookGenre"><?= h($book['genre']) ?></span>
                        <span class="latestChapter">Ch. <?= $book['number'] ?>: <?= h($book['chapter_title']) ?></span>
                        <span class="timeAgo"><?= time_ago($book['seconds_ago']) ?></span>
                    </a>
<?php endforeach; ?>
                </div>
            </section>

            <!-- TOP GENRE TAGS -->
            <section class="genreTags">
                <h2>Top Genres</h2>
                <ul class="tagList">
<?php foreach ($genres as $genre): ?>
                    <li><a href="browse.php?genre[]=<?= h($genre['slug']) ?>"><?= h($genre['name']) ?>
                        <span class="tagCount"><?= $genre['book_count'] ?></span></a></li>
<?php endforeach; ?>
                </ul>
            </section>
<?php require 'includes/footer.php'; ?>
