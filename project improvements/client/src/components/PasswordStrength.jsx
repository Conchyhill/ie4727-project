import { passwordStrength } from '@novel/shared';

const COLOURS = ['bg-red-500', 'bg-orange-500', 'bg-amber-400', 'bg-lime-500', 'bg-emerald-600'];

// Strength bar under a new-password field
export default function PasswordStrength({ password }) {
    const { score, label } = passwordStrength(password);
    return (
        <div className="mt-2" aria-live="polite">
            <div className="h-1.5 overflow-hidden rounded-full bg-khaki/40" aria-hidden="true">
                <div className={`h-full rounded-full transition-all duration-300 ${COLOURS[score]}`} style={{ width: password ? `${(score + 1) * 20}%` : 0 }} />
            </div>
            <p className="mt-1 text-xs text-stone">{password ? `Strength: ${label}` : 'At least 8 characters, with a letter and a number.'}</p>
        </div>
    );
}
