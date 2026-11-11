// Create: publish a new book (/create) or edit one of your books (/create/edit/:id), plus the "My books" table.
// Books nobody has bought yet can be deleted from the table or from under the edit form.
import { useMemo, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router';
import { LANGUAGES, MAX_IMAGE_BYTES, MAX_TAGS, validateBook } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useMemberAction, useTitle } from '../lib/hooks.js';
import { coverUrl, formatViews, rating } from '../lib/format.js';
import { useFlash } from '../context/FlashContext.jsx';
import { CharCount, EmptyNote, ErrorPanel, Field, FormError, Spinner, StatusChip } from '../components/ui.jsx';

const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
const NEW_BOOK = { title: '', genreId: '', language: 'English', status: 'ongoing', price: '2.99', synopsis: '', tags: [], cover: null };

// Ask, then delete the book; onDone runs after it is gone
function useDeleteBook() {
    const memberAction = useMemberAction();
    return (book, onDone) => {
        if (!window.confirm(`Delete "${book.title}" with all its chapters and reviews? This cannot be undone.`)) return;
        memberAction(() => api.delete(`/books/${book.id}`), onDone);
    };
}

function DeleteBookBox({ book }) {
    const navigate = useNavigate();
    const deleteBook = useDeleteBook();
    return (
        <div className="mt-6 rounded-2xl bg-red-50 p-5 text-sm text-red-900 ring-1 ring-red-200">
            {book.sales === 0 ? (
                <>
                    <p className="mb-3">Deleting this book also removes its chapters, reviews and reading-list entries.</p>
                    <button type="button" className="btn btn-danger" onClick={() => deleteBook(book, () => navigate('/create'))}>Delete book</button>
                </>
            ) : (
                <p>This book has been bought {book.sales} time{book.sales > 1 ? 's' : ''}, so it cannot be deleted. You can still edit it or mark it as completed.</p>
            )}
        </div>
    );
}

function BookForm({ initial, meta, editId }) {
    const flash = useFlash();
    const navigate = useNavigate();
    const ids = useMemo(() => ({ genreIds: meta.genres.map((g) => g.id), tagIds: meta.tags.map((t) => t.id) }), [meta]);
    const validate = useMemo(() => (values) => validateBook(values, ids), [ids]);
    const form = useForm(initial, validate);
    const [cover, setCover] = useState({ file: null, preview: null, error: '' });
    const { values } = form;

    const chooseCover = (event) => {
        const file = event.target.files[0] ?? null;
        let error = '';
        if (file && !IMAGE_TYPES.includes(file.type)) error = 'Only JPG, PNG, GIF or WEBP images are allowed.';
        else if (file && file.size > MAX_IMAGE_BYTES) error = 'Images must be 2 MB or smaller.';
        setCover({ file: error ? null : file, preview: file && !error ? URL.createObjectURL(file) : null, error });
    };

    const toggleTag = (id) => form.setValue('tags', values.tags.includes(id) ? values.tags.filter((t) => t !== id) : [...values.tags, id]);

    const save = form.submit(async (v) => {
        if (cover.error) return;
        const body = new FormData();
        for (const key of ['title', 'genreId', 'language', 'status', 'price', 'synopsis']) body.append(key, v[key]);
        v.tags.forEach((id) => body.append('tags', id));
        if (cover.file) body.append('cover', cover.file);
        const result = editId ? await api.put(`/books/${editId}`, body) : await api.post('/books', body);
        flash(result.message);
        navigate(editId ? `/books/${editId}` : `/create/${result.id}/chapter`);
    });
    const coverError = cover.error || form.errors.cover;

    return (
        <form onSubmit={save} noValidate className="card grid gap-6 md:grid-cols-[1fr_220px]">
            <div className="space-y-4">
                <FormError message={form.errors._form} />
                <Field label="Title" htmlFor="title" error={form.errors.title}>
                    <input id="title" className="input" maxLength={150} {...form.field('title')} />
                </Field>
                <div className="grid gap-4 sm:grid-cols-3">
                    <Field label="Genre" htmlFor="genreId" error={form.errors.genreId}>
                        <select id="genreId" className="input" {...form.field('genreId')}>
                            <option value="">Choose a genre</option>
                            {meta.genres.map((g) => <option key={g.id} value={g.id}>{g.name}</option>)}
                        </select>
                    </Field>
                    <Field label="Language" htmlFor="language" error={form.errors.language}>
                        <select id="language" className="input" {...form.field('language')}>
                            {LANGUAGES.map((l) => <option key={l}>{l}</option>)}
                        </select>
                    </Field>
                    <Field label="Price (SGD)" htmlFor="price" error={form.errors.price} hint="0 makes the whole book free">
                        <input id="price" type="number" min="0" max="99.99" step="0.01" className="input" {...form.field('price')} />
                    </Field>
                </div>
                <fieldset>
                    <legend className="label">Status</legend>
                    <div className="flex gap-5">
                        {['ongoing', 'completed'].map((s) => (
                            <label key={s} className="flex cursor-pointer items-center gap-2 text-sm capitalize">
                                <input type="radio" name="status" className="h-4 w-4 accent-stone" checked={values.status === s} onChange={() => form.setValue('status', s)} /> {s}
                            </label>
                        ))}
                    </div>
                </fieldset>
                <fieldset>
                    <legend className="label">Tags <span className="font-normal text-stone">({values.tags.length}/{MAX_TAGS})</span></legend>
                    <div className="flex flex-wrap gap-2">
                        {meta.tags.map((tag) => {
                            const on = values.tags.includes(tag.id);
                            const full = !on && values.tags.length >= MAX_TAGS;
                            return (
                                <label key={tag.id} className={`cursor-pointer rounded-full px-3 py-1 text-xs font-medium ring-1 transition has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-sand ${
                                    on ? 'bg-stone text-white ring-stone' : full ? 'cursor-not-allowed text-stone/40 ring-khaki/40' : 'bg-white text-stone ring-khaki hover:bg-cream'}`}>
                                    <input type="checkbox" className="sr-only" checked={on} disabled={full} onChange={() => toggleTag(tag.id)} />
                                    {on && '✓ '}{tag.name}
                                </label>
                            );
                        })}
                    </div>
                    {form.errors.tags && <p className="mt-1 text-xs font-medium text-red-700">{form.errors.tags}</p>}
                </fieldset>
                <Field label="Synopsis" htmlFor="synopsis" error={form.errors.synopsis}>
                    <textarea id="synopsis" rows={6} maxLength={2000} className="input" {...form.field('synopsis')} />
                    <CharCount value={values.synopsis} max={2000} min={30} />
                </Field>
            </div>

            <div>
                <Field label="Cover image" htmlFor="cover" error={coverError} hint="3:4, max 2 MB, optional">
                    <img src={cover.preview ?? coverUrl(initial.cover)} alt="Cover preview" className="mb-3 aspect-[3/4] w-full rounded-xl object-cover shadow-md ring-1 ring-khaki" />
                    <input id="cover" type="file" accept={IMAGE_TYPES.join(',')} onChange={chooseCover} aria-invalid={coverError ? true : undefined}
                        className="block w-full text-xs file:mr-2 file:cursor-pointer file:rounded-full file:border-0 file:bg-cream file:px-3 file:py-1.5 file:font-semibold file:text-stone" />
                </Field>
            </div>

            <div className="flex gap-2 md:col-span-2">
                <button type="submit" className="btn" disabled={form.busy}>{form.busy ? 'Saving...' : editId ? 'Save changes' : 'Create book'}</button>
                {editId && <Link className="btn btn-secondary" to={`/books/${editId}`}>Cancel</Link>}
            </div>
        </form>
    );
}

