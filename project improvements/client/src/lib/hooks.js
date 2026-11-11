import { useCallback, useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router';
import { SITE_NAME } from '@novel/shared';
import { api } from './api.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useFlash } from '../context/FlashContext.jsx';

// Load JSON from the API whenever `url` changes. Keeps the old data on screen while reloading.
// Pass null to skip loading.
export function useApi(url) {
    const [state, setState] = useState({ data: null, error: null, loading: url !== null });
    const [version, setVersion] = useState(0);

    useEffect(() => {
        if (url === null) return undefined;
        let cancelled = false;
        setState((s) => ({ ...s, loading: true }));
        api.get(url).then(
            (data) => !cancelled && setState({ data, error: null, loading: false }),
            (error) => !cancelled && setState({ data: null, error, loading: false }),
        );
        return () => {
            cancelled = true;  // ignore a slow reply after the user has moved on
        };
    }, [url, version]);

    const reload = useCallback(() => setVersion((v) => v + 1), []);
    return { ...state, reload };
}

// <title> for each page, like $pageTitle in the PHP header
export function useTitle(title) {
    useEffect(() => {
        document.title = title ? `${title} | ${SITE_NAME}` : SITE_NAME;
    }, [title]);
}

// Login page link that brings the user back here afterwards
export function loginPath(location, tab) {
    const params = new URLSearchParams();
    if (tab) params.set('tab', tab);
    params.set('redirect', location.pathname + location.search + location.hash);
    return '/login?' + params.toString();
}

// Only allow redirects to our own pages ("/books/1"), never "//evil.com" or "https://..."
export function safeRedirect(target, fallback = '/') {
    return typeof target === 'string' && /^\/(?![/\\])/.test(target) ? target : fallback;
}

// Run a members-only action (add to list, add to cart, ...). Guests go to the login page;
// the server's message is shown as a toast and the nav bar's cart count is refreshed.
export function useMemberAction() {
    const { user, refresh } = useAuth();
    const flash = useFlash();
    const navigate = useNavigate();
    const location = useLocation();

    return useCallback(async (action, onDone) => {
        if (!user) {
            flash('Please log in to continue.', 'error');
            navigate(loginPath(location));
            return;
        }
        try {
            const result = await action();
            if (result?.message) flash(result.message);
            await refresh();
            onDone?.(result);
        } catch (error) {
            flash(error.message, 'error');
            if (error.status === 401) {
                await refresh();
                navigate(loginPath(location));
            }
        }
    }, [user, refresh, flash, navigate, location]);
}

// Form state + validation with the shared rules.
// Errors show after the first submit attempt, then update as the user types.
export function useForm(initialValues, validate) {
    const [values, setValues] = useState(initialValues);
    const [errors, setErrors] = useState({});
    const [submitted, setSubmitted] = useState(false);
    const [busy, setBusy] = useState(false);

    const setValue = useCallback((name, value) => {
        setValues((current) => {
            const next = { ...current, [name]: value };
            if (submitted) setErrors(validate(next));
            return next;
        });
    }, [submitted, validate]);

    // <input {...field('email')} />
    const field = (name) => ({
        name,
        value: values[name] ?? '',
        'aria-invalid': errors[name] ? true : undefined,
        onChange: (event) => setValue(name, event.target.type === 'checkbox' ? event.target.checked : event.target.value),
    });

    // Validate, then run send(values). Server field errors are shown next to the fields.
    const submit = (send) => async (event) => {
        event?.preventDefault();
        setSubmitted(true);
        const found = validate(values);
        setErrors(found);
        if (Object.keys(found).length > 0) {
            // move focus to the first field with a problem
            requestAnimationFrame(() => document.querySelector('[aria-invalid="true"]')?.focus());
            return;
        }
        setBusy(true);
        try {
            await send(values);
        } catch (error) {
            setErrors({ ...error.errors, _form: Object.keys(error.errors ?? {}).length ? '' : error.message });
        } finally {
            setBusy(false);
        }
    };

    const reset = (next = initialValues) => {
        setValues(next);
        setErrors({});
        setSubmitted(false);
    };

    return { values, setValue, setValues, errors, setErrors, field, submit, busy, reset };
}
