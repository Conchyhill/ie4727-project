// Chapter reader. Free chapters are open to everyone; later chapters need the book to be bought.
// Text size is remembered in this browser; the arrow keys move between chapters.
import { useEffect, useState } from 'react';
import { Link, useLocation, useNavigate, useParams } from 'react-router';
import { FREE_CHAPTERS } from '@novel/shared';
import { api } from '../lib/api.js';
import { loginPath, useApi, useMemberAction, useTitle } from '../lib/hooks.js';
import { formatDate, money } from '../lib/format.js';
import { Breadcrumb, ErrorPanel, Spinner } from '../components/ui.jsx';

const SIZES = [15, 16, 18, 20, 22, 24, 26];
function storedSize() {
    try {
        const n = Number(localStorage.getItem('readerFontSize'));
        return SIZES.includes(n) ? n : 18;
    } catch {
        return 18;
    }
}

function ChapterNav({ bookId, number, chapters, position }) {
    const navigate = useNavigate();
    const last = chapters[chapters.length - 1]?.number ?? 1;
    return (
        <nav aria-label="Chapter navigation" className="flex items-center gap-2">
            {number > 1
                ? <Link className="btn btn-secondary" to={`/books/${bookId}/read/${number - 1}`} rel="prev">&lsaquo; <span className="hidden sm:inline">Previous</span></Link>
                : <span className="btn btn-secondary pointer-events-none opacity-40">&lsaquo; <span className="hidden sm:inline">Previous</span></span>}
            <label className="sr-only" htmlFor={`picker-${position}`}>Jump to chapter</label>
            <select id={`picker-${position}`} className="input min-w-0 flex-1" value={number}
                onChange={(e) => navigate(`/books/${bookId}/read/${e.target.value}`)}>
                {chapters.map((c) => <option key={c.number} value={c.number}>Ch. {c.number}: {c.title}</option>)}
            </select>
            {number < last
                ? <Link className="btn" to={`/books/${bookId}/read/${number + 1}`} rel="next"><span className="hidden sm:inline">Next</span> &rsaquo;</Link>
                : <span className="btn pointer-events-none opacity-40"><span className="hidden sm:inline">Next</span> &rsaquo;</span>}
        </nav>
    );
}

function LockedPanel({ data, reload }) {
    const location = useLocation();
    const memberAction = useMemberAction();
    const { book } = data;
    return (
        <div className="my-8 rounded-2xl bg-cream/70 p-8 text-center ring-1 ring-khaki">
            <p className="text-5xl" aria-hidden="true">🔒</p>
            <h2 className="mt-3 font-sans text-xl font-bold">This chapter is locked</h2>
            <p className="mt-2 font-sans text-stone">
                Chapters 1&ndash;{FREE_CHAPTERS} are free. Buy <strong>{book.title}</strong> for {money(book.price)} to read all {data.chapters.length} chapters.
            </p>
            <div className="mt-5 font-sans">
                {!data.loggedIn && <Link className="btn" to={loginPath(location)}>Log in to buy</Link>}
                {data.loggedIn && data.inCart && <Link className="btn" to="/cart">Go to cart &rsaquo;</Link>}
                {data.loggedIn && !data.inCart && (
                    <button type="button" className="btn" onClick={() => memberAction(() => api.post('/cart', { bookId: book.id }), reload)}>
                        Add to cart &middot; {money(book.price)}
                    </button>
                )}
            </div>
        </div>
    );
}

export default function Reader() {
    const { id, ch } = useParams();
    const navigate = useNavigate();
    const { data, error, reload } = useApi(`/books/${id}/chapters/${ch}`);
    const [size, setSize] = useState(storedSize);
    useTitle(data ? `Ch. ${data.chapter.number}: ${data.chapter.title} - ${data.book.title}` : 'Chapter');

    useEffect(() => {
        try {
            localStorage.setItem('readerFontSize', String(size));
        } catch { /* private browsing: just don't remember it */ }
    }, [size]);

    // ← and → move between chapters (but not while typing or using the chapter picker)
    useEffect(() => {
        if (!data) return undefined;
        const number = data.chapter.number;
        const last = data.chapters[data.chapters.length - 1].number;
        const onKey = (event) => {
            if (event.target instanceof Element && event.target.closest('input, textarea, select')) return;
            if (event.key === 'ArrowLeft' && number > 1) navigate(`/books/${id}/read/${number - 1}`);
            if (event.key === 'ArrowRight' && number < last) navigate(`/books/${id}/read/${number + 1}`);
        };
        window.addEventListener('keydown', onKey);
        return () => window.removeEventListener('keydown', onKey);
    }, [data, id, navigate]);

    if (error) {
        const book = error.body?.book;
        return (
            <ErrorPanel error={error}>
                {book ? <Link className="btn" to={`/books/${book.id}`}>Back to {book.title}</Link> : <Link className="btn" to="/browse">Browse books</Link>}
            </ErrorPanel>
        );
    }
    if (!data) return <Spinner />;
    const { book, chapter, chapters } = data;
    const step = (direction) => setSize(SIZES[Math.min(SIZES.length - 1, Math.max(0, SIZES.indexOf(size) + direction))]);

    return (
        <div className="mx-auto max-w-3xl space-y-5">
            <Breadcrumb items={[{ to: '/', label: 'Home' }, { to: `/books/${book.id}`, label: book.title }, { label: `Chapter ${chapter.number}` }]} />
            <ChapterNav bookId={book.id} number={chapter.number} chapters={chapters} position="top" />

            <article className="card px-6 py-8 sm:px-12 sm:py-10">
                <div className="mb-6 flex items-center justify-end gap-2 text-sm text-stone">
                    <span>Text size</span>
                    <button type="button" className="btn btn-secondary btn-sm" onClick={() => step(-1)} aria-label="Smaller text" disabled={size === SIZES[0]}>A&minus;</button>
                    <button type="button" className="btn btn-secondary btn-sm" onClick={() => step(1)} aria-label="Larger text" disabled={size === SIZES[SIZES.length - 1]}>A+</button>
                    {data.isAuthor && <Link className="btn btn-secondary btn-sm" to={`/create/${book.id}/chapter/${chapter.number}`}>Edit chapter</Link>}
                </div>
                <h1 className="font-serif text-2xl font-bold sm:text-3xl">Chapter {chapter.number}: {chapter.title}</h1>
                <p className="mt-1 mb-8 text-sm text-stone">Published {formatDate(chapter.created_at)}</p>

                {data.canRead ? (
                    <div className="chapter-text font-serif" style={{ fontSize: `${size}px` }}>
                        {chapter.content.trim().split(/\r?\n\s*\r?\n/).map((paragraph, i) => (
                            <p key={i} className="whitespace-pre-line">{paragraph.trim()}</p>
                        ))}
                    </div>
                ) : <LockedPanel data={data} reload={reload} />}
            </article>

            <ChapterNav bookId={book.id} number={chapter.number} chapters={chapters} position="bottom" />
            <p className="text-center text-xs text-stone">Tip: use the ← and → keys to change chapter.</p>
        </div>
    );
}
