// Small building blocks used across the pages.
import { Link } from 'react-router';
import { charLength } from '@novel/shared';
import { avatarUrl, coverUrl } from '../lib/format.js';

export function Spinner({ label = 'Loading...' }) {
    return (
        <div className="flex items-center justify-center gap-3 py-16 text-stone" role="status">
            <span className="h-6 w-6 animate-spin rounded-full border-2 border-khaki border-t-stone" aria-hidden="true" />
            <span className="text-sm">{label}</span>
        </div>
    );
}

// Error panel for a page whose data could not be loaded
export function ErrorPanel({ error, children }) {
    const notFound = error?.status === 404;
    return (
        <section className="card mx-auto max-w-xl text-center">
            <p className="text-4xl" aria-hidden="true">{notFound ? '📖' : '⚠'}</p>
            <h1 className="mt-2 text-xl font-bold">{notFound ? 'Not found' : 'Something went wrong'}</h1>
            <p className="mt-2 text-stone">{error?.message}</p>
            <div className="mt-5 flex justify-center gap-3">{children ?? <Link className="btn" to="/browse">Browse books</Link>}</div>
        </section>
    );
}

export function EmptyNote({ children }) {
    return <p className="rounded-xl border border-dashed border-khaki bg-white/50 px-4 py-6 text-center text-sm text-stone">{children}</p>;
}

export function Cover({ src, title, className = '' }) {
    return <img src={coverUrl(src)} alt={`Cover of ${title}`} loading="lazy" className={`aspect-[3/4] bg-khaki object-cover ${className}`} />;
}

export function Avatar({ src, size = 44, className = '' }) {
    return <img src={avatarUrl(src)} alt="" width={size} height={size} className={`shrink-0 rounded-full bg-cream object-cover ring-1 ring-khaki ${className}`}
        style={{ width: size, height: size }} />;
}

// ★★★★☆ 4.3, or "No ratings"
export function Stars({ value, showNumber = true }) {
    if (value === null || value === undefined) return <span className="text-stone">No ratings</span>;
    const full = Math.round(value);
    return (
        <span className="whitespace-nowrap" aria-label={`Rated ${Number(value).toFixed(1)} out of 5`}>
            <span className="text-amber-500" aria-hidden="true">{'★'.repeat(full)}</span>
            <span className="text-khaki" aria-hidden="true">{'★'.repeat(5 - full)}</span>
            {showNumber && <span className="ml-1 font-medium">{Number(value).toFixed(1)}</span>}
        </span>
    );
}

export function StatusChip({ status }) {
    const done = status === 'completed' || status === 'success';
    const label = { success: 'Successful', failed: 'Failed' }[status] ?? status.charAt(0).toUpperCase() + status.slice(1);
    const colours = status === 'failed' ? 'bg-red-50 text-red-700 ring-red-200'
        : done ? 'bg-emerald-50 text-emerald-700 ring-emerald-200' : 'bg-amber-50 text-amber-800 ring-amber-200';
    return <span className={`inline-flex rounded-full px-2.5 py-0.5 text-xs font-semibold ring-1 ${colours}`}>{label}</span>;
}

// Label + control + hint + error message
export function Field({ label, htmlFor, error, hint, children, className = '' }) {
    return (
        <div className={className}>
            {label && <label className="label" htmlFor={htmlFor}>{label}</label>}
            {children}
            {hint && !error && <p className="mt-1 text-xs text-stone">{hint}</p>}
            {error && <p className="mt-1 text-xs font-medium text-red-700" id={htmlFor && `${htmlFor}-error`}>{error}</p>}
        </div>
    );
}

// Message for errors that don't belong to one field (e.g. "Incorrect password")
export function FormError({ message }) {
    if (!message) return null;
    return <p className="rounded-lg bg-red-50 px-3 py-2 text-sm font-medium text-red-800 ring-1 ring-red-200" role="alert">{message}</p>;
}

export function CharCount({ value, max, min }) {
    const n = charLength(value);
    const over = max && n > max;
    const under = min && n > 0 && n < min;
    return (
        <span className={`mt-1 block text-right text-xs ${over || under ? 'text-red-700' : 'text-stone'}`}>
            {n}{max ? ` / ${max}` : ''} characters{under ? ` (at least ${min})` : ''}
        </span>
    );
}

// Pill-shaped switch made of links (Today / This week, Library / History)
export function PillTabs({ items }) {
    return (
        <div className="inline-flex rounded-full bg-white/70 p-1 ring-1 ring-khaki/60">
            {items.map((item) => (
                <Link key={item.to} to={item.to} aria-current={item.active ? 'page' : undefined}
                    className={`rounded-full px-3.5 py-1 text-sm font-medium transition ${item.active ? 'bg-stone text-white shadow-sm' : 'text-stone hover:text-ink'}`}>
                    {item.label}
                </Link>
            ))}
        </div>
    );
}

export function Breadcrumb({ items }) {
    return (
        <nav aria-label="Breadcrumb" className="mb-5 text-sm text-stone">
            {items.map((item, i) => (
                <span key={i}>
                    {i > 0 && <span className="mx-1.5 text-khaki">/</span>}
                    {item.to ? <Link className="link" to={item.to}>{item.label}</Link> : <span className="text-ink">{item.label}</span>}
                </span>
            ))}
        </nav>
    );
}

export function StatCards({ items }) {
    return (
        <ul className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
            {items.map(([value, label]) => (
                <li key={label} className="rounded-xl bg-cream/80 px-4 py-3 ring-1 ring-khaki/50">
                    <strong className="block text-xl text-ink">{value}</strong>
                    <span className="text-xs text-stone">{label}</span>
                </li>
            ))}
        </ul>
    );
}
