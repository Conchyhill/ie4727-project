// Member's reading list: Library tab (saved books) and History tab (recently read), with progress.
import { Link, useSearchParams } from 'react-router';
import { api } from '../lib/api.js';
import { useApi, useMemberAction, useTitle } from '../lib/hooks.js';
import { timeAgo } from '../lib/format.js';
import { Cover, EmptyNote, ErrorPanel, PillTabs, Spinner } from '../components/ui.jsx';

export default function ReadingList() {
    useTitle('Reading List');
    const [params] = useSearchParams();
    const tab = params.get('tab') === 'history' ? 'history' : 'library';
    const { data, error, reload } = useApi(`/reading-list?tab=${tab}`);
    const memberAction = useMemberAction();

    const remove = (book) => memberAction(() => api.delete(`/reading-list/${book.id}?tab=${tab}`), reload);

    return (
        <section>
            <div className="mb-6 flex flex-wrap items-center gap-3">
                <h1 className="section-title mb-0">Reading List</h1>
                <PillTabs items={[
                    { to: '/reading-list?tab=library', label: `Library (${data?.counts.library ?? 0})`, active: tab === 'library' },
                    { to: '/reading-list?tab=history', label: `History (${data?.counts.history ?? 0})`, active: tab === 'history' },
                ]} />
            </div>
            {error && <ErrorPanel error={error} />}
            {!data && !error && <Spinner />}
            {data && data.tab === tab && (
                <>
                    {data.books.length === 0 && (
                        <EmptyNote>
                            {tab === 'library' ? 'Your library is empty. Use "+ Add" on any book to save it here.' : "You haven't read any chapters yet."}{' '}
                            <Link className="link" to="/browse">Browse books</Link>.
                        </EmptyNote>
                    )}
                    <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-5">
                        {data.books.map((book) => {
                            const total = Math.max(1, book.total_chapters);
                            const read = Math.min(book.last_chapter, total);
                            const next = Math.min(read + 1, total);
                            const finished = read >= total;
                            return (
                                <div key={book.id} className="card flex flex-col p-3 sm:p-3">
                                    <Link to={`/books/${book.id}`} className="group block overflow-hidden rounded-lg">
                                        <Cover src={book.cover} title={book.title} className="w-full transition group-hover:scale-105" />
                                    </Link>
                                    <Link to={`/books/${book.id}`} className="mt-2 line-clamp-2 text-sm font-semibold hover:text-stone">{book.title}</Link>
                                    <span className="text-xs text-sand">{book.genre}</span>
                                    <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-khaki/40" title={`${read} of ${book.total_chapters} chapters read`}>
                                        <div className="h-full rounded-full bg-stone" style={{ width: `${Math.round((read / total) * 100)}%` }} />
                                    </div>
                                    <span className="mt-1 text-xs text-stone">
                                        {read}/{book.total_chapters}{tab === 'history' && <> &middot; {timeAgo(book.seconds_ago)}</>}
                                    </span>
                                    <div className="mt-auto flex items-center justify-between gap-2 pt-3">
                                        <Link className="btn btn-sm" to={`/books/${book.id}/read/${read === 0 || finished ? 1 : next}`}>
                                            {read === 0 ? 'Start' : finished ? 'Read again' : `Ch. ${next}`}
                                        </Link>
                                        <button type="button" className="cursor-pointer text-xs text-stone underline-offset-2 hover:text-red-700 hover:underline"
                                            onClick={() => remove(book)}>Remove</button>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </>
            )}
        </section>
    );
}
