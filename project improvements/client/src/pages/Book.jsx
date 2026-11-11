// Book information: details, reading list / cart buttons, chapter table and reviews.
// The author and the admin also get delete buttons (book, chapters, reviews); only the author can edit.
import { useState } from 'react';
import { Link, useLocation, useNavigate, useParams } from 'react-router';
import { FREE_CHAPTERS, validateReview } from '@novel/shared';
import { api } from '../lib/api.js';
import { loginPath, useApi, useForm, useMemberAction, useTitle } from '../lib/hooks.js';
import { formatDate, formatViews, money } from '../lib/format.js';
import { useFlash } from '../context/FlashContext.jsx';
import { Avatar, Breadcrumb, CharCount, Cover, EmptyNote, ErrorPanel, Field, FormError, Spinner, Stars, StatusChip } from '../components/ui.jsx';

function StarPicker({ value, onChange, invalid }) {
    const [hover, setHover] = useState(0);
    const shown = hover || Number(value) || 0;
    return (
        <div className="flex gap-1" role="radiogroup" aria-label="Your rating" aria-invalid={invalid || undefined} onMouseLeave={() => setHover(0)}>
            {[1, 2, 3, 4, 5].map((n) => (
                <label key={n} title={`${n} star${n > 1 ? 's' : ''}`} onMouseEnter={() => setHover(n)}
                    className={`cursor-pointer rounded text-3xl leading-none transition has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-sand ${
                        n <= shown ? 'text-amber-500' : 'text-khaki'} hover:scale-110`}>
                    <input type="radio" name="rating" value={n} checked={Number(value) === n} onChange={() => onChange(n)} className="sr-only" />
                    <span aria-hidden="true">★</span><span className="sr-only">{n} star{n > 1 ? 's' : ''}</span>
                </label>
            ))}
        </div>
    );
}

function ReviewForm({ bookId, myReview, onSaved }) {
    const flash = useFlash();
    const form = useForm({ rating: myReview?.rating ?? 0, comment: myReview?.comment ?? '' }, validateReview);
    const save = form.submit(async (values) => {
        const result = await api.post(`/books/${bookId}/reviews`, values);
        flash(result.message);
        onSaved();
    });
    return (
        <form onSubmit={save} noValidate className="card mb-6 space-y-4">
            <h3 className="font-bold">{myReview ? 'Update your review' : 'Write a review'}</h3>
            <FormError message={form.errors._form} />
            <Field error={form.errors.rating}>
                <StarPicker value={form.values.rating} onChange={(n) => form.setValue('rating', n)} invalid={!!form.errors.rating} />
            </Field>
            <Field label="Your review" htmlFor="comment" error={form.errors.comment}>
                <textarea id="comment" rows={4} maxLength={1000} className="input" placeholder="What did you think of this book?" {...form.field('comment')} />
                <CharCount value={form.values.comment} max={1000} min={10} />
            </Field>
            <button type="submit" className="btn" disabled={form.busy}>{myReview ? 'Update review' : 'Post review'}</button>
        </form>
    );
}

