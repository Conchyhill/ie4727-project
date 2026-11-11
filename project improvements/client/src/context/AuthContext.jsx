// Who is logged in, shared with every component (the React version of current_user()).
import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api.js';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [state, setState] = useState({ user: null, cartCount: 0, rememberedUsername: '', ready: false });

    // Ask the server again, e.g. after logging in or adding to the cart
    const refresh = useCallback(async () => {
        try {
            const me = await api.get('/auth/me');
            setState({ ...me, ready: true });
        } catch {
            setState((s) => ({ ...s, ready: true }));
        }
    }, []);

    useEffect(() => {
        refresh();
    }, [refresh]);

    const value = useMemo(() => ({ ...state, refresh }), [state, refresh]);
    return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export const useAuth = () => useContext(AuthContext);
