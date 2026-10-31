<?php
// Account settings: profile photo, username/email, password, order history, delete account.
// Admins also see site statistics and recent feedback.
require 'includes/init.php';
require_login();

$user = current_user();
$userId = $user['id'];
$errors = [];          // keyed by form name, so each form shows its own errors
$form = param($_POST, 'action');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $password = isset($_POST['current_password']) && is_string($_POST['current_password']) ? $_POST['current_password'] : '';
    $hash = db_row('SELECT password_hash FROM users WHERE id = ?', 'i', [$userId])['password_hash'];

    if ($form === 'photo') {
        // ---- PROFILE PHOTO ----
        [$path, $error] = upload_image('photo', 'avatars');
        if ($error) {
            $errors['photo'][] = $error;
        } elseif ($path === null) {
            $errors['photo'][] = 'Choose an image to upload.';
        } else {
            db_query('UPDATE users SET photo = ? WHERE id = ?', 'si', [$path, $userId]);
            if ($user['photo'] && strpos($user['photo'], 'uploads/avatars/') === 0) {
                @unlink(__DIR__ . '/' . $user['photo']);  // remove the old upload
            }
            flash('Your profile photo has been updated.');
        }
    } elseif ($form === 'profile') {
        // ---- USERNAME / EMAIL ----
        $username = param($_POST, 'username');
        $email = param($_POST, 'email');
        if (!preg_match('/^[A-Za-z0-9_]{3,20}$/', $username)) {
            $errors['profile'][] = 'Username must be 3-20 characters: letters, numbers and underscores only.';
        }
        if (!valid_email($email)) {
            $errors['profile'][] = 'Enter a valid email address.';
        }
        if (empty($errors['profile'])) {
            if (db_row('SELECT 1 FROM users WHERE username = ? AND id <> ?', 'si', [$username, $userId])) {
                $errors['profile'][] = 'That username is already taken.';
            }
            if (db_row('SELECT 1 FROM users WHERE email = ? AND id <> ?', 'si', [$email, $userId])) {
                $errors['profile'][] = 'Another account already uses that email.';
            }
        }
        if (empty($errors['profile'])) {
            db_query('UPDATE users SET username = ?, email = ? WHERE id = ?', 'ssi', [$username, $email, $userId]);
            flash('Your details have been updated.');
        }
    } elseif ($form === 'password') {
        // ---- CHANGE PASSWORD ----
        $new = isset($_POST['new_password']) && is_string($_POST['new_password']) ? $_POST['new_password'] : '';
        $confirm = isset($_POST['confirm_password']) && is_string($_POST['confirm_password']) ? $_POST['confirm_password'] : '';
        if (!password_verify($password, $hash)) {
            $errors['password'][] = 'Your current password is incorrect.';
        }
        if (strlen($new) < 8 || !preg_match('/[A-Za-z]/', $new) || !preg_match('/\d/', $new)) {
            $errors['password'][] = 'New password must be at least 8 characters and include a letter and a number.';
        }
        if ($new !== $confirm) {
            $errors['password'][] = 'The new passwords do not match.';
        }
        if (empty($errors['password'])) {
            db_query('UPDATE users SET password_hash = ? WHERE id = ?', 'si', [password_hash($new, PASSWORD_DEFAULT), $userId]);
            flash('Your password has been changed.');
        }
    } elseif ($form === 'delete') {
        // ---- DELETE ACCOUNT ----
        if ($user['role'] === 'admin') {
            $errors['delete'][] = 'The admin account cannot be deleted.';
        } elseif (!password_verify($password, $hash)) {
            $errors['delete'][] = 'Your password is incorrect.';
        } elseif (!isset($_POST['confirm_delete'])) {
            $errors['delete'][] = 'Tick the box to confirm you want to delete your account.';
        } else {
            // keep the member's books on the site by handing them to the admin account
            $admin = db_row("SELECT id FROM users WHERE role = 'admin' ORDER BY id LIMIT 1");
            db_query('UPDATE books SET user_id = ? WHERE user_id = ?', 'ii', [$admin['id'], $userId]);
            db_query('DELETE FROM users WHERE id = ?', 'i', [$userId]);  // cascades to reviews, lists, cart, orders
            $_SESSION = [];
            session_regenerate_id(true);
            flash('Your account has been deleted. Sorry to see you go!');
            header('Location: index.php');
            exit;
        }
    }

    if (!$errors) {
        header('Location: account.php');  // Post/Redirect/Get, so refreshing doesn't resubmit
        exit;
    }
}