function BookActions({ data, reload }) {
    const { book, chapters, viewer } = data;
    const memberAction = useMemberAction();
    const navigate = useNavigate();
    const listRow = viewer.listRow;
    const continueChapter = listRow?.last_chapter > 0 ? listRow.last_chapter : 1;

    const addToList = () => memberAction(() => api.post('/reading-list', { bookId: book.id }), reload);
    const removeFromList = () => memberAction(() => api.delete(`/reading-list/${book.id}?tab=library`), reload);
    const addToCart = () => memberAction(() => api.post('/cart', { bookId: book.id }), reload);
    const deleteBook = () => {
        if (!window.confirm(`Delete "${book.title}" with all its chapters and reviews? This cannot be undone.`)) return;
        memberAction(() => api.delete(`/books/${book.id}`), (result) => navigate(result.wasAuthor ? '/create' : '/browse'));
    };

    let buy;
    if (viewer.isAuthor) buy = <Link className="btn btn-secondary" to={`/create/edit/${book.id}`}>Edit book</Link>;
    else if (viewer.isFree) buy = <span className="btn btn-done">Free to read</span>;
    else if (viewer.owned) buy = <span className="btn btn-done">✓ Owned</span>;
    else if (viewer.inCart) buy = <Link className="btn btn-secondary" to="/cart">In cart &rsaquo; Checkout</Link>;
    else buy = <button type="button" className="btn btn-secondary" onClick={addToCart}>Buy full book &middot; {money(book.price)}</button>;

    return (
        <>
            <div className="mt-5 flex flex-wrap gap-2">
                {chapters.length > 0 && (
                    <Link className="btn" to={`/books/${book.id}/read/${continueChapter}`}>
                        {continueChapter > 1 ? `Continue Ch. ${continueChapter}` : 'Start reading'}
                    </Link>
                )}
                {listRow?.in_library
                    ? <button type="button" className="btn btn-done" onClick={removeFromList} title="Click to remove">✓ In Library</button>
                    : <button type="button" className="btn btn-secondary" onClick={addToList}>+ Add to reading list</button>}
                {viewer.isAuthor && <Link className="btn btn-secondary" to={`/create/${book.id}/chapter`}>+ Add chapter</Link>}
                {buy}
                {/* a book that readers have paid for can't be deleted */}
                {viewer.canManage && viewer.sales === 0 && <button type="button" className="btn btn-danger" onClick={deleteBook}>Delete book</button>}
            </div>
            {!viewer.fullAccess && <p className="mt-3 text-sm text-stone">The first {FREE_CHAPTERS} chapters are free. Buy the book to unlock the rest.</p>}
        </>
    );
}

