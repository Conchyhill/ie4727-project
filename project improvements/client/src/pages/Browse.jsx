// Browse and search. Everyone can filter by keyword, genre and status;
// members can also search by serial number, author and language (Theme 6 requirement).
// The filters live in the URL, so results can be bookmarked and shared.
import { useEffect, useState } from 'react';
import { Link, useLocation, useSearchParams } from 'react-router';
import { normaliseSerial, SORTS } from '@novel/shared';
import { api } from '../lib/api.js';
import { loginPath, useApi, useMemberAction, useTitle } from '../lib/hooks.js';
import { formatViews, plural } from '../lib/format.js';
import { Cover, EmptyNote, ErrorPanel, Field, Spinner, Stars, StatusChip } from '../components/ui.jsx';
import { useAuth } from '../context/AuthContext.jsx';

const STATUSES = { all: 'All', ongoing: 'Ongoing', completed: 'Completed' };

function Filters({ params, setParams, meta }) {
    const { user } = useAuth();
    const location = useLocation();
    const readText = () => ({ q: params.get('q') ?? '', serial: params.get('serial') ?? '', author: params.get('author') ?? '' });
    const [text, setText] = useState(readText);
    const [serialError, setSerialError] = useState('');
    useEffect(() => setText(readText()), [params]);

    const genres = params.getAll('genre');
    const status = params.get('status') ?? 'all';
    const sort = Object.hasOwn(SORTS, params.get('sort') ?? '') ? params.get('sort') : 'views';

    // Change some filters and go back to page 1
    const update = (changes) => {
        const next = new URLSearchParams(params);
        for (const [key, value] of Object.entries(changes)) {
            next.delete(key);
            [].concat(value).filter((v) => v !== '' && v !== 'all').forEach((v) => next.append(key, v));
        }
        next.delete('page');
        setParams(next);
    };

    const submitText = (event) => {
        event.preventDefault();
        if (text.serial && !normaliseSerial(text.serial)) {
            setSerialError('Use NB- followed by up to 6 digits, or just the digits.');
            return;
        }
        setSerialError('');
        update(text);
    };

    const toggleGenre = (slug) => update({ genre: genres.includes(slug) ? genres.filter((g) => g !== slug) : [...genres, slug] });
    const radio = 'h-4 w-4 accent-stone';

    return (
        <form onSubmit={submitText} className="card space-y-5 lg:sticky lg:top-24">
            <h2 className="text-lg font-bold">Filters</h2>
            <Field label="Keywords" htmlFor="q">
                <input id="q" type="search" className="input" placeholder="Title, author, synopsis" value={text.q}
                    onChange={(e) => setText({ ...text, q: e.target.value })} />
            </Field>

            <fieldset className="space-y-3 rounded-xl bg-cream/60 p-3 ring-1 ring-khaki/50">
                <legend className="flex items-center gap-2 px-1 text-sm font-semibold">
                    Advanced search <span className="chip bg-stone text-white ring-0">Members</span>
                </legend>
                {user ? (
                    <>
                        <Field label="Serial number" htmlFor="serial" error={serialError}>
                            <input id="serial" className="input" placeholder="e.g. NB-000001" value={text.serial} aria-invalid={serialError ? true : undefined}
                                onChange={(e) => setText({ ...text, serial: e.target.value })} />
                        </Field>
                        <Field label="Author" htmlFor="author">
                            <input id="author" className="input" maxLength={30} value={text.author}
                                onChange={(e) => setText({ ...text, author: e.target.value })} />
                        </Field>
                        <Field label="Language" htmlFor="language">
                            <select id="language" className="input" value={params.get('language') ?? ''} onChange={(e) => update({ language: e.target.value })}>
                                <option value="">Any</option>
                                {meta?.bookLanguages.map((l) => <option key={l}>{l}</option>)}
                            </select>
                        </Field>
                    </>
                ) : (
                    <p className="text-sm text-stone">
                        <Link className="link" to={loginPath(location)}>Log in</Link> to search by serial number, author and language.
                    </p>
                )}
            </fieldset>

            <fieldset>
                <legend className="mb-2 text-sm font-semibold">Genre</legend>
                <div className="grid grid-cols-2 gap-1.5 lg:grid-cols-1">
                    {meta?.genres.map((g) => (
                        <label key={g.slug} className="flex cursor-pointer items-center gap-2 text-sm">
                            <input type="checkbox" className={radio} checked={genres.includes(g.slug)} onChange={() => toggleGenre(g.slug)} /> {g.name}
                        </label>
                    ))}
                </div>
            </fieldset>

            <fieldset>
                <legend className="mb-2 text-sm font-semibold">Status</legend>
                <div className="flex flex-wrap gap-x-4 gap-y-1.5">
                    {Object.entries(STATUSES).map(([value, label]) => (
                        <label key={value} className="flex cursor-pointer items-center gap-2 text-sm">
                            <input type="radio" name="status" className={radio} checked={status === value} onChange={() => update({ status: value })} /> {label}
                        </label>
                    ))}
                </div>
            </fieldset>

            <fieldset>
                <legend className="mb-2 text-sm font-semibold">Sort by</legend>
                <div className="flex flex-wrap gap-x-4 gap-y-1.5">
                    {Object.entries(SORTS).map(([value, label]) => (
                        <label key={value} className="flex cursor-pointer items-center gap-2 text-sm">
                            <input type="radio" name="sort" className={radio} checked={sort === value} onChange={() => update({ sort: value })} /> {label}
                        </label>
                    ))}
                </div>
            </fieldset>

            <div className="flex gap-2">
                <button type="submit" className="btn flex-1">Apply</button>
                <button type="button" className="btn btn-secondary" onClick={() => setParams(new URLSearchParams())}>Reset</button>
            </div>
        </form>
    );
}