// Reload in case the details changed above
$user = db_row('SELECT id, username, email, photo, role, created_at FROM users WHERE id = ?', 'i', [$userId]);
$summary = db_row(
    'SELECT (SELECT COUNT(*) FROM books WHERE user_id = ?) AS books_written,
            (SELECT COUNT(*) FROM reviews WHERE user_id = ?) AS reviews_written,
            (SELECT COUNT(*) FROM reading_list WHERE user_id = ? AND in_library = 1) AS library_size,
            (SELECT COUNT(DISTINCT oi.book_id) FROM orders o JOIN order_items oi ON oi.order_id = o.id
              WHERE o.user_id = ? AND o.status = \'success\') AS books_owned',
    'iiii', [$userId, $userId, $userId, $userId]
);
$orders = db_all(
    'SELECT o.id, o.total, o.status, o.created_at, GROUP_CONCAT(b.title ORDER BY b.title SEPARATOR \', \') AS titles
     FROM orders o JOIN order_items oi ON oi.order_id = o.id JOIN books b ON b.id = oi.book_id
     WHERE o.user_id = ?
     GROUP BY o.id
     ORDER BY o.created_at DESC',
    'i', [$userId]
);

// ---- ADMIN STATISTICS ----
if ($user['role'] === 'admin') {
    $totals = db_row(
        "SELECT (SELECT COUNT(*) FROM users) AS users,
                (SELECT COUNT(*) FROM books) AS books,
                (SELECT COUNT(*) FROM chapters) AS chapters,
                (SELECT COUNT(*) FROM reviews) AS reviews,
                (SELECT COALESCE(SUM(views), 0) FROM book_views_daily WHERE view_date >= CURDATE() - INTERVAL 6 DAY) AS views_week,
                (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status = 'success') AS revenue"
    );
    $bestSellers = db_all(
        "SELECT b.id, b.title, COUNT(*) AS copies, SUM(oi.price) AS revenue
         FROM order_items oi
         JOIN orders o ON o.id = oi.order_id AND o.status = 'success'
         JOIN books b ON b.id = oi.book_id
         GROUP BY b.id
         ORDER BY revenue DESC
         LIMIT 10"
    );
    $dailyOrders = db_all(
        "SELECT DATE(created_at) AS day,
                SUM(status = 'success') AS successful,
                SUM(status = 'failed') AS failed,
                SUM(CASE WHEN status = 'success' THEN total ELSE 0 END) AS revenue
         FROM orders
         WHERE created_at >= CURDATE() - INTERVAL 6 DAY
         GROUP BY DATE(created_at)
         ORDER BY day DESC"
    );
    $genreStats = db_all(
        'SELECT g.name, COUNT(b.id) AS books, COALESCE(SUM(b.views), 0) AS views,
                (SELECT AVG(r.rating) FROM reviews r JOIN books b2 ON b2.id = r.book_id WHERE b2.genre_id = g.id) AS avg_rating
         FROM genres g
         LEFT JOIN books b ON b.genre_id = g.id
         GROUP BY g.id
         ORDER BY views DESC'
    );
    $feedback = db_all('SELECT name, email, subject, message, created_at FROM feedback ORDER BY created_at DESC LIMIT 5');
}

// Error list for one form
function form_errors($errors, $name)
{
    foreach (isset($errors[$name]) ? $errors[$name] : [] as $error) {
        echo '<p class="flash flash-error">' . h($error) . '</p>';
    }
}

$pageTitle = 'My Account';
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
            <!-- PROFILE SUMMARY -->
            <section class="profileHeader">
                <img class="avatarLarge" src="<?= h(avatar_url($user['photo'])) ?>" alt="Your profile photo" width="120" height="120" id="avatarPreview">
                <div>
                    <h1><?= h($user['username']) ?><?= $user['role'] === 'admin' ? ' <span class="memberTag">Admin</span>' : '' ?></h1>
                    <p class="byline"><?= h($user['email']) ?> &middot; member since <?= date('F Y', strtotime($user['created_at'])) ?></p>
                    <ul class="statRow">
                        <li><strong><?= $summary['library_size'] ?></strong> in library</li>
                        <li><strong><?= $summary['books_owned'] ?></strong> books owned</li>
                        <li><strong><?= $summary['books_written'] ?></strong> books written</li>
                        <li><strong><?= $summary['reviews_written'] ?></strong> reviews</li>
                    </ul>
                </div>
            </section>

            <div class="accountGrid">
                <!-- PHOTO -->
                <section>
                    <h2>Profile photo</h2>
                    <form action="account.php" method="post" enctype="multipart/form-data" class="stackForm" id="photoForm">
                        <?php form_errors($errors, 'photo'); ?>
                        <input type="hidden" name="action" value="photo">
                        <label for="photo">Choose an image (JPG, PNG, GIF or WEBP, max 2 MB)</label>
                        <input type="file" id="photo" name="photo" accept="image/jpeg,image/png,image/gif,image/webp" required
                               data-max-size="2097152" data-preview="avatarPreview">
                        <p class="fieldError"></p>
                        <button type="submit" class="btn">Upload photo</button>
                    </form>
                </section>

                <!-- USERNAME / EMAIL -->
                <section>
                    <h2>Account details</h2>
                    <form action="account.php" method="post" class="stackForm" novalidate>
                        <?php form_errors($errors, 'profile'); ?>
                        <input type="hidden" name="action" value="profile">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="<?= h($form === 'profile' ? param($_POST, 'username') : $user['username']) ?>"
                               required pattern="[A-Za-z0-9_]{3,20}" maxlength="20" title="3-20 letters, numbers or underscores">
                        <p class="fieldError"></p>
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<?= h($form === 'profile' ? param($_POST, 'email') : $user['email']) ?>" required maxlength="100">
                        <p class="fieldError"></p>
                        <button type="submit" class="btn">Save details</button>
                    </form>
                </section>

                <!-- PASSWORD -->
                <section>
                    <h2>Change password</h2>
                    <form action="account.php" method="post" class="stackForm" novalidate>
                        <?php form_errors($errors, 'password'); ?>
                        <input type="hidden" name="action" value="password">
                        <label for="currentPassword">Current password</label>
                        <input type="password" id="currentPassword" name="current_password" required autocomplete="current-password">
                        <p class="fieldError"></p>
                        <label for="password">New password</label>
                        <input type="password" id="password" name="new_password" required minlength="8" autocomplete="new-password">
                        <div class="strengthMeter" aria-hidden="true"><span id="strengthBar"></span></div>
                        <p class="hint" id="strengthText">At least 8 characters, with a letter and a number.</p>
                        <p class="fieldError"></p>
                        <label for="confirmPassword">Confirm new password</label>
                        <input type="password" id="confirmPassword" name="confirm_password" required data-match="password" autocomplete="new-password">
                        <p class="fieldError"></p>
                        <button type="submit" class="btn">Change password</button>
                    </form>
                </section>

                <!-- DELETE -->
                <section class="dangerZone">
                    <h2>Delete account</h2>
                    <p>This permanently removes your reviews, reading list, cart and order history. Books you have written stay on the site.</p>
                    <form action="account.php" method="post" class="stackForm" id="deleteForm" novalidate>
                        <?php form_errors($errors, 'delete'); ?>
                        <input type="hidden" name="action" value="delete">
                        <label for="deletePassword">Enter your password to confirm</label>
                        <input type="password" id="deletePassword" name="current_password" required autocomplete="current-password">
                        <p class="fieldError"></p>
                        <label class="checkLabel"><input type="checkbox" name="confirm_delete" required> I understand this cannot be undone</label>
                        <p class="fieldError"></p>
                        <button type="submit" class="btn btnDanger">Delete my account</button>
                    </form>
                </section>
            </div>

            <!-- ORDER HISTORY -->
            <section>
                <h2>Order history</h2>
<?php if (!$orders): ?>
                <p class="emptyNote">You haven't bought any books yet. <a href="browse.php">Find something to read</a>.</p>
<?php else: ?>
                <table class="dataTable">
                    <thead><tr><th scope="col">Order</th><th scope="col">Date</th><th scope="col">Books</th><th scope="col">Total</th><th scope="col">Payment</th></tr></thead>
                    <tbody>
<?php foreach ($orders as $order): ?>
                        <tr>
                            <td>#<?= $order['id'] ?></td>
                            <td><?= date('j M Y, g:i a', strtotime($order['created_at'])) ?></td>
                            <td><?= h($order['titles']) ?></td>
                            <td><?= money($order['total']) ?></td>
                            <td><span class="status status-<?= $order['status'] ?>"><?= $order['status'] === 'success' ? 'Successful' : 'Failed' ?></span></td>
                        </tr>
<?php endforeach; ?>
                    </tbody>
                </table>
<?php endif; ?>
            </section>

<?php if ($user['role'] === 'admin'): ?>
            <!-- ADMIN: SITE STATISTICS -->
            <section class="adminStats">
                <h2>Site statistics <span class="memberTag">Admin</span></h2>
                <ul class="statCards">
                    <li><strong><?= $totals['users'] ?></strong> members</li>
                    <li><strong><?= $totals['books'] ?></strong> books</li>
                    <li><strong><?= $totals['chapters'] ?></strong> chapters</li>
                    <li><strong><?= $totals['reviews'] ?></strong> reviews</li>
                    <li><strong><?= format_views($totals['views_week']) ?></strong> views this week</li>
                    <li><strong><?= money($totals['revenue']) ?></strong> revenue</li>
                </ul>

                <div class="adminTables">
                    <div>
                        <h3>Best sellers</h3>
                        <table class="dataTable">
                            <thead><tr><th scope="col">Book</th><th scope="col">Copies</th><th scope="col">Revenue</th></tr></thead>
                            <tbody>
<?php foreach ($bestSellers as $row): ?>
                                <tr><td><a href="book.php?id=<?= $row['id'] ?>"><?= h($row['title']) ?></a></td><td><?= $row['copies'] ?></td><td><?= money($row['revenue']) ?></td></tr>
<?php endforeach; ?>
<?php if (!$bestSellers): ?>
                                <tr><td colspan="3">No sales yet.</td></tr>
<?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                    <div>
                        <h3>Orders in the last 7 days</h3>
                        <table class="dataTable">
                            <thead><tr><th scope="col">Day</th><th scope="col">Successful</th><th scope="col">Failed</th><th scope="col">Revenue</th></tr></thead>
                            <tbody>
<?php foreach ($dailyOrders as $row): ?>
                                <tr><td><?= date('D j M', strtotime($row['day'])) ?></td><td><?= $row['successful'] ?></td><td><?= $row['failed'] ?></td><td><?= money($row['revenue']) ?></td></tr>
<?php endforeach; ?>
<?php if (!$dailyOrders): ?>
                                <tr><td colspan="4">No orders this week.</td></tr>
<?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                    <div>
                        <h3>Genres</h3>
                        <table class="dataTable">
                            <thead><tr><th scope="col">Genre</th><th scope="col">Books</th><th scope="col">Views</th><th scope="col">Avg rating</th></tr></thead>
                            <tbody>
<?php foreach ($genreStats as $row): ?>
                                <tr><td><?= h($row['name']) ?></td><td><?= $row['books'] ?></td><td><?= format_views($row['views']) ?></td>
                                    <td><?= $row['avg_rating'] === null ? '-' : number_format($row['avg_rating'], 1) ?></td></tr>
<?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>

                <h3>Latest feedback</h3>
<?php if (!$feedback): ?>
                <p class="emptyNote">No feedback received yet.</p>
<?php endif; ?>
                <ul class="feedbackList">
<?php foreach ($feedback as $row): ?>
                    <li>
                        <p class="reviewHead"><strong><?= h($row['subject']) ?></strong>
                            <small>from <?= h($row['name']) ?> (<?= h($row['email']) ?>) &middot; <?= date('j M Y', strtotime($row['created_at'])) ?></small></p>
                        <p><?= nl2br(h($row['message'])) ?></p>
                    </li>
<?php endforeach; ?>
                </ul>
            </section>
<?php endif; ?>
<?php require 'includes/footer.php'; ?>
