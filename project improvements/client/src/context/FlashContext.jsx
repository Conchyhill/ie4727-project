// Toast messages ("Added to your cart", errors...), the React version of flash() in PHP.
import { createContext, useCallback, useContext, useState } from 'react';

const FlashContext = createContext(() => {});
let nextId = 1;

export function FlashProvider({ children }) {
    const [messages, setMessages] = useState([]);

    const dismiss = useCallback((id) => setMessages((list) => list.filter((m) => m.id !== id)), []);

    const flash = useCallback((text, type = 'success') => {
        const id = nextId++;
        setMessages((list) => [...list.slice(-3), { id, text, type }]);
        setTimeout(() => dismiss(id), type === 'error' ? 7000 : 4500);
    }, [dismiss]);

    return (
        <FlashContext.Provider value={flash}>
            {children}
            <div className="pointer-events-none fixed inset-x-0 bottom-4 z-50 flex flex-col items-center gap-2 px-4 sm:inset-x-auto sm:right-6 sm:bottom-6 sm:items-end"
                aria-live="polite">
                {messages.map((m) => (
                    <div key={m.id} role={m.type === 'error' ? 'alert' : 'status'}
                        className={`pointer-events-auto flex w-full max-w-sm items-start gap-3 rounded-xl px-4 py-3 text-sm font-medium shadow-lg ring-1 animate-[toast-in_.2s_ease-out] ${
                            m.type === 'error' ? 'bg-red-50 text-red-800 ring-red-200' : 'bg-white text-ink ring-khaki'}`}>
                        <span aria-hidden="true">{m.type === 'error' ? '⚠' : '✓'}</span>
                        <span className="flex-1">{m.text}</span>
                        <button type="button" onClick={() => dismiss(m.id)} className="cursor-pointer text-stone hover:text-ink" aria-label="Dismiss">×</button>
                    </div>
                ))}
            </div>
            <style>{'@keyframes toast-in { from { opacity: 0; transform: translateY(8px); } }'}</style>
        </FlashContext.Provider>
    );
}

export const useFlash = () => useContext(FlashContext);
