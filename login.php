<?php
// Sign in and Sign up on one page (two tabs). Both forms post back here.
require 'includes/init.php';

$redirect = param($_POST, 'redirect') !== '' ? param($_POST, 'redirect') : param($_GET, 'redirect');
if (is_logged_in()) {
    safe_redirect($redirect, 'account.php');
}

$tab = param($_GET, 'tab') === 'signup' ? 'signup' : 'login';
$loginErrors = [];
$signupErrors = [];
// "Remember me" cookie only stores the username, to pre-fill the form next time
$identifier = isset($_COOKIE['remember_username']) && is_string($_COOKIE['remember_username']) ? $_COOKIE['remember_username'] : '';
$remember = $identifier !== '';
$newUsername = '';
$newEmail = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && param($_POST, 'action') === 'login') {
    // ---- SIGN IN ----
    $identifier = param($_POST, 'identifier');
    $password = isset($_POST['password']) && is_string($_POST['password']) ? $_POST['password'] : '';
    $remember = isset($_POST['remember']);

    if ($identifier === '' || $password === '') {
        $loginErrors[] = 'Enter your username or email and your password.';
    } else {
        $account = db_row('SELECT id, username, password_hash FROM users WHERE username = ? OR email = ?', 'ss', [$identifier, $identifier]);
        // same message whether the username or the password is wrong, so accounts can't be guessed
        if ($account === null || !password_verify($password, $account['password_hash'])) {
            $loginErrors[] = 'Incorrect username/email or password.';
        } else {
            login_user($account['id']);
            if ($remember) {
                setcookie('remember_username', $account['username'], ['expires' => time() + 30 * 86400, 'httponly' => true, 'samesite' => 'Lax']);
            } else {
                setcookie('remember_username', '', time() - 3600);
            }
            flash('Welcome back, ' . $account['username'] . '!');
            safe_redirect($redirect, 'index.php');
        }
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && param($_POST, 'action') === 'signup') {
    // ---- SIGN UP ----
    $tab = 'signup';
    $newUsername = param($_POST, 'username');
    $newEmail = param($_POST, 'email');
    $password = isset($_POST['password']) && is_string($_POST['password']) ? $_POST['password'] : '';
    $confirm = isset($_POST['confirm']) && is_string($_POST['confirm']) ? $_POST['confirm'] : '';

    if (!preg_match('/^[A-Za-z0-9_]{3,20}$/', $newUsername)) {
        $signupErrors[] = 'Username must be 3-20 characters: letters, numbers and underscores only.';
    }
    if (!valid_email($newEmail)) {
        $signupErrors[] = 'Enter a valid email address.';
    }
    if (strlen($password) < 8 || !preg_match('/[A-Za-z]/', $password) || !preg_match('/\d/', $password)) {
        $signupErrors[] = 'Password must be at least 8 characters and include a letter and a number.';
    }
    if ($password !== $confirm) {
        $signupErrors[] = 'The two passwords do not match.';
    }
    // checks that need the database
    if (db_row('SELECT 1 FROM users WHERE username = ?', 's', [$newUsername])) {
        $signupErrors[] = 'That username is already taken.';
    }
    if (db_row('SELECT 1 FROM users WHERE email = ?', 's', [$newEmail])) {
        $signupErrors[] = 'An account with that email already exists.';
    }
    if (!$signupErrors) {
        db_query('INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)', 'sss',
            [$newUsername, $newEmail, password_hash($password, PASSWORD_DEFAULT)]);
        login_user($db->insert_id);
        flash('Welcome, ' . $newUsername . '! Your account has been created.');
        safe_redirect($redirect, 'index.php');
    }
}

$redirectQuery = $redirect !== '' ? '&amp;redirect=' . urlencode($redirect) : '';
$pageTitle = $tab === 'signup' ? 'Sign up' : 'Sign in';
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
            <section class="authBox">
                <div class="tabs" role="tablist">
                    <a href="login.php?tab=login<?= $redirectQuery ?>" class="tab<?= $tab === 'login' ? ' active' : '' ?>" data-tab="loginPanel" role="tab">Sign in</a>
                    <a href="login.php?tab=signup<?= $redirectQuery ?>" class="tab<?= $tab === 'signup' ? ' active' : '' ?>" data-tab="signupPanel" role="tab">Sign up</a>
                </div>

                <!-- SIGN IN -->
                <div id="loginPanel" class="tabPanel<?= $tab === 'login' ? ' active' : '' ?>" role="tabpanel">
                    <form action="login.php" method="post" id="loginForm" class="stackForm" novalidate>
<?php foreach ($loginErrors as $error): ?>
                        <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                        <input type="hidden" name="action" value="login">
                        <input type="hidden" name="redirect" value="<?= h($redirect) ?>">

                        <label for="identifier">Username or email</label>
                        <input type="text" id="identifier" name="identifier" value="<?= h($identifier) ?>" maxlength="100" required autocomplete="username">
                        <p class="fieldError"></p>

                        <label for="loginPassword">Password</label>
                        <input type="password" id="loginPassword" name="password" required autocomplete="current-password">
                        <p class="fieldError"></p>

                        <label class="checkLabel"><input type="checkbox" name="remember"<?= $remember ? ' checked' : '' ?>> Remember my username</label>
                        <button type="submit" class="btn">Sign in</button>
                    </form>
                    <p class="hint">New here? <a href="login.php?tab=signup<?= $redirectQuery ?>" data-tab-link="signupPanel">Create an account</a>.</p>
                </div>

                <!-- SIGN UP -->
                <div id="signupPanel" class="tabPanel<?= $tab === 'signup' ? ' active' : '' ?>" role="tabpanel">
                    <form action="login.php" method="post" id="signupForm" class="stackForm" novalidate>
<?php foreach ($signupErrors as $error): ?>
                        <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                        <input type="hidden" name="action" value="signup">
                        <input type="hidden" name="redirect" value="<?= h($redirect) ?>">

                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="<?= h($newUsername) ?>" required
                               pattern="[A-Za-z0-9_]{3,20}" maxlength="20" autocomplete="username"
                               title="3-20 letters, numbers or underscores">
                        <p class="fieldError"></p>

                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<?= h($newEmail) ?>" required maxlength="100" autocomplete="email">
                        <p class="fieldError"></p>

                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required minlength="8" autocomplete="new-password">
                        <div class="strengthMeter" aria-hidden="true"><span id="strengthBar"></span></div>
                        <p class="hint" id="strengthText">At least 8 characters, with a letter and a number.</p>
                        <p class="fieldError"></p>

                        <label for="confirm">Confirm password</label>
                        <input type="password" id="confirm" name="confirm" required autocomplete="new-password" data-match="password">
                        <p class="fieldError"></p>

                        <button type="submit" class="btn">Create account</button>
                    </form>
                    <p class="hint">Already a member? <a href="login.php?tab=login<?= $redirectQuery ?>" data-tab-link="loginPanel">Sign in</a>.</p>
                </div>
            </section>
<?php require 'includes/footer.php'; ?>
