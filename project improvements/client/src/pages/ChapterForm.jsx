// Add the next chapter to one of your books (/create/:id/chapter)
// or edit / delete an existing one (/create/:id/chapter/:ch).
import { Link, useNavigate, useParams } from 'react-router';
import { validateChapter } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useTitle } from '../lib/hooks.js';
import { useFlash } from '../context/FlashContext.jsx';
import { CharCount, ErrorPanel, Field, FormError, Spinner } from '../components/ui.jsx';

function ChapterEditor({ bookId, bookTitle, number, initial, editing }) {
    const flash = useFlash();
    const navigate = useNavigate();
    const form = useForm(initial, validateChapter);

    const save = form.submit(async (values) => {
        if (editing) {
            flash((await api.put(`/books/${bookId}/chapters/${number}`, values)).message);
            navigate(`/books/${bookId}/read/${number}`);
        } else {
            flash((await api.post(`/books/${bookId}/chapters`, values)).message);
            navigate(`/books/${bookId}`);
        }
    });

    const remove = async () => {
        if (!window.confirm(`Delete Chapter ${number}? Later chapters will be renumbered. This cannot be undone.`)) return;
        try {
            flash((await api.delete(`/books/${bookId}/chapters/${number}`)).message);
            navigate(`/books/${bookId}#chapters`);
        } catch (error) {
            flash(error.message, 'error');
        }
    };

    return (
        <section className="mx-auto max-w-3xl">
            <h1 className="section-title">{editing ? 'Edit' : 'Add'} Chapter {number} {editing ? 'of' : 'to'} &ldquo;{bookTitle}&rdquo;</h1>
            <form onSubmit={save} noValidate className="card space-y-4">
                <FormError message={form.errors._form} />
                <Field label="Chapter title" htmlFor="chapterTitle" error={form.errors.title}>
                    <input id="chapterTitle" className="input" maxLength={150} {...form.field('title')} />
                </Field>
                <Field label="Chapter text" htmlFor="content" error={form.errors.content} hint="Leave a blank line between paragraphs.">
                    <textarea id="content" rows={18} className="input font-serif leading-relaxed" {...form.field('content')} />
                    <CharCount value={form.values.content} min={100} />
                </Field>
                <div className="flex gap-2">
                    <button type="submit" className="btn" disabled={form.busy}>
                        {form.busy ? 'Saving...' : editing ? 'Save changes' : 'Publish chapter'}
                    </button>
                    <Link className="btn btn-secondary" to={`/books/${bookId}#chapters`}>Cancel</Link>
                </div>
            </form>
            {editing && (
                <div className="mt-6 rounded-2xl bg-red-50 p-5 ring-1 ring-red-200">
                    <p className="mb-3 text-sm text-red-900">Deleting this chapter moves every later chapter up by one number.</p>
                    <button type="button" className="btn btn-danger" onClick={remove}>Delete chapter</button>
                </div>
            )}
        </section>
    );
}

export default function ChapterForm() {
    const { id, ch } = useParams();
    const editing = ch !== undefined;
    useTitle(editing ? 'Edit chapter' : 'Add chapter');
    // editing: the chapter's current text; adding: the book (for its title and the next number)
    const { data, error } = useApi(editing ? `/books/${id}/chapters/${ch}/edit` : `/books/${id}/edit`);

    if (error) return <ErrorPanel error={error}><Link className="btn" to={editing ? `/books/${id}` : '/create'}>Go back</Link></ErrorPanel>;
    if (!data) return <Spinner />;

    return editing
        ? <ChapterEditor key={`${id}-${ch}`} editing bookId={data.bookId} bookTitle={data.bookTitle} number={data.number}
            initial={{ title: data.title, content: data.content }} />
        : <ChapterEditor key={id} bookId={data.id} bookTitle={data.title} number={data.nextChapter} initial={{ title: '', content: '' }} />;
}