function MyBooks({ editId }) {
    const navigate = useNavigate();
    const deleteBook = useDeleteBook();
    const { data, reload } = useApi('/my/books');
    if (!data) return <Spinner />;
    if (data.length === 0) return <EmptyNote>You haven't published any books yet. Use the form above to create your first one.</EmptyNote>;
    return (
        <div className="card overflow-x-auto p-0 sm:p-0">
            <table className="data-table">
                <thead>
                    <tr>{['Title', 'Serial no.', 'Genre', 'Chapters', 'Views', 'Rating', 'Status', 'Actions'].map((h) => <th key={h} scope="col">{h}</th>)}</tr>
                </thead>
                <tbody>
                    {data.map((b) => (
                        <tr key={b.id}>
                            <td><Link className="link" to={`/books/${b.id}`}>{b.title}</Link></td>
                            <td className="whitespace-nowrap">{b.serial_no}</td><td>{b.genre}</td><td>{b.chapters}</td>
                            <td>{formatViews(b.views)}</td><td>{rating(b.avg_rating)}</td><td><StatusChip status={b.status} /></td>
                            <td className="space-x-3 whitespace-nowrap">
                                <Link className="link" to={`/create/edit/${b.id}`}>Edit</Link>
                                <Link className="link" to={`/create/${b.id}/chapter`}>+ Chapter</Link>
                                {b.sales === 0 ? (
                                    <button type="button" className="cursor-pointer text-sm font-medium text-red-700 hover:underline"
                                        onClick={() => deleteBook(b, () => (b.id === editId ? navigate('/create') : reload()))}>Delete</button>
                                ) : <span className="text-xs text-stone" title="Books that readers have bought cannot be deleted">Sold {b.sales}&times;</span>}
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default function Create() {
    const { id } = useParams();
    const editId = id ? Number(id) : null;
    useTitle(editId ? 'Edit book' : 'Create');
    const { data: meta, error: metaError } = useApi('/meta');
    const { data: book, error: bookError } = useApi(editId ? `/books/${editId}/edit` : null);

    const error = metaError ?? bookError;
    const ready = meta && (!editId || book);
    return (
        <div className="space-y-10">
            <section>
                <h1 className="section-title">{editId ? <>Edit &ldquo;{book?.title ?? '...'}&rdquo;</> : 'Publish a new book'}</h1>
                {error && <ErrorPanel error={error}><Link className="btn" to="/create">Back to Create</Link></ErrorPanel>}
                {!error && !ready && <Spinner />}
                {!error && ready && (
                    <BookForm key={editId ?? 'new'} meta={meta} editId={editId}
                        initial={editId ? { ...book, genreId: String(book.genreId) } : NEW_BOOK} />
                )}
                {!error && editId && book && <DeleteBookBox book={book} />}
            </section>
            <section>
                <h2 className="section-title">My books</h2>
                <MyBooks key={editId ?? 'new'} editId={editId} />
            </section>
        </div>
    );
}
