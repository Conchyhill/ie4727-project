// Page frame shared by every route: nav bar, main content, footer (header.php + footer.php).
import { Suspense, useEffect, useState } from 'react';
import { Link, NavLink, Outlet, useLocation, useNavigate, useSearchParams } from 'react-router';
import { SITE_NAME } from '@novel/shared';
import { api } from '../lib/api.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useFlash } from '../context/FlashContext.jsx';
import { Spinner } from './ui.jsx';

const navClass = ({ isActive }) =>
    `rounded-full px-3 py-1.5 text-sm font-semibold transition ${isActive ? 'bg-cream text-ink' : 'text-stone hover:text-sand'}`;

function SearchBar({ onDone }) {
    const navigate = useNavigate();
    const location = useLocation();
    const [params] = useSearchParams();
    const current = location.pathname === '/browse' ? params.get('q') ?? '' : '';
    const [q, setQ] = useState(current);
    useEffect(() => setQ(current), [current]);

    const submit = (event) => {
        event.preventDefault();
        if (!q.trim()) return;
        navigate(`/browse?q=${encodeURIComponent(q.trim())}`);
        onDone?.();
    };
    return (
        <form role="search" onSubmit={submit} className="flex w-full max-w-md">
            <input type="search" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search books, authors..."
                aria-label="Search books" required
                className="min-w-0 flex-1 rounded-l-full border border-r-0 border-sand bg-white px-4 py-2 text-sm focus:ring-2 focus:ring-sand/40 focus:outline-none" />
            <button type="submit" className="cursor-pointer rounded-r-full bg-stone px-4 text-sm font-semibold text-white hover:bg-ink">Search</button>
        </form>
    );
}

function NavBar() {
    const { user, cartCount, refresh } = useAuth();
    const flash = useFlash();
    const navigate = useNavigate();
    const location = useLocation();
    const [open, setOpen] = useState(false);
    useEffect(() => setOpen(false), [location.pathname]);  // close the mobile menu after navigating

    const logout = async () => {
        const result = await api.post('/auth/logout');
        await refresh();
        flash(result.message);
        navigate('/');
    };

    // Create, Reading List and Cart are members-only; RequireAuth sends guests to the login page
    const links = (
        <>
            <NavLink to="/reading-list" className={navClass}>Reading List</NavLink>
            <NavLink to="/cart" className={navClass}>
                Cart{cartCount > 0 && (
                    <span className="ml-1.5 inline-grid h-5 min-w-5 place-items-center rounded-full bg-sand px-1 text-xs font-bold text-white"
                        aria-label={`${cartCount} in cart`}>{cartCount}</span>
                )}
            </NavLink>
            {user ? (
                <>
                    <NavLink to="/account" className={navClass}>{user.username}</NavLink>
                    <button type="button" onClick={logout} className="cursor-pointer rounded-full px-3 py-1.5 text-left text-sm font-semibold text-stone hover:text-sand">
                        Logout
                    </button>
                </>
            ) : (
                <NavLink to="/login" className={navClass}>Login</NavLink>
            )}
        </>
    );

    return (
        <header className="sticky top-0 z-40 border-b border-khaki/60 bg-white/90 backdrop-blur">
            <div className="mx-auto flex max-w-6xl items-center gap-4 px-4 py-2 sm:px-6">
                <Link to="/" className="flex shrink-0 items-center gap-2" aria-label={`${SITE_NAME} home`}>
                    <img src="/images/logo.png" alt="" width="44" height="44" className="rounded-lg" />
                    <span className="hidden font-serif text-lg font-bold text-ink xl:inline">{SITE_NAME}</span>
                </Link>
                <nav className="hidden items-center gap-1 md:flex" aria-label="Main">
                    <NavLink to="/browse" className={navClass}>Browse</NavLink>
                    <NavLink to="/create" className={navClass}>Create</NavLink>
                </nav>
                <div className="hidden flex-1 justify-center md:flex"><SearchBar /></div>
                <nav className="hidden items-center gap-1 md:flex" aria-label="Account">{links}</nav>

                {/* mobile */}
                <button type="button" className="ml-auto cursor-pointer rounded-lg p-2 text-stone ring-1 ring-khaki md:hidden"
                    aria-expanded={open} aria-controls="mobileMenu" onClick={() => setOpen(!open)}>
                    <span className="sr-only">Menu</span>
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
                        {open ? <path d="M6 6l12 12M18 6L6 18" /> : <path d="M4 7h16M4 12h16M4 17h16" />}
                    </svg>
                </button>
            </div>
            {open && (
                <div id="mobileMenu" className="space-y-3 border-t border-khaki/50 px-4 py-4 md:hidden">
                    <SearchBar onDone={() => setOpen(false)} />
                    <nav className="flex flex-col gap-1" aria-label="Mobile">
                        <NavLink to="/browse" className={navClass}>Browse</NavLink>
                        <NavLink to="/create" className={navClass}>Create</NavLink>
                        {links}
                    </nav>
                </div>
            )}
        </header>
    );
}

function Footer() {
    const sections = [['about', 'About'], ['feedback', 'Feedback'], ['help', 'Help'], ['terms', 'Terms'], ['privacy', 'Privacy'], ['contact', 'Contact']];
    return (
        <footer className="mt-16 border-t border-khaki/60 bg-white/60">
            <div className="mx-auto flex max-w-6xl flex-col items-center gap-4 px-4 py-8 sm:px-6">
                <ul className="flex flex-wrap justify-center gap-x-6 gap-y-2 text-sm font-medium">
                    {sections.map(([id, label]) => (
                        <li key={id}><Link className="text-stone hover:text-ink" to={`/info#${id}`}>{label}</Link></li>
                    ))}
                </ul>
                <img src="/images/logo.png" alt="" width="44" height="44" className="rounded-lg opacity-90" />
                <small className="text-xs text-stone italic">&copy; {new Date().getFullYear()} {SITE_NAME} &middot; IE4727 project</small>
            </div>
        </footer>
    );
}

// Scroll to the top on a new page, or to #section when the link has one
function ScrollManager() {
    const { pathname, hash } = useLocation();
    useEffect(() => {
        if (!hash) {
            window.scrollTo(0, 0);
            return undefined;
        }
        let tries = 0;
        const timer = setInterval(() => {  // the section may appear after the page's code has loaded
            const target = document.getElementById(decodeURIComponent(hash.slice(1)));
            if (target || ++tries > 20) {
                clearInterval(timer);
                target?.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }, 50);
        return () => clearInterval(timer);
    }, [pathname, hash]);
    return null;
}

export default function Layout() {
    return (
        <div className="flex min-h-screen flex-col">
            <a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2">
                Skip to content
            </a>
            <NavBar />
            <ScrollManager />
            <main id="main" className="mx-auto w-full max-w-6xl flex-1 px-4 py-8 sm:px-6">
                <Suspense fallback={<Spinner />}>
                    <Outlet />
                </Suspense>
            </main>
            <Footer />
        </div>
    );
}
