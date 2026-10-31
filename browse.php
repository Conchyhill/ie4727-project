<?php
// Browse and search books. Everyone can filter by keyword, genre and status;
// members can also search by serial number, author and language (Theme 6 requirement).
require 'includes/init.php';

const PER_PAGE = 10;
$user = current_user();

// ---- Read the filters from the URL ($_GET) ----
$q = param($_GET, 'q');
$selectedGenres = isset($_GET['genre']) ? array_values(array_filter((array) $_GET['genre'], 'is_string')) : [];
$status = in_array(param($_GET, 'status'), ['ongoing', 'completed']) ? param($_GET, 'status') : 'all';
$sorts = ['views' => 'Popularity', 'updated' => 'Latest update', 'rating' => 'Rating'];
$sort = isset($sorts[param($_GET, 'sort')]) ? param($_GET, 'sort') : 'views';
$page = max(1, (int) param($_GET, 'page'));

// Members-only fields are ignored for guests
$serial = $user ? strtoupper(param($_GET, 'serial')) : '';
$author = $user ? param($_GET, 'author') : '';
$language = $user ? param($_GET, 'language') : '';
// "12" or "000012" is accepted as shorthand for NB-000012
if (preg_match('/^\d{1,6}$/', $serial)) {
    $serial = sprintf('NB-%06d', $serial);
}

// ---- Build the WHERE clause with placeholders ----
$where = [];
$types = '';
$params = [];
if ($q !== '') {
    $where[] = '(b.title LIKE ? OR b.synopsis LIKE ? OR u.username LIKE ?)';
    $like = '%' . $q . '%';
    $types .= 'sss';
    array_push($params, $like, $like, $like);
}
if ($selectedGenres) {
    $where[] = 'g.slug IN (' . implode(',', array_fill(0, count($selectedGenres), '?')) . ')';
    $types .= str_repeat('s', count($selectedGenres));
    array_push($params, ...array_values($selectedGenres));
}
if ($status !== 'all') {
    $where[] = 'b.status = ?';
    $types .= 's';
    $params[] = $status;
}
if ($serial !== '') {
    $where[] = 'b.serial_no = ?';
    $types .= 's';
    $params[] = $serial;
}
if ($author !== '') {
    $where[] = 'u.username LIKE ?';
    $types .= 's';
    $params[] = '%' . $author . '%';
}
if ($language !== '') {
    $where[] = 'b.language = ?';
    $types .= 's';
    $params[] = $language;
}
$whereSql = $where ? 'WHERE ' . implode(' AND ', $where) : '';
$from = 'FROM books b JOIN users u ON u.id = b.user_id JOIN genres g ON g.id = b.genre_id';

$total = (int) db_row("SELECT COUNT(*) AS n $from $whereSql", $types, $params)['n'];
$pages = max(1, (int) ceil($total / PER_PAGE));
$page = min($page, $pages);

$orderBy = [
    'views'   => 'b.views DESC',
    'updated' => 'last_update IS NULL, last_update DESC',
    'rating'  => 'avg_rating IS NULL, avg_rating DESC, b.views DESC',
][$sort];

