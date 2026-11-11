// Home: Trending (top 10 by views today / this week), Recently Updated, Top Genres
import { useRef } from 'react';
import { Link, useSearchParams } from 'react-router';
import { FREE_CHAPTERS, SITE_NAME } from '@novel/shared';
import { useAuth } from '../context/AuthContext.jsx';
import { useApi, useTitle } from '../lib/hooks.js';
import { formatViews, rating, timeAgo } from '../lib/format.js';
import { Cover, EmptyNote, ErrorPanel, PillTabs, Spinner } from '../components/ui.jsx';

function Hero() {
    const { user } = useAuth();
    return (
        <section className="relative overflow-hidden rounded-3xl bg-ink px-6 py-10 text-cream shadow-lg sm:px-10 sm:py-14">
            <div className="absolute -top-16 -right-16 h-64 w-64 rounded-full bg-sand/30 blur-3xl" aria-hidden="true" />
            <div className="absolute -bottom-20 left-1/3 h-56 w-56 rounded-full bg-stone/50 blur-3xl" aria-hidden="true" />
            <div className="relative max-w-2xl">
                <p className="text-sm font-semibold tracking-widest text-sand uppercase">{user ? `Welcome back, ${user.username}` : 'Your online library'}</p>
                <h1 className="mt-2 font-serif text-3xl leading-tight font-bold sm:text-5xl">Stories worth staying up for.</h1>
                <p className="mt-4 text-cream/80 sm:text-lg">
                    Explore {SITE_NAME} by genre, follow what is trending today and read the first {FREE_CHAPTERS} chapters of every book for free.
                </p>
                <div className="mt-6 flex flex-wrap gap-3">
                    <Link to="/browse" className="btn bg-sand text-ink hover:bg-cream">Browse books</Link>
                    {user
                        ? <Link to="/reading-list" className="btn bg-transparent ring-1 ring-cream/50 hover:bg-white/10">My reading list</Link>
                        : <Link to="/login?tab=signup" className="btn bg-transparent ring-1 ring-cream/50 hover:bg-white/10">Create a free account</Link>}
                </div>
            </div>
        </section>
    );
}

function Trending({ books, period }) {
    const row = useRef(null);
    const scroll = (direction) => row.current?.scrollBy({ left: direction * row.current.clientWidth * 0.8, behavior: 'smooth' });
    const arrow = 'absolute top-1/3 z-10 hidden h-10 w-10 cursor-pointer place-items-center rounded-full bg-white/95 text-2xl text-stone shadow-md ring-1 ring-khaki hover:text-ink sm:grid';

    return (
        <section aria-labelledby="trendingTitle">
            <div className="mb-4 flex flex-wrap items-center gap-3">
                <h2 id="trendingTitle" className="section-title mb-0">Trending</h2>
                <PillTabs items={[
                    { to: '/?period=today', label: 'Today', active: period === 'today' },
                    { to: '/?period=week', label: 'This week', active: period === 'week' },
                ]} />
                <Link to="/browse?sort=views" className="link ml-auto text-sm">See all &rsaquo;</Link>
            </div>
            {books.length === 0 ? <EmptyNote>No views recorded for this period yet.</EmptyNote> : (
                <div className="relative">
                    <button type="button" onClick={() => scroll(-1)} className={`${arrow} -left-3`} aria-label="Scroll left">&lsaquo;</button>
                    <ol ref={row} className="flex snap-x snap-mandatory gap-4 overflow-x-auto pb-3 [scrollbar-width:thin]">
                        {books.map((book, i) => (
                            <li key={book.id} className="w-36 shrink-0 snap-start sm:w-40">
                                <Link to={`/books/${book.id}`} className="group block">
                                    <div className="relative overflow-hidden rounded-xl shadow-md ring-1 ring-black/5">
                                        <Cover src={book.cover} title={book.title} className="w-full transition duration-300 group-hover:scale-105" />
                                        <span className={`absolute top-2 left-2 grid h-8 w-8 place-items-center rounded-full text-sm font-bold shadow ${
                                            i < 3 ? 'bg-sand text-ink' : 'bg-ink/85 text-white'}`}>{i + 1}</span>
                                    </div>
                                    <p className="mt-2 line-clamp-2 text-sm font-semibold group-hover:text-stone">{book.title}</p>
                                    <p className="text-xs text-stone">
                                        <span className="text-amber-500">★</span> {rating(book.avg_rating)} &middot; {formatViews(book.period_views)} views
                                    </p>
                                </Link>
                            </li>
                        ))}
                    </ol>
                    <button type="button" onClick={() => scroll(1)} className={`${arrow} -right-3`} aria-label="Scroll right">&rsaquo;</button>
                </div>
            )}
        </section>
    );
}

export default function Home() {
    useTitle('Home');
    const [params] = useSearchParams();
    const period = params.get('period') === 'week' ? 'week' : 'today';
    const { data, error } = useApi(`/home?period=${period}`);

    return (
        <div className="space-y-12">
            <Hero />
            {error && <ErrorPanel error={error} />}
            {!data && !error && <Spinner />}
            {data && (
                <>
                    <Trending books={data.trending} period={period} />

                    <section aria-labelledby="recentTitle">
                        <h2 id="recentTitle" className="section-title">Recently Updated</h2>
                        <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                            {data.recent.map((book) => (
                                <Link key={book.id} to={`/books/${book.id}`}
                                    className="group flex gap-3 rounded-2xl bg-white/80 p-3 shadow-sm ring-1 ring-black/5 transition hover:-translate-y-0.5 hover:shadow-md">
                                    <Cover src={book.cover} title={book.title} className="w-16 shrink-0 rounded-lg sm:w-20" />
                                    <div className="min-w-0 text-sm">
                                        <p className="line-clamp-2 font-semibold group-hover:text-stone">{book.title}</p>
                                        <p className="text-xs text-sand">{book.genre}</p>
                                        <p className="mt-1 line-clamp-2 text-xs text-stone">Ch. {book.number}: {book.chapter_title}</p>
                                        <p className="mt-1 text-xs text-stone/80">{timeAgo(book.seconds_ago)}</p>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    </section>

                    <section aria-labelledby="genreTitle">
                        <h2 id="genreTitle" className="section-title">Top Genres</h2>
                        <ul className="flex flex-wrap gap-2">
                            {data.genres.map((genre) => (
                                <li key={genre.slug}>
                                    <Link to={`/browse?genre=${genre.slug}`}
                                        className="inline-flex items-center gap-2 rounded-full bg-white/80 px-4 py-2 text-sm font-medium text-stone shadow-sm ring-1 ring-khaki/60 transition hover:bg-stone hover:text-white">
                                        {genre.name}
                                        <span className="rounded-full bg-cream px-2 text-xs text-stone">{genre.book_count}</span>
                                    </Link>
                                </li>
                            ))}
                        </ul>
                    </section>
                </>
            )}
        </div>
    );
}
