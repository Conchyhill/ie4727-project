// Account settings: profile photo, username/email, password, order history, delete account.
// Admins also see site statistics and the latest feedback.
import { useState } from 'react';
import { Link, useNavigate } from 'react-router';
import { MAX_IMAGE_BYTES, validateDeleteAccount, validatePasswordChange, validateProfile } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useTitle } from '../lib/hooks.js';
import { avatarUrl, formatDate, formatDateTime, formatDay, formatMonthYear, formatViews, money, rating } from '../lib/format.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useFlash } from '../context/FlashContext.jsx';
import { EmptyNote, ErrorPanel, Field, FormError, Spinner, StatCards, StatusChip } from '../components/ui.jsx';
import PasswordStrength from '../components/PasswordStrength.jsx';

const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];

function PhotoForm({ photo, onSaved }) {
    const flash = useFlash();
    const [file, setFile] = useState(null);
    const [preview, setPreview] = useState(null);
    const [error, setError] = useState('');
    const [busy, setBusy] = useState(false);

    const choose = (event) => {
        const chosen = event.target.files[0] ?? null;
        setError('');
        if (chosen && !IMAGE_TYPES.includes(chosen.type)) setError('Only JPG, PNG, GIF or WEBP images are allowed.');
        else if (chosen && chosen.size > MAX_IMAGE_BYTES) setError('Images must be 2 MB or smaller.');
        setFile(chosen);
        setPreview(chosen ? URL.createObjectURL(chosen) : null);
    };
    const upload = async (event) => {
        event.preventDefault();
        if (!file) return setError('Choose an image to upload.');
        if (error) return undefined;
        setBusy(true);
        try {
            const body = new FormData();
            body.append('photo', file);
            const result = await api.post('/account/photo', body);
            flash(result.message);
            setFile(null);
            setPreview(null);
            event.target.reset();
            onSaved();
        } catch (e) {
            setError(e.errors.photo ?? e.message);
        } finally {
            setBusy(false);
        }
    };
    return (
        <form onSubmit={upload} noValidate className="card space-y-4">
            <h2 className="text-lg font-bold">Profile photo</h2>
            <div className="flex items-center gap-4">
                <img src={preview ?? avatarUrl(photo)} alt="Your profile photo" className="h-20 w-20 rounded-full object-cover ring-2 ring-khaki" />
                <Field label="Choose an image" htmlFor="photo" error={error} hint="JPG, PNG, GIF or WEBP, max 2 MB" className="min-w-0 flex-1">
                    <input id="photo" type="file" accept={IMAGE_TYPES.join(',')} onChange={choose} aria-invalid={error ? true : undefined}
                        className="block w-full text-sm file:mr-3 file:cursor-pointer file:rounded-full file:border-0 file:bg-cream file:px-3 file:py-1.5 file:font-semibold file:text-stone" />
                </Field>
            </div>
            <button type="submit" className="btn" disabled={busy}>Upload photo</button>
        </form>
    );
}

function ProfileForm({ user, onSaved }) {
    const flash = useFlash();
    const form = useForm({ username: user.username, email: user.email }, validateProfile);
    const save = form.submit(async (values) => {
        flash((await api.put('/account/profile', values)).message);
        onSaved();
    });
    return (
        <form onSubmit={save} noValidate className="card space-y-4">
            <h2 className="text-lg font-bold">Account details</h2>
            <FormError message={form.errors._form} />
            <Field label="Username" htmlFor="profileUsername" error={form.errors.username}>
                <input id="profileUsername" className="input" maxLength={20} {...form.field('username')} />
            </Field>
            <Field label="Email" htmlFor="profileEmail" error={form.errors.email}>
                <input id="profileEmail" type="email" className="input" maxLength={100} {...form.field('email')} />
            </Field>
            <button type="submit" className="btn" disabled={form.busy}>Save details</button>
        </form>
    );
}