export default function Book() {
    const { id } = useParams();
    const location = useLocation();
    const memberAction = useMemberAction();
    const { data, error, reload } = useApi(`/books/${id}`);
    useTitle(data?.book.title ?? (error ? 'Book not found' : 'Book'));

    if (error) return <ErrorPanel error={error} />;
    if (!data) return <Spinner />;
    const { book, tags, chapters, reviews, viewer } = data;
    const myId = viewer.myReview?.user_id;

    const deleteChapter = (c) => {
        if (!window.confirm(`Delete Chapter ${c.number} ("${c.title}")? Later chapters will be renumbered. This cannot be undone.`)) return;
        memberAction(() => api.delete(`/books/${book.id}/chapters/${c.number}`), reload);
    };
    const deleteReview = (r) => {
        if (!window.confirm(r.user_id === myId ? 'Delete your review?' : `Delete the review by ${r.username}?`)) return;
        memberAction(() => api.delete(`/books/${book.id}/reviews/${r.user_id}`), reload);
    };

    const stats = [
        ['Rating', <><Stars value={book.avg_rating} /> <small className="text-stone">({book.review_count})</small></>],
        ['Chapters', chapters.length],
        ['Views', formatViews(book.views)],
        ['Price', viewer.isFree ? 'Free' : money(book.price)],
        ['Language', book.language],
        ['Serial no.', book.serial_no],
    ];

    return (
        <div className="space-y-8">
            <Breadcrumb items={[{ to: '/', label: 'Home' }, { to: `/browse?genre=${book.genre_slug}`, label: book.genre }, { label: book.title }]} />

            <section className="card flex flex-col gap-6 md:flex-row">
                <Cover src={book.cover} title={book.title} className="w-48 self-center rounded-xl shadow-lg md:self-start" />
                <div className="flex-1">
                    <h1 className="font-serif text-3xl font-bold">{book.title}</h1>
                    <p className="mt-1 text-stone">by {book.author}</p>
                    <div className="mt-3 flex flex-wrap gap-2"><span className="chip bg-sand/30 text-ink">{book.genre}</span> <StatusChip status={book.status} /></div>
                    <dl className="mt-5 grid grid-cols-2 gap-3 sm:grid-cols-3">
                        {stats.map(([label, value]) => (
                            <div key={label} className="rounded-xl bg-cream/70 px-3 py-2">
                                <dt className="text-xs text-stone">{label}</dt>
                                <dd className="text-sm font-semibold">{value}</dd>
                            </div>
                        ))}
                    </dl>
                    <BookActions data={data} reload={reload} />
                    {tags.length > 0 && <ul className="mt-4 flex flex-wrap gap-1.5">{tags.map((t) => <li key={t} className="chip">{t}</li>)}</ul>}
                </div>
            </section>

            <section>
                <h2 className="section-title">Synopsis</h2>
                <p className="card leading-relaxed whitespace-pre-line">{book.synopsis}</p>
            </section>

            {/* TABLE OF CONTENTS */}
            <section id="chapters">
                <h2 className="section-title">Table of Contents</h2>
                {chapters.length === 0 ? <EmptyNote>No chapters have been published yet.</EmptyNote> : (
                    <div className="card overflow-x-auto p-0 sm:p-0">
                        <table className="data-table">
                            <thead>
                                <tr>
                                    <th scope="col">#</th><th scope="col">Chapter</th><th scope="col">Released</th><th scope="col">Access</th>
                                    {viewer.canManage && <th scope="col">Manage</th>}
                                </tr>
                            </thead>
                            <tbody>
                                {chapters.map((c) => {
                                    const free = c.number <= FREE_CHAPTERS;
                                    const readable = viewer.fullAccess || free;
                                    const read = viewer.listRow && c.number <= viewer.listRow.last_chapter;
                                    return (
                                        <tr key={c.number} className={read ? 'text-stone/70' : ''}>
                                            <td>{c.number}</td>
                                            <td><Link className="link" to={`/books/${book.id}/read/${c.number}`}>{c.title}</Link>{read && <span className="ml-2 text-xs">✓ read</span>}</td>
                                            <td className="whitespace-nowrap">{formatDate(c.created_at)}</td>
                                            <td className="whitespace-nowrap">{readable ? (free && !viewer.fullAccess ? 'Free' : 'Unlocked') : '🔒 Locked'}</td>
                                            {viewer.canManage && (
                                                <td className="space-x-3 whitespace-nowrap">
                                                    {viewer.isAuthor && <Link className="link" to={`/create/${book.id}/chapter/${c.number}`}>Edit</Link>}
                                                    <button type="button" className="cursor-pointer text-sm font-medium text-red-700 hover:underline"
                                                        onClick={() => deleteChapter(c)}>Delete</button>
                                                </td>
                                            )}
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                )}
            </section>

            {/* REVIEWS */}
            <section id="reviews">
                <h2 className="section-title">Reviews ({reviews.length})</h2>
                {viewer.loggedIn && !viewer.isAuthor && (
                    <ReviewForm key={viewer.myReview?.created_at ?? 'new'} bookId={book.id} myReview={viewer.myReview} onSaved={reload} />
                )}
                {!viewer.loggedIn && (
                    <p className="mb-4 text-sm text-stone"><Link className="link" to={loginPath({ ...location, hash: '#reviews' })}>Log in</Link> to write a review.</p>
                )}
                {reviews.length === 0 && <EmptyNote>No reviews yet. Be the first to share your thoughts.</EmptyNote>}
                <ul className="space-y-3">
                    {reviews.map((r) => (
                        <li key={r.user_id} className="card flex gap-4 p-4">
                            <Avatar src={r.photo} />
                            <div className="min-w-0">
                                <p className="flex flex-wrap items-center gap-x-3 text-sm">
                                    <strong>{r.username}</strong> <Stars value={r.rating} showNumber={false} />
                                    <small className="text-stone">{formatDate(r.created_at)}</small>
                                </p>
                                <p className="mt-1 text-sm whitespace-pre-line">{r.comment}</p>
                                {(r.user_id === myId || viewer.isAdmin) && (
                                    <button type="button" className="mt-1 cursor-pointer text-xs font-medium text-red-700 hover:underline" onClick={() => deleteReview(r)}>
                                        {r.user_id === myId ? 'Delete my review' : 'Delete'}
                                    </button>
                                )}
                            </div>
                        </li>
                    ))}
                </ul>
            </section>
        </div>
    );
}
