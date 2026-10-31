<?php
// About, Help, Terms, Privacy, Contact and Feedback on one page (footer links jump to each section).
// The feedback form saves to the database and emails the site's own local account.
require 'includes/init.php';

const FEEDBACK_EMAIL = 'webmaster@localhost';
const FEEDBACK_TOPICS = ['General feedback', 'Report a problem', 'Book suggestion', 'Account help'];

$user = current_user();
$stats = db_row('SELECT (SELECT COUNT(*) FROM books) AS books, (SELECT COUNT(*) FROM chapters) AS chapters,
                        (SELECT COUNT(*) FROM users) AS members, (SELECT COUNT(*) FROM genres) AS genres');

$errors = [];
$name = $user ? $user['username'] : '';
$email = $user ? $user['email'] : '';
$subject = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = param($_POST, 'name');
    $email = param($_POST, 'email');
    $subject = param($_POST, 'subject');
    $message = param($_POST, 'message');

    if (mb_strlen($name) < 2 || mb_strlen($name) > 60 || preg_match('/[\r\n]/', $name)) {
        $errors[] = 'Enter your name (2-60 characters).';
    }
    if (!valid_email($email)) {
        $errors[] = 'Enter a valid email address so we can reply.';
    }
    if (!in_array($subject, FEEDBACK_TOPICS)) {
        $errors[] = 'Choose a topic.';
    }
    if (mb_strlen($message) < 10 || mb_strlen($message) > 2000) {
        $errors[] = 'Your message must be between 10 and 2000 characters.';
    }

    if (!$errors) {
        db_query('INSERT INTO feedback (name, email, subject, message) VALUES (?, ?, ?, ?)', 'ssss', [$name, $email, $subject, $message]);
        // Only our own local mailbox is emailed. @ hides the warning when XAMPP's mail server isn't set up;
        // the message is still saved and shown to the admin on account.php.
        $body = "From: $name <$email>\r\nTopic: $subject\r\n\r\n$message";
        $sent = @mail(FEEDBACK_EMAIL, '[' . SITE_NAME . '] ' . $subject, $body, 'Reply-To: ' . $email);
        flash('Thanks for your feedback, ' . $name . '! ' . ($sent ? 'It has been emailed to our team.' : 'Our team will read it soon.'));
        header('Location: info.php#feedback');
        exit;
    }
}