function PasswordForm() {
    const flash = useFlash();
    const empty = { current: '', password: '', confirm: '' };
    const form = useForm(empty, validatePasswordChange);
    const save = form.submit(async (values) => {
        flash((await api.put('/account/password', values)).message);
        form.reset(empty);
    });
    return (
        <form onSubmit={save} noValidate className="card space-y-4">
            <h2 className="text-lg font-bold">Change password</h2>
            <FormError message={form.errors._form} />
            <Field label="Current password" htmlFor="currentPassword" error={form.errors.current}>
                <input id="currentPassword" type="password" className="input" autoComplete="current-password" {...form.field('current')} />
            </Field>
            <Field label="New password" htmlFor="newPassword" error={form.errors.password}>
                <input id="newPassword" type="password" className="input" autoComplete="new-password" {...form.field('password')} />
                <PasswordStrength password={form.values.password} />
            </Field>
            <Field label="Confirm new password" htmlFor="confirmPassword" error={form.errors.confirm}>
                <input id="confirmPassword" type="password" className="input" autoComplete="new-password" {...form.field('confirm')} />
            </Field>
            <button type="submit" className="btn" disabled={form.busy}>Change password</button>
        </form>
    );
}

function DeleteForm({ isAdmin }) {
    const flash = useFlash();
    const navigate = useNavigate();
    const { refresh } = useAuth();
    const form = useForm({ password: '', confirm: false }, validateDeleteAccount);
    const remove = form.submit(async (values) => {
        if (!window.confirm('Delete your account permanently? This cannot be undone.')) return;
        const result = await api.delete('/account', values);
        await refresh();
        flash(result.message);
        navigate('/');
    });
    return (
        <form onSubmit={remove} noValidate className="card space-y-4 ring-red-200">
            <h2 className="text-lg font-bold text-red-800">Delete account</h2>
            <p className="text-sm text-stone">This permanently removes your reviews, reading list, cart and order history. Books you have written stay on the site.</p>
            {isAdmin ? <p className="text-sm font-medium text-stone">The admin account cannot be deleted.</p> : (
                <>
                    <FormError message={form.errors._form} />
                    <Field label="Enter your password to confirm" htmlFor="deletePassword" error={form.errors.password}>
                        <input id="deletePassword" type="password" className="input" autoComplete="current-password" {...form.field('password')} />
                    </Field>
                    <Field error={form.errors.confirm}>
                        <label className="flex cursor-pointer items-center gap-2 text-sm">
                            <input type="checkbox" className="h-4 w-4 accent-red-700" checked={form.values.confirm}
                                onChange={(e) => form.setValue('confirm', e.target.checked)} aria-invalid={form.errors.confirm ? true : undefined} />
                            I understand this cannot be undone
                        </label>
                    </Field>
                    <button type="submit" className="btn btn-danger" disabled={form.busy}>Delete my account</button>
                </>
            )}
        </form>
    );
}

function Table({ head, children, empty }) {
    return (
        <div className="card overflow-x-auto p-0 sm:p-0">
            <table className="data-table">
                <thead><tr>{head.map((h) => <th key={h} scope="col">{h}</th>)}</tr></thead>
                <tbody>{children}{empty && <tr><td colSpan={head.length} className="text-stone">{empty}</td></tr>}</tbody>
            </table>
        </div>
    );
}