$books = db_all(
    "SELECT b.id, b.serial_no, b.title, b.cover, b.synopsis, b.status, b.price, b.views,
            u.username AS author, g.name AS genre,
            (SELECT AVG(r.rating) FROM reviews r WHERE r.book_id = b.id) AS avg_rating,
            (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS chapter_count,
            (SELECT MAX(c.created_at) FROM chapters c WHERE c.book_id = b.id) AS last_update
     $from $whereSql
     ORDER BY $orderBy
     LIMIT ? OFFSET ?",
    $types . 'ii', array_merge($params, [PER_PAGE, ($page - 1) * PER_PAGE])
);

// Tags for the books on this page, grouped by book id
$tagsByBook = [];
if ($books) {
    $ids = array_column($books, 'id');
    $rows = db_all(
        'SELECT bt.book_id, t.name FROM book_tags bt JOIN tags t ON t.id = bt.tag_id
         WHERE bt.book_id IN (' . implode(',', array_fill(0, count($ids), '?')) . ') ORDER BY t.name',
        str_repeat('i', count($ids)), $ids
    );
    foreach ($rows as $row) {
        $tagsByBook[$row['book_id']][] = $row['name'];
    }
}

// Which books are already in the member's library (shows "In Library" instead of "Add")
$inLibrary = [];
if ($user) {
    foreach (db_all('SELECT book_id FROM reading_list WHERE user_id = ? AND in_library = 1', 'i', [$user['id']]) as $row) {
        $inLibrary[$row['book_id']] = true;
    }
}

$allGenres = db_all('SELECT name, slug FROM genres ORDER BY name');
$languages = db_all('SELECT DISTINCT language FROM books ORDER BY language');

// Link to another results page, keeping the current filters
function page_link($n)
{
    $query = $_GET;
    $query['page'] = $n;
    return 'browse.php?' . h(http_build_query($query));
}

$pageTitle = $q !== '' ? 'Search: ' . $q : 'Browse';
$pageScripts = ['browse.js'];
require 'includes/header.php';
?>
            <div class="browseLayout">
                <!-- FILTER SIDEBAR (GET form, so results can be bookmarked and shared) -->
                <aside class="filterPanel">
                    <form action="browse.php" method="get" id="filterForm">
                        <h2>Filters</h2>
                        <label for="q">Keywords</label>
                        <input type="search" id="q" name="q" value="<?= h($q) ?>" placeholder="Title, author, synopsis">

                        <fieldset class="memberSearch">
                            <legend>Advanced search <span class="memberTag">Members</span></legend>
<?php if ($user): ?>
                            <label for="serial">Serial number</label>
                            <input type="text" id="serial" name="serial" value="<?= h($serial) ?>" placeholder="e.g. NB-000001"
                                   pattern="(NB-|nb-)?\d{1,6}" title="NB- followed by up to 6 digits, or just the digits">
                            <label for="author">Author</label>
                            <input type="text" id="author" name="author" value="<?= h($author) ?>" maxlength="30">
                            <label for="language">Language</label>
                            <select id="language" name="language">
                                <option value="">Any</option>
<?php foreach ($languages as $row): ?>
                                <option<?= $language === $row['language'] ? ' selected' : '' ?>><?= h($row['language']) ?></option>
<?php endforeach; ?>
                            </select>
<?php else: ?>
                            <p class="hint"><a href="login.php?redirect=<?= urlencode($_SERVER['REQUEST_URI']) ?>">Log in</a>
                                to search by serial number, author and language.</p>
<?php endif; ?>
                        </fieldset>

                        <fieldset>
                            <legend>Genre</legend>
<?php foreach ($allGenres as $genre): ?>
                            <label class="checkLabel">
                                <input type="checkbox" name="genre[]" value="<?= h($genre['slug']) ?>"
                                    <?= in_array($genre['slug'], $selectedGenres) ? 'checked' : '' ?>> <?= h($genre['name']) ?>
                            </label>
<?php endforeach; ?>
                        </fieldset>

                        <fieldset>
                            <legend>Status</legend>
<?php foreach (['all' => 'All', 'ongoing' => 'Ongoing', 'completed' => 'Completed'] as $value => $label): ?>
                            <label class="checkLabel">
                                <input type="radio" name="status" value="<?= $value ?>"<?= $status === $value ? ' checked' : '' ?>> <?= $label ?>
                            </label>
<?php endforeach; ?>
                        </fieldset>

                        <fieldset>
                            <legend>Sort by</legend>
<?php foreach ($sorts as $value => $label): ?>
                            <label class="checkLabel">
                                <input type="radio" name="sort" value="<?= $value ?>"<?= $sort === $value ? ' checked' : '' ?>> <?= $label ?>
                            </label>
<?php endforeach; ?>
                        </fieldset>

                        <div class="formActions">
                            <button type="submit" class="btn">Apply</button>
                            <a href="browse.php" class="btn btnSecondary">Reset</a>
                        </div>
                    </form>
                </aside>

                <!-- RESULTS -->
                <section class="results">
                    <div class="sectionHeader">
                        <h2><?= $q !== '' ? 'Results for &ldquo;' . h($q) . '&rdquo;' : 'All books' ?></h2>
                        <span class="resultCount"><?= $total ?> book<?= $total === 1 ? '' : 's' ?> &middot; sorted by <?= strtolower($sorts[$sort]) ?></span>
                    </div>

<?php if (!$books): ?>
                    <p class="emptyNote">No books match these filters. Try removing a filter or <a href="browse.php">reset</a>.</p>
<?php endif; ?>

                    <ul class="bookList">
<?php foreach ($books as $book): ?>
                        <li class="bookRow">
                            <a href="book.php?id=<?= $book['id'] ?>" class="bookRowCover">
                                <img src="<?= h(cover_url($book['cover'])) ?>" alt="Cover of <?= h($book['title']) ?>">
                            </a>
                            <div class="bookRowInfo">
                                <ul class="miniTags">
                                    <li class="genreChip"><?= h($book['genre']) ?></li>
<?php foreach (isset($tagsByBook[$book['id']]) ? $tagsByBook[$book['id']] : [] as $tag): ?>
                                    <li><?= h($tag) ?></li>
<?php endforeach; ?>
                                </ul>
                                <h3><a href="book.php?id=<?= $book['id'] ?>"><?= h($book['title']) ?></a></h3>
                                <p class="byline">by <?= h($book['author']) ?> &middot; <?= h($book['serial_no']) ?></p>
                                <p class="synopsis"><?= h($book['synopsis']) ?></p>
                                <p class="bookMeta">
                                    <span class="rating"><?= stars($book['avg_rating'] === null ? null : (float) $book['avg_rating']) ?></span>
                                    &middot; <?= $book['chapter_count'] ?> chapters
                                    &middot; <?= format_views($book['views']) ?> views
                                    &middot; <span class="status status-<?= $book['status'] ?>"><?= ucfirst($book['status']) ?></span>
                                </p>
                            </div>
                            <div class="bookRowAction">
<?php if (isset($inLibrary[$book['id']])): ?>
                                <span class="btn btnDone">In Library</span>
<?php else: ?>
                                <form action="list_action.php" method="post">
                                    <input type="hidden" name="book_id" value="<?= $book['id'] ?>">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="back" value="<?= h($_SERVER['REQUEST_URI']) ?>">
                                    <button type="submit" class="btn">+ Add</button>
                                </form>
<?php endif; ?>
                            </div>
                        </li>
<?php endforeach; ?>
                    </ul>

<?php if ($pages > 1): ?>
                    <nav class="pagination" aria-label="Result pages">
<?php if ($page > 1): ?>
                        <a href="<?= page_link($page - 1) ?>">&lsaquo; Prev</a>
<?php endif; ?>
<?php for ($n = 1; $n <= $pages; $n++): ?>
                        <a href="<?= page_link($n) ?>"<?= $n === $page ? ' class="active" aria-current="page"' : '' ?>><?= $n ?></a>
<?php endfor; ?>
<?php if ($page < $pages): ?>
                        <a href="<?= page_link($page + 1) ?>">Next &rsaquo;</a>
<?php endif; ?>
                    </nav>
<?php endif; ?>
                </section>
            </div>
<?php require 'includes/footer.php'; ?>
