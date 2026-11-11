// Members-only pages: send guests to the login page, then back here afterwards (require_login() in PHP).
import { Navigate, useLocation } from 'react-router';
import { useAuth } from '../context/AuthContext.jsx';
import { loginPath } from '../lib/hooks.js';
import { Spinner } from './ui.jsx';

export default function RequireAuth({ children }) {
    const { user, ready } = useAuth();
    const location = useLocation();
    if (!ready) return <Spinner />;
    if (!user) return <Navigate to={loginPath(location)} replace state={{ notice: 'Please log in to continue.' }} />;
    return children;
}
