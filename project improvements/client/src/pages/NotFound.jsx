import { Link } from 'react-router';
import { useTitle } from '../lib/hooks.js';

export default function NotFound() {
    useTitle('Page not found');
    return (
        <section className="card mx-auto max-w-xl text-center">
            <p className="font-serif text-6xl font-bold text-sand">404</p>
            <h1 className="mt-2 text-xl font-bold">This page has wandered off the shelf</h1>
            <p className="mt-2 text-stone">The address may be mistyped, or the page may have moved.</p>
            <div className="mt-5 flex justify-center gap-3">
                <Link className="btn" to="/">Home</Link>
                <Link className="btn btn-secondary" to="/browse">Browse books</Link>
            </div>
        </section>
    );
}