function BookRow({ book, onAdd }) {
    return (
        <li className="card flex flex-col gap-4 p-4 sm:flex-row sm:p-5">
            <Link to={`/books/${book.id}`} className="shrink-0 self-start">
                <Cover src={book.cover} title={book.title} className="w-24 rounded-lg shadow-sm sm:w-28" />
            </Link>
            <div className="min-w-0 flex-1">
                <ul className="mb-1 flex flex-wrap gap-1.5">
                    <li className="chip bg-sand/30 text-ink">{book.genre}</li>
                    {book.tags.map((tag) => <li key={tag} className="chip">{tag}</li>)}
                </ul>
                <h3 className="text-lg font-bold"><Link to={`/books/${book.id}`} className="hover:text-stone">{book.title}</Link></h3>
                <p className="text-sm text-stone">by {book.author} &middot; {book.serial_no}</p>
                <p className="mt-2 line-clamp-2 text-sm">{book.synopsis}</p>
                <p className="mt-2 flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-stone">
                    <Stars value={book.avg_rating} /> &middot; {plural(book.chapter_count, 'chapter')} &middot; {formatViews(book.views)} views
                    &middot; <StatusChip status={book.status} />
                </p>
            </div>
            <div className="sm:self-center">
                {book.inLibrary
                    ? <span className="btn btn-done">✓ In Library</span>
                    : <button type="button" className="btn" onClick={() => onAdd(book)}>+ Add</button>}
            </div>
        </li>
    );
}

function Pagination({ page, pages, params }) {
    if (pages <= 1) return null;
    const link = (n) => {
        const next = new URLSearchParams(params);
        next.set('page', n);
        return `/browse?${next}`;
    };
    const item = 'grid h-9 min-w-9 place-items-center rounded-full px-3 text-sm font-medium ring-1 ring-khaki transition';
    return (
        <nav aria-label="Result pages" className="mt-6 flex flex-wrap justify-center gap-2">
            {page > 1 && <Link className={`${item} bg-white hover:bg-cream`} to={link(page - 1)}>&lsaquo; Prev</Link>}
            {Array.from({ length: pages }, (_, i) => i + 1).map((n) => (
                <Link key={n} to={link(n)} aria-current={n === page ? 'page' : undefined}
                    className={`${item} ${n === page ? 'bg-stone text-white ring-stone' : 'bg-white hover:bg-cream'}`}>{n}</Link>
            ))}
            {page < pages && <Link className={`${item} bg-white hover:bg-cream`} to={link(page + 1)}>Next &rsaquo;</Link>}
        </nav>
    );
}

export default function Browse() {
    const [params, setParams] = useSearchParams();
    const q = params.get('q') ?? '';
    useTitle(q ? `Search: ${q}` : 'Browse');
    const { data: meta } = useApi('/meta');
    const { data, error, loading, reload } = useApi(`/books?${params}`);
    const memberAction = useMemberAction();

    // Braces matter: scrollTo() returns a Promise in newer browsers, and React would
    // treat a returned value as the clean-up function and crash on leaving the page
    useEffect(() => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }, [params.get('page')]);

    const addToLibrary = (book) => memberAction(() => api.post('/reading-list', { bookId: book.id }), reload);

    return (
        <div className="grid gap-6 lg:grid-cols-[280px_1fr]">
            <aside><Filters params={params} setParams={setParams} meta={meta} /></aside>
            <section aria-live="polite" aria-busy={loading}>
                <div className="mb-4 flex flex-wrap items-baseline justify-between gap-2">
                    <h1 className="section-title mb-0">{q ? <>Results for &ldquo;{q}&rdquo;</> : 'All books'}</h1>
                    {data && <span className="text-sm text-stone">{plural(data.total, 'book')} &middot; sorted by {SORTS[data.sort].toLowerCase()}</span>}
                </div>
                {error && <ErrorPanel error={error} />}
                {!data && !error && <Spinner />}
                {data && (
                    <div className={loading ? 'opacity-60 transition' : 'transition'}>
                        {data.books.length === 0 && (
                            <EmptyNote>No books match these filters. Try removing a filter or{' '}
                                <button type="button" className="link cursor-pointer" onClick={() => setParams(new URLSearchParams())}>reset</button>.
                            </EmptyNote>
                        )}
                        <ul className="space-y-4">
                            {data.books.map((book) => <BookRow key={book.id} book={book} onAdd={addToLibrary} />)}
                        </ul>
                        <Pagination page={data.page} pages={data.pages} params={params} />
                    </div>
                )}
            </section>
        </div>
    );
}
