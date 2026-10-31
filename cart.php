<?php
// Shopping cart and checkout. Payment is simulated (a third-party gateway is assumed):
// card numbers starting with 4 are approved, any other valid number is declined.
// Card details are only validated, never stored.
require 'includes/init.php';
require_login();

$userId = current_user()['id'];
$errors = [];
$cardName = '';

// Books already bought (e.g. in another tab) can't be bought twice
db_query(
    "DELETE ci FROM cart_items ci
     JOIN order_items oi ON oi.book_id = ci.book_id
     JOIN orders o ON o.id = oi.order_id AND o.user_id = ci.user_id AND o.status = 'success'
     WHERE ci.user_id = ?",
    'i', [$userId]
);

$items = db_all(
    'SELECT b.id, b.title, b.cover, b.price, u.username AS author,
            (SELECT COUNT(*) FROM chapters c WHERE c.book_id = b.id) AS chapters
     FROM cart_items ci
     JOIN books b ON b.id = ci.book_id
     JOIN users u ON u.id = b.user_id
     WHERE ci.user_id = ?
     ORDER BY ci.added_at',
    'i', [$userId]
);
$total = array_sum(array_column($items, 'price'));

// Luhn checksum used by real card numbers
function luhn_valid($number)
{
    $sum = 0;
    $double = false;
    for ($i = strlen($number) - 1; $i >= 0; $i--) {
        $digit = (int) $number[$i];
        if ($double) {
            $digit *= 2;
            if ($digit > 9) {
                $digit -= 9;
            }
        }
        $sum += $digit;
        $double = !$double;
    }
    return $sum % 10 === 0;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && param($_POST, 'action') === 'checkout') {
    $cardName = param($_POST, 'card_name');
    $cardNumber = preg_replace('/[\s-]/', '', param($_POST, 'card_number'));
    $expiry = param($_POST, 'expiry');
    $cvv = param($_POST, 'cvv');

    if (!$items) {
        $errors[] = 'Your cart is empty.';
    }
    if (!preg_match("/^[A-Za-z][A-Za-z .'-]{1,59}$/", $cardName)) {
        $errors[] = 'Enter the name shown on the card.';
    }
    if (!preg_match('/^\d{13,19}$/', $cardNumber) || !luhn_valid($cardNumber)) {
        $errors[] = 'Enter a valid card number.';
    }
    if (!preg_match('#^(0[1-9]|1[0-2])/(\d{2})$#', $expiry, $m)) {
        $errors[] = 'Enter the expiry date as MM/YY.';
    } elseif ((int) ('20' . $m[2] . $m[1]) < (int) date('Ym')) {
        $errors[] = 'This card has expired.';
    }
    if (!preg_match('/^\d{3,4}$/', $cvv)) {
        $errors[] = 'Enter the 3 or 4 digit security code.';
    }

    if (!$errors) {
        $status = $cardNumber[0] === '4' ? 'success' : 'failed';  // simulated gateway response

        $db->begin_transaction();
        db_query('INSERT INTO orders (user_id, total, status) VALUES (?, ?, ?)', 'ids', [$userId, $total, $status]);
        $orderId = $db->insert_id;
        foreach ($items as $item) {
            db_query('INSERT INTO order_items (order_id, book_id, price) VALUES (?, ?, ?)', 'iid', [$orderId, $item['id'], $item['price']]);
            if ($status === 'success') {
                // bought books go straight into the member's library
                db_query('INSERT INTO reading_list (user_id, book_id, in_library) VALUES (?, ?, 1)
                          ON DUPLICATE KEY UPDATE in_library = 1', 'ii', [$userId, $item['id']]);
            }
        }
        if ($status === 'success') {
            db_query('DELETE FROM cart_items WHERE user_id = ?', 'i', [$userId]);
        }
        $db->commit();

        header('Location: cart.php?order=' . $orderId);  // the result panel below shows the outcome
        exit;
    }
}

// Result of the last checkout attempt (?order=ID, only for the member's own orders)
$result = null;
$orderId = (int) param($_GET, 'order');
if ($orderId) {
    $result = db_row('SELECT id, total, status, created_at FROM orders WHERE id = ? AND user_id = ?', 'ii', [$orderId, $userId]);
    if ($result) {
        $result['books'] = db_all('SELECT b.id, b.title FROM order_items oi JOIN books b ON b.id = oi.book_id WHERE oi.order_id = ?', 'i', [$orderId]);
    }
}

$pageTitle = 'Shopping Cart';
$pageScripts = ['forms.js'];
require 'includes/header.php';
?>
<?php if ($result && $result['status'] === 'success'): ?>
            <section class="resultPanel resultSuccess">
                <p class="resultIcon">&#10003;</p>
                <h2>Payment successful</h2>
                <p>Order #<?= $result['id'] ?> &middot; <?= money($result['total']) ?> &middot; <?= date('j M Y, g:i a', strtotime($result['created_at'])) ?></p>
                <p>These books are now unlocked and in your library:</p>
                <ul class="resultBooks">
<?php foreach ($result['books'] as $book): ?>
                    <li><a href="read.php?book=<?= $book['id'] ?>&amp;ch=1"><?= h($book['title']) ?></a></li>
<?php endforeach; ?>
                </ul>
                <div class="formActions">
                    <a class="btn" href="reading_list.php">Go to my library</a>
                    <a class="btn btnSecondary" href="index.php">Back to Home</a>
                </div>
            </section>
<?php elseif ($result): ?>
            <section class="resultPanel resultFailed">
                <p class="resultIcon">&#10007;</p>
                <h2>Payment failed</h2>
                <p>Your payment of <?= money($result['total']) ?> was declined by the payment provider (order #<?= $result['id'] ?>).
                    Nothing was charged and your cart has been kept. Please try another card.</p>
            </section>
<?php endif; ?>

<?php if (!$result || $result['status'] === 'failed'): ?>
            <section>
                <h2>Shopping Cart</h2>
<?php if (!$items): ?>
                <p class="emptyNote">Your cart is empty. <a href="browse.php">Browse books</a> and use &ldquo;Buy full book&rdquo; to add one.</p>
<?php else: ?>
                <table class="dataTable cartTable">
                    <thead>
                        <tr><th scope="col">Book</th><th scope="col">Author</th><th scope="col">Chapters</th><th scope="col">Price</th><th scope="col"><span class="visuallyHidden">Remove</span></th></tr>
                    </thead>
                    <tbody>
<?php foreach ($items as $item): ?>
                        <tr>
                            <td class="cartBook">
                                <img src="<?= h(cover_url($item['cover'])) ?>" alt="" width="45" height="60">
                                <a href="book.php?id=<?= $item['id'] ?>"><?= h($item['title']) ?></a>
                            </td>
                            <td><?= h($item['author']) ?></td>
                            <td><?= $item['chapters'] ?></td>
                            <td><?= money($item['price']) ?></td>
                            <td>
                                <form action="cart_action.php" method="post" class="removeForm">
                                    <input type="hidden" name="book_id" value="<?= $item['id'] ?>">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="back" value="cart.php">
                                    <button type="submit" class="linkButton" data-confirm="Remove &quot;<?= h($item['title']) ?>&quot; from your cart?">Remove</button>
                                </form>
                            </td>
                        </tr>
<?php endforeach; ?>
                    </tbody>
                    <tfoot>
                        <tr><th scope="row" colspan="3">Total (<?= count($items) ?> book<?= count($items) === 1 ? '' : 's' ?>)</th><td colspan="2"><strong><?= money($total) ?></strong></td></tr>
                    </tfoot>
                </table>
<?php endif; ?>
            </section>

<?php if ($items): ?>
            <!-- CHECKOUT -->
            <section>
                <h2>Checkout</h2>
                <form action="cart.php" method="post" class="stackForm checkoutForm" id="checkoutForm" novalidate>
<?php foreach ($errors as $error): ?>
                    <p class="flash flash-error"><?= h($error) ?></p>
<?php endforeach; ?>
                    <input type="hidden" name="action" value="checkout">
                    <label for="cardName">Name on card</label>
                    <input type="text" id="cardName" name="card_name" value="<?= h($cardName) ?>" required maxlength="60"
                           pattern="[A-Za-z][A-Za-z .'\-]{1,59}" autocomplete="cc-name">
                    <p class="fieldError"></p>

                    <label for="cardNumber">Card number</label>
                    <input type="text" id="cardNumber" name="card_number" required inputmode="numeric" maxlength="23"
                           pattern="[0-9 \-]{13,23}" placeholder="4242 4242 4242 4242" autocomplete="cc-number">
                    <p class="fieldError"></p>

                    <div class="fieldRow">
                        <div>
                            <label for="expiry">Expiry (MM/YY)</label>
                            <input type="text" id="expiry" name="expiry" required pattern="(0[1-9]|1[0-2])/[0-9]{2}" maxlength="5"
                                   placeholder="MM/YY" autocomplete="cc-exp">
                            <p class="fieldError"></p>
                        </div>
                        <div>
                            <label for="cvv">Security code</label>
                            <input type="password" id="cvv" name="cvv" required pattern="[0-9]{3,4}" maxlength="4" inputmode="numeric" autocomplete="cc-csc">
                            <p class="fieldError"></p>
                        </div>
                    </div>

                    <p class="hint">Demo payment: card numbers starting with 4 are approved (e.g. 4242 4242 4242 4242);
                        other valid numbers are declined (e.g. 5555 5555 5555 4444). Card details are never stored.</p>
                    <button type="submit" class="btn">Pay <?= money($total) ?></button>
                </form>
            </section>
<?php endif; ?>
<?php endif; ?>
<?php require 'includes/footer.php'; ?>