$pageTitle = 'About & Help';
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
            <div class="infoLayout">
                <nav class="infoNav" aria-label="On this page">
                    <a href="#about">About</a>
                    <a href="#help">Help</a>
                    <a href="#terms">Terms</a>
                    <a href="#privacy">Privacy</a>
                    <a href="#contact">Contact</a>
                    <a href="#feedback">Feedback</a>
                </nav>

                <div class="infoSections">
                    <section id="about">
                        <h2>About <?= h(SITE_NAME) ?></h2>
                        <p><?= h(SITE_NAME) ?> is an online library of web novels. Readers can explore books by genre, see what is trending
                            today, and read chapters right in the browser. Members keep a reading list that remembers their progress,
                            review the books they love, and publish their own stories one chapter at a time.</p>
                        <ul class="statCards">
                            <li><strong><?= $stats['books'] ?></strong> books</li>
                            <li><strong><?= $stats['chapters'] ?></strong> chapters</li>
                            <li><strong><?= $stats['genres'] ?></strong> genres</li>
                            <li><strong><?= $stats['members'] ?></strong> members</li>
                        </ul>
                    </section>

                    <section id="help">
                        <h2>Help</h2>
                        <dl class="faq">
                            <dt>Do I need an account to read?</dt>
                            <dd>No. Anyone can browse the library and read the first <?= FREE_CHAPTERS ?> chapters of every book.
                                <a href="login.php?tab=signup">Create a free account</a> to save books, track your progress and buy books.</dd>
                            <dt>How do I find a book by its serial number?</dt>
                            <dd>Log in, open <a href="browse.php">Browse</a> and use the <em>Advanced search</em> box. Every book's serial number
                                (for example NB-000001) is shown on its information page.</dd>
                            <dt>How does buying a book work?</dt>
                            <dd>Choose &ldquo;Buy full book&rdquo; on a book's page, then pay from your <a href="cart.php">Shopping Cart</a>.
                                Once payment succeeds, every chapter is unlocked and the book is added to your library.</dd>
                            <dt>How do I publish my own story?</dt>
                            <dd>Go to <a href="create.php">Create</a>, fill in your book's details and cover, then add chapters whenever you are ready.</dd>
                            <dt>Where is my reading progress?</dt>
                            <dd>Your <a href="reading_list.php">Reading List</a> has a Library tab for saved books and a History tab showing
                                the furthest chapter you have reached in each book.</dd>
                        </dl>
                    </section>

                    <section id="terms">
                        <h2>Terms of Use</h2>
                        <ol>
                            <li>You must keep your login details private and are responsible for activity on your account.</li>
                            <li>Books you publish must be your own work. Do not upload content that is copied, illegal or hateful.</li>
                            <li>Purchases unlock a book for your account only and are not transferable.</li>
                            <li>Reviews should be honest and respectful. We may remove reviews or books that break these terms.</li>
                            <li>This site is a student project for IE4727 and payments are simulated; no real money is charged.</li>
                        </ol>
                    </section>

                    <section id="privacy">
                        <h2>Privacy</h2>
                        <p>We store only what the site needs to work: your username, email, a securely hashed password, an optional profile
                            photo, your reading list, reviews and orders. Card details entered at checkout are checked and then discarded,
                            never saved. A session cookie keeps you logged in, and an optional &ldquo;remember me&rdquo; cookie stores your
                            username for 30 days. Deleting your account removes your personal data.</p>
                    </section>

                    <section id="contact">
                        <h2>Contact</h2>
                        <ul class="contactList">
                            <li><strong>Email:</strong> <?= FEEDBACK_EMAIL ?> (or use the feedback form below)</li>
                            <li><strong>Address:</strong> School of EEE, Nanyang Technological University, 50 Nanyang Avenue, Singapore 639798</li>
                            <li><strong>Hours:</strong> Monday to Friday, 9am &ndash; 5pm</li>
                        </ul>
                    </section>

                    <section id="feedback">
                        <h2>Feedback</h2>
                        <p>Found a bug, or have an idea for the library? Let us know.</p>
                        <form action="info.php#feedback" method="post" class="stackForm" id="feedbackForm" novalidate>
<?php foreach ($errors as $error): ?>
                            <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                            <div class="fieldRow">
                                <div>
                                    <label for="fbName">Name</label>
                                    <input type="text" id="fbName" name="name" value="<?= h($name) ?>" required minlength="2" maxlength="60">
                                    <p class="fieldError"></p>
                                </div>
                                <div>
                                    <label for="fbEmail">Email</label>
                                    <input type="email" id="fbEmail" name="email" value="<?= h($email) ?>" required maxlength="100">
                                    <p class="fieldError"></p>
                                </div>
                            </div>
                            <label for="fbSubject">Topic</label>
                            <select id="fbSubject" name="subject" required>
                                <option value="">Choose a topic</option>
<?php foreach (FEEDBACK_TOPICS as $topic): ?>
                                <option<?= $subject === $topic ? ' selected' : '' ?>><?= $topic ?></option>
<?php endforeach; ?>
                            </select>
                            <p class="fieldError"></p>
                            <label for="fbMessage">Message</label>
                            <textarea id="fbMessage" name="message" rows="5" required minlength="10" maxlength="2000"><?= h($message) ?></textarea>
                            <span class="charCount" data-for="fbMessage"></span>
                            <p class="fieldError"></p>
                            <button type="submit" class="btn">Send feedback</button>
                        </form>
                    </section>
                </div>
            </div>
<?php require 'includes/footer.php'; ?>
