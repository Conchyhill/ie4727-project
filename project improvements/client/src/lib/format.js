// Display helpers (the JS version of format_views, money, time_ago and stars in functions.php)

// 27400000 -> "27.4M", 980500 -> "980.5K"
export function formatViews(n) {
    const value = Number(n) || 0;
    if (value >= 1e6) return `${+(value / 1e6).toFixed(1)}M`;
    if (value >= 1e3) return `${+(value / 1e3).toFixed(1)}K`;
    return String(value);
}

export const money = (amount) => '$' + Number(amount ?? 0).toFixed(2);

// Seconds come from SQL, so browser and server clocks can't disagree
export function timeAgo(seconds) {
    const units = [[86400 * 30, 'month'], [86400 * 7, 'week'], [86400, 'day'], [3600, 'hour'], [60, 'minute']];
    for (const [size, name] of units) {
        if (seconds >= size) {
            const n = Math.floor(seconds / size);
            return `${n} ${name}${n > 1 ? 's' : ''} ago`;
        }
    }
    return 'just now';
}

// "2026-11-05 14:30:00" (stored in local time) -> Date
const toDate = (value) => new Date(String(value).replace(' ', 'T'));

export const formatDate = (value) => toDate(value).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
export const formatDateTime = (value) =>
    toDate(value).toLocaleString('en-GB', { day: 'numeric', month: 'short', year: 'numeric', hour: 'numeric', minute: '2-digit' });
export const formatDay = (value) => toDate(value).toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short' });
export const formatMonthYear = (value) => toDate(value).toLocaleDateString('en-GB', { month: 'long', year: 'numeric' });

export const rating = (value) => (value === null || value === undefined ? '-' : Number(value).toFixed(1));

export const plural = (n, word) => `${n} ${word}${n === 1 ? '' : 's'}`;

export const coverUrl = (cover) => cover || '/images/cover_placeholder.svg';
export const avatarUrl = (photo) => photo || '/images/avatar_default.svg';
