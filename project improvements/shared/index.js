// Rules shared by the React client and the Node server.
// The browser runs these for instant feedback; the server runs the same functions again,
// because anything sent from a browser can be changed. Each validator returns
// { fieldName: 'message' } and an empty object means the input is valid.

// TODO: replace with the project title once decided (same as SITE_NAME in the PHP version)
export const SITE_NAME = 'IE4727 Library';

// Chapters 1..FREE_CHAPTERS of every book can be read without buying it
export const FREE_CHAPTERS = 3;
export const MAX_TAGS = 5;
export const MAX_IMAGE_BYTES = 2 * 1024 * 1024;
export const LANGUAGES = ['English', 'Chinese', 'Malay', 'Tamil', 'Japanese', 'Korean', 'Other'];
export const FEEDBACK_TOPICS = ['General feedback', 'Report a problem', 'Book suggestion', 'Account help'];
export const SORTS = { views: 'Popularity', updated: 'Latest update', rating: 'Rating' };

export const USERNAME_RE = /^[A-Za-z0-9_]{3,20}$/;
// Same rule as the browser's <input type="email"> check, so "name@localhost" passes on both sides
const EMAIL_RE =
    /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
const CARD_NAME_RE = /^[A-Za-z][A-Za-z .'-]{1,59}$/;
const SERIAL_RE = /^(?:NB-)?(\d{1,6})$/i;

const text = (value) => (typeof value === 'string' ? value.trim() : '');
// Length in characters (code points), like PHP's mb_strlen
export const charLength = (value) => [...(value ?? '')].length;
const between = (value, min, max) => charLength(value) >= min && charLength(value) <= max;

// Drop the fields that passed
function only(errors) {
    return Object.fromEntries(Object.entries(errors).filter(([, message]) => message));
}

export const hasErrors = (errors) => Object.keys(errors).length > 0;

export function isValidEmail(email) {
    return typeof email === 'string' && email.length <= 100 && EMAIL_RE.test(email);
}

export function isStrongPassword(password) {
    return typeof password === 'string' && password.length >= 8 && /[A-Za-z]/.test(password) && /\d/.test(password);
}

// 0..4, same scoring as the strength meter in the PHP version
export function passwordStrength(password = '') {
    let score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++;
    if (/\d/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;
    score = Math.min(score, 4);
    return { score, label: ['Too weak', 'Weak', 'Fair', 'Good', 'Strong'][score] };
}

// "12", "000012", "nb-12" and "NB-000012" all mean NB-000012. Returns '' when it is not a serial.
export function normaliseSerial(value) {
    const match = text(value).match(SERIAL_RE);
    return match ? 'NB-' + match[1].padStart(6, '0') : '';
}

export const cardDigits = (value) => String(value ?? '').replace(/[\s-]/g, '');

// Luhn checksum used by real card numbers
export function luhnValid(number) {
    let sum = 0;
    let double = false;
    for (let i = number.length - 1; i >= 0; i--) {
        let digit = Number(number[i]);
        if (double) {
            digit *= 2;
            if (digit > 9) digit -= 9;
        }
        sum += digit;
        double = !double;
    }
    return sum % 10 === 0;
}

// ---------------------------------------------------------------- forms

export function validateLogin({ identifier, password }) {
    return only({
        identifier: !text(identifier) && 'Enter your username or email.',
        password: !password && 'Enter your password.',
    });
}

export function validateSignup({ username, email, password, confirm }) {
    return only({
        username: !USERNAME_RE.test(text(username)) && 'Username must be 3-20 characters: letters, numbers and underscores only.',
        email: !isValidEmail(text(email)) && 'Enter a valid email address.',
        password: !isStrongPassword(password) && 'Password must be at least 8 characters and include a letter and a number.',
        confirm: (!confirm ? 'Confirm your password.' : password !== confirm && 'The two passwords do not match.'),
    });
}

export function validateProfile({ username, email }) {
    return only({
        username: !USERNAME_RE.test(text(username)) && 'Username must be 3-20 characters: letters, numbers and underscores only.',
        email: !isValidEmail(text(email)) && 'Enter a valid email address.',
    });
}

export function validatePasswordChange({ current, password, confirm }) {
    return only({
        current: !current && 'Enter your current password.',
        password: !isStrongPassword(password) && 'New password must be at least 8 characters and include a letter and a number.',
        confirm: (!confirm ? 'Confirm your new password.' : password !== confirm && 'The new passwords do not match.'),
    });
}

export function validateDeleteAccount({ password, confirm }) {
    return only({
        password: !password && 'Enter your password to confirm.',
        confirm: confirm !== true && 'Tick the box to confirm you want to delete your account.',
    });
}

export function validateReview({ rating, comment }) {
    const stars = Number(rating);
    return only({
        rating: !(Number.isInteger(stars) && stars >= 1 && stars <= 5) && 'Choose a rating from 1 to 5 stars.',
        comment: !between(text(comment), 10, 1000) && 'Your review must be between 10 and 1000 characters.',
    });
}

// genreIds / tagIds: the valid ids, when the caller knows them
export function validateBook(values, { genreIds = null, tagIds = null } = {}) {
    const genreId = Number(values.genreId);
    const tags = values.tags ?? [];
    return only({
        title: !between(text(values.title), 2, 150) && 'The title must be between 2 and 150 characters.',
        genreId: !(genreId > 0 && (!genreIds || genreIds.includes(genreId))) && 'Choose a genre.',
        language: !LANGUAGES.includes(values.language) && 'Choose a language.',
        status: !['ongoing', 'completed'].includes(values.status) && 'Choose whether the book is ongoing or completed.',
        price: !/^\d{1,2}(\.\d{1,2})?$/.test(text(String(values.price ?? ''))) && 'Price must be between 0.00 and 99.99.',
        synopsis: !between(text(values.synopsis), 30, 2000) && 'The synopsis must be between 30 and 2000 characters.',
        tags: (tags.length > MAX_TAGS ? `Choose at most ${MAX_TAGS} tags.`
            : tagIds && tags.some((id) => !tagIds.includes(Number(id))) && 'Choose tags from the list.'),
    });
}

export function validateChapter({ title, content }) {
    return only({
        title: !between(text(title), 1, 150) && 'The chapter title must be between 1 and 150 characters.',
        content: charLength(text(content)) < 100 && 'The chapter text must be at least 100 characters.',
    });
}

export function validateCheckout({ cardName, cardNumber, expiry, cvv }, now = new Date()) {
    const digits = cardDigits(cardNumber);
    const match = text(expiry).match(/^(0[1-9]|1[0-2])\/(\d{2})$/);
    let expiryError = false;
    if (!match) {
        expiryError = 'Enter the expiry date as MM/YY.';
    } else if (Number('20' + match[2] + match[1]) < now.getFullYear() * 100 + now.getMonth() + 1) {
        expiryError = 'This card has expired.';
    }
    return only({
        cardName: !CARD_NAME_RE.test(text(cardName)) && 'Enter the name shown on the card.',
        cardNumber: !(/^\d{13,19}$/.test(digits) && luhnValid(digits)) && 'Enter a valid card number.',
        expiry: expiryError,
        cvv: !/^\d{3,4}$/.test(text(cvv)) && 'Enter the 3 or 4 digit security code.',
    });
}

export function validateFeedback({ name, email, subject, message }) {
    const cleanName = text(name);
    return only({
        name: (!between(cleanName, 2, 60) || /[\r\n]/.test(cleanName)) && 'Enter your name (2-60 characters).',
        email: !isValidEmail(text(email)) && 'Enter a valid email address so we can reply.',
        subject: !FEEDBACK_TOPICS.includes(subject) && 'Choose a topic.',
        message: !between(text(message), 10, 2000) && 'Your message must be between 10 and 2000 characters.',
    });
}
