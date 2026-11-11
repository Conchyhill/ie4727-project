// Sign in, sign up, sign out and "who am I" (replaces login.php and logout.php).
import { Router } from 'express';
import bcrypt from 'bcryptjs';
import { hasErrors, validateLogin, validateSignup } from '@novel/shared';
import { get, run } from '../db.js';
import { cartCount, fail, fieldErrors, raw, str } from '../lib.js';

const router = Router();
// "Remember me" cookie only stores the username, to pre-fill the form next time
const REMEMBER_COOKIE = 'remember_username';
const THIRTY_DAYS = 30 * 86400 * 1000;

// Logged-in user (or null), the nav bar's cart badge and the remembered username
router.get('/auth/me', (req, res) => {
    const remembered = req.cookies[REMEMBER_COOKIE];
    res.json({
        user: req.user,
        cartCount: req.user ? cartCount(req.user.id) : 0,
        rememberedUsername: typeof remembered === 'string' ? remembered : '',
    });
});

router.post('/auth/login', (req, res) => {
    const identifier = str(req.body.identifier);
    const password = raw(req.body.password);
    const errors = validateLogin({ identifier, password });
    if (hasErrors(errors)) return fieldErrors(res, errors);

    const account = get('SELECT id, username, password_hash FROM users WHERE username = ? OR email = ?', identifier, identifier);
    // same message whether the username or the password is wrong, so accounts can't be guessed
    if (!account || !bcrypt.compareSync(password, account.password_hash)) {
        return fail(res, 400, 'Incorrect username/email or password.');
    }
    req.session.userId = account.id;
    if (req.body.remember === true) {
        res.cookie(REMEMBER_COOKIE, account.username, { maxAge: THIRTY_DAYS, httpOnly: true, sameSite: 'lax' });
    } else {
        res.clearCookie(REMEMBER_COOKIE);
    }
    res.json({ message: `Welcome back, ${account.username}!` });
});

router.post('/auth/signup', (req, res) => {
    const values = {
        username: str(req.body.username),
        email: str(req.body.email),
        password: raw(req.body.password),
        confirm: raw(req.body.confirm),
    };
    const errors = validateSignup(values);
    // checks that need the database
    if (!errors.username && get('SELECT 1 FROM users WHERE username = ?', values.username)) {
        errors.username = 'That username is already taken.';
    }
    if (!errors.email && get('SELECT 1 FROM users WHERE email = ?', values.email)) {
        errors.email = 'An account with that email already exists.';
    }
    if (hasErrors(errors)) return fieldErrors(res, errors);

    const result = run('INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)',
        values.username, values.email, bcrypt.hashSync(values.password, 10));
    req.session.userId = Number(result.lastInsertRowid);
    res.status(201).json({ message: `Welcome, ${values.username}! Your account has been created.` });
});

router.post('/auth/logout', (req, res) => {
    req.session = null;
    res.json({ message: 'You have been logged out.' });
});

export default router;
