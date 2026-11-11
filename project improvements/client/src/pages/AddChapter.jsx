// Add the next chapter to one of your books (/create/:id/chapter)
import { Link, useNavigate, useParams } from 'react-router';
import { validateChapter } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useTitle } from '../lib/hooks.js';
import { useFlash } from '../context/FlashContext.jsx';
import { CharCount, ErrorPanel, Field, FormError, Spinner } from '../components/ui.jsx';

export default function AddChapter() {
    useTitle('Add chapter');
    const { id } = useParams();
    const flash = useFlash();
    const navigate = useNavigate();
    const { data: book, error } = useApi(`/books/${id}/edit`);
    const form = useForm({ title: '', content: '' }, validateChapter);

    if (error) return <ErrorPanel error={error}><Link className="btn" to="/create">Back to Create</Link></ErrorPanel>;
    if (!book) return <Spinner />;

    const publish = form.submit(async (values) => {
        flash((await api.post(`/books/${id}/chapters`, values)).message);
        navigate(`/books/${id}`);
    });

    return (
        <section className="mx-auto max-w-3xl">
            <h1 className="section-title">Add Chapter {book.nextChapter} to &ldquo;{book.title}&rdquo;</h1>
            <form onSubmit={publish} noValidate className="card space-y-4">
                <FormError message={form.errors._form} />
                <Field label="Chapter title" htmlFor="chapterTitle" error={form.errors.title}>
                    <input id="chapterTitle" className="input" maxLength={150} {...form.field('title')} />
                </Field>
                <Field label="Chapter text" htmlFor="content" error={form.errors.content} hint="Leave a blank line between paragraphs.">
                    <textarea id="content" rows={18} className="input font-serif leading-relaxed" {...form.field('content')} />
                    <CharCount value={form.values.content} min={100} />
                </Field>
                <div className="flex gap-2">
                    <button type="submit" className="btn" disabled={form.busy}>{form.busy ? 'Publishing...' : 'Publish chapter'}</button>
                    <Link className="btn btn-secondary" to={`/books/${id}`}>Cancel</Link>
                </div>
            </form>
        </section>
    );
}