function AdminStats({ admin }) {
    const { totals, bestSellers, dailyOrders, genreStats, feedback } = admin;
    const maxViews = Math.max(1, ...genreStats.map((g) => g.views));
    return (
        <section className="space-y-6">
            <h2 className="section-title mb-0 flex items-center gap-2">Site statistics <span className="chip bg-stone text-white ring-0">Admin</span></h2>
            <StatCards items={[
                [totals.users, 'members'], [totals.books, 'books'], [totals.chapters, 'chapters'], [totals.reviews, 'reviews'],
                [formatViews(totals.views_week), 'views this week'], [money(totals.revenue), 'revenue'],
            ]} />
            <div className="grid gap-6 lg:grid-cols-2">
                <div>
                    <h3 className="mb-2 font-bold">Best sellers</h3>
                    <Table head={['Book', 'Copies', 'Revenue']} empty={bestSellers.length === 0 && 'No sales yet.'}>
                        {bestSellers.map((row) => (
                            <tr key={row.id}><td><Link className="link" to={`/books/${row.id}`}>{row.title}</Link></td><td>{row.copies}</td><td>{money(row.revenue)}</td></tr>
                        ))}
                    </Table>
                </div>
                <div>
                    <h3 className="mb-2 font-bold">Orders in the last 7 days</h3>
                    <Table head={['Day', 'Successful', 'Failed', 'Revenue']} empty={dailyOrders.length === 0 && 'No orders this week.'}>
                        {dailyOrders.map((row) => (
                            <tr key={row.day}><td>{formatDay(row.day)}</td><td>{row.successful}</td><td>{row.failed}</td><td>{money(row.revenue)}</td></tr>
                        ))}
                    </Table>
                </div>
            </div>
            <div>
                <h3 className="mb-2 font-bold">Genres</h3>
                <Table head={['Genre', 'Books', 'Views', 'Avg rating']}>
                    {genreStats.map((row) => (
                        <tr key={row.name}>
                            <td>{row.name}</td><td>{row.books}</td>
                            <td>
                                <div className="flex items-center gap-2">
                                    <span className="w-14 text-right">{formatViews(row.views)}</span>
                                    <span className="h-2 flex-1 rounded-full bg-khaki/30"><span className="block h-2 rounded-full bg-sand" style={{ width: `${(row.views / maxViews) * 100}%` }} /></span>
                                </div>
                            </td>
                            <td>{rating(row.avg_rating)}</td>
                        </tr>
                    ))}
                </Table>
            </div>
            <div>
                <h3 className="mb-2 font-bold">Latest feedback</h3>
                {feedback.length === 0 ? <EmptyNote>No feedback received yet.</EmptyNote> : (
                    <ul className="space-y-3">
                        {feedback.map((row, i) => (
                            <li key={i} className="card p-4">
                                <p className="text-sm"><strong>{row.subject}</strong>{' '}
                                    <small className="text-stone">from {row.name} ({row.email}) &middot; {formatDate(row.created_at)}</small></p>
                                <p className="mt-1 text-sm whitespace-pre-line">{row.message}</p>
                            </li>
                        ))}
                    </ul>
                )}
            </div>
        </section>
    );
}

export default function Account() {
    useTitle('My Account');
    const { refresh } = useAuth();
    const { data, error, reload } = useApi('/account');
    if (error) return <ErrorPanel error={error} />;
    if (!data) return <Spinner />;
    const { user, summary, orders, admin } = data;
    const saved = () => {
        reload();
        refresh();  // the nav bar shows the username
    };

    return (
        <div className="space-y-8">
            <section className="card flex flex-col items-center gap-5 text-center sm:flex-row sm:text-left">
                <img src={avatarUrl(user.photo)} alt="Your profile photo" className="h-28 w-28 rounded-full object-cover ring-4 ring-cream" />
                <div className="flex-1">
                    <h1 className="flex flex-wrap items-center justify-center gap-2 text-2xl font-bold sm:justify-start">
                        {user.username} {user.role === 'admin' && <span className="chip bg-stone text-white ring-0">Admin</span>}
                    </h1>
                    <p className="text-sm text-stone">{user.email} &middot; member since {formatMonthYear(user.created_at)}</p>
                    <ul className="mt-4 flex flex-wrap justify-center gap-2 sm:justify-start">
                        {[[summary.library_size, 'in library'], [summary.books_owned, 'books owned'], [summary.books_written, 'books written'], [summary.reviews_written, 'reviews']]
                            .map(([n, label]) => <li key={label} className="rounded-full bg-cream px-3 py-1 text-sm"><strong>{n}</strong> {label}</li>)}
                    </ul>
                </div>
            </section>

            <div className="grid gap-6 md:grid-cols-2">
                <PhotoForm key={`photo-${user.photo}`} photo={user.photo} onSaved={saved} />
                <ProfileForm key={`profile-${user.username}-${user.email}`} user={user} onSaved={saved} />
                <PasswordForm />
                <DeleteForm isAdmin={user.role === 'admin'} />
            </div>

            <section>
                <h2 className="section-title">Order history</h2>
                {orders.length === 0 ? <EmptyNote>You haven't bought any books yet. <Link className="link" to="/browse">Find something to read</Link>.</EmptyNote> : (
                    <Table head={['Order', 'Date', 'Books', 'Total', 'Payment']}>
                        {orders.map((o) => (
                            <tr key={o.id}>
                                <td>#{o.id}</td><td className="whitespace-nowrap">{formatDateTime(o.created_at)}</td><td>{o.titles}</td>
                                <td>{money(o.total)}</td><td><StatusChip status={o.status} /></td>
                            </tr>
                        ))}
                    </Table>
                )}
            </section>

            {admin && <AdminStats admin={admin} />}
        </div>
    );
}
