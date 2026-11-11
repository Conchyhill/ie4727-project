// Sign in and Sign up on one page (two tabs).
import { useEffect, useRef } from 'react';
import { Link, Navigate, useLocation, useSearchParams } from 'react-router';
import { validateLogin, validateSignup } from '@novel/shared';
import { api } from '../lib/api.js';
import { safeRedirect, useForm, useTitle } from '../lib/hooks.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useFlash } from '../context/FlashContext.jsx';
import { Field, FormError } from '../components/ui.jsx';
import PasswordStrength from '../components/PasswordStrength.jsx';

function SignInForm({ onDone }) {
    const { rememberedUsername } = useAuth();
    const form = useForm({ identifier: rememberedUsername, password: '', remember: rememberedUsername !== '' }, validateLogin);
    const { values, setValues } = form;

    // the remembered username may arrive after the page has opened
    useEffect(() => {
        if (rememberedUsername && !values.identifier) setValues((v) => ({ ...v, identifier: rememberedUsername, remember: true }));
    }, [rememberedUsername]);

    return (
        <form onSubmit={form.submit(async (v) => onDone(await api.post('/auth/login', v)))} noValidate className="space-y-4">
            <FormError message={form.errors._form} />
            <Field label="Username or email" htmlFor="identifier" error={form.errors.identifier}>
                <input id="identifier" className="input" maxLength={100} autoComplete="username" autoFocus {...form.field('identifier')} />
            </Field>
            <Field label="Password" htmlFor="loginPassword" error={form.errors.password}>
                <input id="loginPassword" type="password" className="input" autoComplete="current-password" {...form.field('password')} />
            </Field>
            <label className="flex cursor-pointer items-center gap-2 text-sm">
                <input type="checkbox" className="h-4 w-4 accent-stone" checked={values.remember} onChange={(e) => form.setValue('remember', e.target.checked)} />
                Remember my username
            </label>
            <button type="submit" className="btn w-full" disabled={form.busy}>{form.busy ? 'Signing in...' : 'Sign in'}</button>
        </form>
    );
}

function SignUpForm({ onDone }) {
    const form = useForm({ username: '', email: '', password: '', confirm: '' }, validateSignup);
    return (
        <form onSubmit={form.submit(async (v) => onDone(await api.post('/auth/signup', v)))} noValidate className="space-y-4">
            <FormError message={form.errors._form} />
            <Field label="Username" htmlFor="username" error={form.errors.username} hint="3-20 letters, numbers or underscores">
                <input id="username" className="input" maxLength={20} autoComplete="username" autoFocus {...form.field('username')} />
            </Field>
            <Field label="Email" htmlFor="email" error={form.errors.email}>
                <input id="email" type="email" className="input" maxLength={100} autoComplete="email" {...form.field('email')} />
            </Field>
            <Field label="Password" htmlFor="password" error={form.errors.password}>
                <input id="password" type="password" className="input" autoComplete="new-password" {...form.field('password')} />
                <PasswordStrength password={form.values.password} />
            </Field>
            <Field label="Confirm password" htmlFor="confirm" error={form.errors.confirm}>
                <input id="confirm" type="password" className="input" autoComplete="new-password" {...form.field('confirm')} />
            </Field>
            <button type="submit" className="btn w-full" disabled={form.busy}>{form.busy ? 'Creating account...' : 'Create account'}</button>
        </form>
    );
}

export default function Login() {
    const [params] = useSearchParams();
    const location = useLocation();
    const { user, ready, refresh } = useAuth();
    const flash = useFlash();
    const justSignedIn = useRef(false);
    const tab = params.get('tab') === 'signup' ? 'signup' : 'login';
    const redirect = params.get('redirect') ?? '';
    useTitle(tab === 'signup' ? 'Sign up' : 'Sign in');

    // Already logged in (or just did): go back to where the user came from
    if (ready && user) return <Navigate to={safeRedirect(redirect, justSignedIn.current ? '/' : '/account')} replace />;

    const onDone = async (result) => {
        justSignedIn.current = true;
        flash(result.message);
        await refresh();
    };
    const tabLink = (name) => `/login?tab=${name}${redirect ? `&redirect=${encodeURIComponent(redirect)}` : ''}`;
    const tabClass = (active) =>
        `flex-1 rounded-full py-2 text-center text-sm font-semibold transition ${active ? 'bg-white text-ink shadow-sm' : 'text-stone hover:text-ink'}`;

    return (
        <section className="mx-auto max-w-md">
            {location.state?.notice && (
                <p className="mb-4 rounded-lg bg-amber-50 px-3 py-2 text-sm font-medium text-amber-900 ring-1 ring-amber-200" role="status">{location.state.notice}</p>
            )}
            <div className="card">
                <div className="mb-6 flex rounded-full bg-cream p-1" role="tablist">
                    <Link to={tabLink('login')} replace role="tab" aria-selected={tab === 'login'} className={tabClass(tab === 'login')}>Sign in</Link>
                    <Link to={tabLink('signup')} replace role="tab" aria-selected={tab === 'signup'} className={tabClass(tab === 'signup')}>Sign up</Link>
                </div>
                <div role="tabpanel">
                    {tab === 'login' ? <SignInForm onDone={onDone} /> : <SignUpForm onDone={onDone} />}
                </div>
                <p className="mt-5 text-center text-sm text-stone">
                    {tab === 'login'
                        ? <>New here? <Link className="link" to={tabLink('signup')} replace>Create an account</Link>.</>
                        : <>Already a member? <Link className="link" to={tabLink('login')} replace>Sign in</Link>.</>}
                </p>
            </div>
            <p className="mt-4 text-center text-xs text-stone">Demo logins: alice / password123, admin / admin123</p>
        </section>
    );
}
