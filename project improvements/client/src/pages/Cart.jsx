// Shopping cart and checkout. Payment is simulated (a third-party gateway is assumed):
// card numbers starting with 4 are approved, any other valid number is declined.
import { Link, useNavigate, useSearchParams } from 'react-router';
import { validateCheckout } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useMemberAction, useTitle } from '../lib/hooks.js';
import { formatDateTime, money, plural } from '../lib/format.js';
import { useAuth } from '../context/AuthContext.jsx';
import { Cover, EmptyNote, ErrorPanel, Field, FormError, Spinner } from '../components/ui.jsx';

// "4242424242424242" -> "4242 4242 4242 4242" as the user types
const formatCard = (value) => value.replace(/[^\d]/g, '').slice(0, 19).replace(/(\d{4})(?=\d)/g, '$1 ');
// "1228" -> "12/28"
const formatExpiry = (value) => {
    const digits = value.replace(/[^\d]/g, '').slice(0, 4);
    return digits.length > 2 ? `${digits.slice(0, 2)}/${digits.slice(2)}` : digits;
};

function ResultPanel({ order }) {
    if (order.status === 'success') {
        return (
            <section className="card mx-auto max-w-xl text-center ring-emerald-200">
                <p className="mx-auto grid h-16 w-16 place-items-center rounded-full bg-emerald-100 text-3xl text-emerald-700" aria-hidden="true">✓</p>
                <h1 className="mt-3 text-2xl font-bold">Payment successful</h1>
                <p className="mt-1 text-sm text-stone">Order #{order.id} &middot; {money(order.total)} &middot; {formatDateTime(order.created_at)}</p>
                <p className="mt-4">These books are now unlocked and in your library:</p>
                <ul className="mt-2 space-y-1">
                    {order.books.map((b) => <li key={b.id}><Link className="link" to={`/books/${b.id}/read/1`}>{b.title}</Link></li>)}
                </ul>
                <div className="mt-6 flex justify-center gap-2">
                    <Link className="btn" to="/reading-list">Go to my library</Link>
                    <Link className="btn btn-secondary" to="/">Back to Home</Link>
                </div>
            </section>
        );
    }
    return (
        <section className="mb-8 rounded-2xl bg-red-50 p-6 text-center ring-1 ring-red-200" role="alert">
            <p className="mx-auto grid h-14 w-14 place-items-center rounded-full bg-red-100 text-2xl text-red-700" aria-hidden="true">✗</p>
            <h1 className="mt-3 text-xl font-bold text-red-900">Payment failed</h1>
            <p className="mt-1 text-sm text-red-900/80">
                Your payment of {money(order.total)} was declined by the payment provider (order #{order.id}).
                Nothing was charged and your cart has been kept. Please try another card.
            </p>
        </section>
    );
}

function CheckoutForm({ total }) {
    const navigate = useNavigate();
    const { refresh } = useAuth();
    const form = useForm({ cardName: '', cardNumber: '', expiry: '', cvv: '' }, validateCheckout);
    const pay = form.submit(async (values) => {
        const result = await api.post('/cart/checkout', values);
        await refresh();
        navigate(`/cart?order=${result.orderId}`);
    });
    return (
        <form onSubmit={pay} noValidate className="card space-y-4">
            <h2 className="text-lg font-bold">Checkout</h2>
            <FormError message={form.errors._form} />
            <Field label="Name on card" htmlFor="cardName" error={form.errors.cardName}>
                <input id="cardName" className="input" maxLength={60} autoComplete="cc-name" {...form.field('cardName')} />
            </Field>
            <Field label="Card number" htmlFor="cardNumber" error={form.errors.cardNumber}>
                <input id="cardNumber" className="input font-mono tracking-wider" inputMode="numeric" maxLength={23} placeholder="4242 4242 4242 4242"
                    autoComplete="cc-number" {...form.field('cardNumber')} onChange={(e) => form.setValue('cardNumber', formatCard(e.target.value))} />
            </Field>
            <div className="grid grid-cols-2 gap-4">
                <Field label="Expiry (MM/YY)" htmlFor="expiry" error={form.errors.expiry}>
                    <input id="expiry" className="input" inputMode="numeric" maxLength={5} placeholder="MM/YY" autoComplete="cc-exp"
                        {...form.field('expiry')} onChange={(e) => form.setValue('expiry', formatExpiry(e.target.value))} />
                </Field>
                <Field label="Security code" htmlFor="cvv" error={form.errors.cvv}>
                    <input id="cvv" type="password" className="input" inputMode="numeric" maxLength={4} autoComplete="cc-csc" {...form.field('cvv')} />
                </Field>
            </div>
            <p className="rounded-lg bg-cream/80 px-3 py-2 text-xs text-stone">
                Demo payment: card numbers starting with 4 are approved (e.g. 4242 4242 4242 4242); other valid numbers are declined
                (e.g. 5555 5555 5555 4444). Card details are never stored.
            </p>
            <button type="submit" className="btn w-full" disabled={form.busy}>{form.busy ? 'Processing...' : `Pay ${money(total)}`}</button>
        </form>
    );
}

export default function Cart() {
    useTitle('Shopping Cart');
    const [params] = useSearchParams();
    const orderId = Number(params.get('order')) || null;
    const { data: order } = useApi(orderId ? `/orders/${orderId}` : null);
    const { data, error, reload } = useApi('/cart');
    const memberAction = useMemberAction();

    const remove = (item) => {
        if (window.confirm(`Remove "${item.title}" from your cart?`)) memberAction(() => api.delete(`/cart/${item.id}`), reload);
    };

    if (order?.status === 'success') return <ResultPanel order={order} />;
    if (error) return <ErrorPanel error={error} />;
    if (!data) return <Spinner />;

    return (
        <div>
            {order && <ResultPanel order={order} />}
            <h1 className="section-title">Shopping Cart</h1>
            {data.items.length === 0 ? (
                <EmptyNote>Your cart is empty. <Link className="link" to="/browse">Browse books</Link> and use &ldquo;Buy full book&rdquo; to add one.</EmptyNote>
            ) : (
                <div className="grid items-start gap-6 lg:grid-cols-[1fr_360px]">
                    <div className="card overflow-x-auto p-0 sm:p-0">
                        <table className="data-table">
                            <thead>
                                <tr><th scope="col">Book</th><th scope="col">Author</th><th scope="col">Chapters</th><th scope="col">Price</th><th scope="col"><span className="sr-only">Remove</span></th></tr>
                            </thead>
                            <tbody>
                                {data.items.map((item) => (
                                    <tr key={item.id}>
                                        <td>
                                            <div className="flex items-center gap-3">
                                                <Cover src={item.cover} title={item.title} className="w-11 rounded" />
                                                <Link className="link" to={`/books/${item.id}`}>{item.title}</Link>
                                            </div>
                                        </td>
                                        <td>{item.author}</td><td>{item.chapters}</td><td>{money(item.price)}</td>
                                        <td><button type="button" className="cursor-pointer text-xs text-stone hover:text-red-700 hover:underline" onClick={() => remove(item)}>Remove</button></td>
                                    </tr>
                                ))}
                            </tbody>
                            <tfoot>
                                <tr className="font-semibold">
                                    <th scope="row" colSpan={3} className="bg-transparent text-ink">Total ({plural(data.items.length, 'book')})</th>
                                    <td colSpan={2} className="text-lg">{money(data.total)}</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <CheckoutForm total={data.total} />
                </div>
            )}
        </div>
    );
}
