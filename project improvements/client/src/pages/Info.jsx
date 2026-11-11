// About, Help, Terms, Privacy, Contact and Feedback on one page (footer links jump to each section).
import { Link } from 'react-router';
import { FEEDBACK_TOPICS, FREE_CHAPTERS, SITE_NAME, validateFeedback } from '@novel/shared';
import { api } from '../lib/api.js';
import { useApi, useForm, useTitle } from '../lib/hooks.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useFlash } from '../context/FlashContext.jsx';
import { CharCount, Field, FormError, StatCards } from '../components/ui.jsx';

const SECTIONS = [['about', 'About'], ['help', 'Help'], ['terms', 'Terms'], ['privacy', 'Privacy'], ['contact', 'Contact'], ['feedback', 'Feedback']];

function FeedbackForm() {
    const { user } = useAuth();
    const flash = useFlash();
    const form = useForm({ name: user?.username ?? '', email: user?.email ?? '', subject: '', message: '' }, validateFeedback);
    const send = form.submit(async (values) => {
        flash((await api.post('/feedback', values)).message);
        form.reset({ ...values, subject: '', message: '' });
    });
    return (
        <form onSubmit={send} noValidate className="space-y-4">
            <FormError message={form.errors._form} />
            <div className="grid gap-4 sm:grid-cols-2">
                <Field label="Name" htmlFor="fbName" error={form.errors.name}>
                    <input id="fbName" className="input" maxLength={60} {...form.field('name')} />
                </Field>
                <Field label="Email" htmlFor="fbEmail" error={form.errors.email}>
                    <input id="fbEmail" type="email" className="input" maxLength={100} {...form.field('email')} />
                </Field>
            </div>
            <Field label="Topic" htmlFor="fbSubject" error={form.errors.subject}>
                <select id="fbSubject" className="input" {...form.field('subject')}>
                    <option value="">Choose a topic</option>
                    {FEEDBACK_TOPICS.map((t) => <option key={t}>{t}</option>)}
                </select>
            </Field>
            <Field label="Message" htmlFor="fbMessage" error={form.errors.message}>
                <textarea id="fbMessage" rows={5} maxLength={2000} className="input" {...form.field('message')} />
                <CharCount value={form.values.message} max={2000} min={10} />
            </Field>
            <button type="submit" className="btn" disabled={form.busy}>{form.busy ? 'Sending...' : 'Send feedback'}</button>
        </form>
    );
}

function Section({ id, title, children }) {
    return (
        <section id={id} className="card scroll-mt-24">
            <h2 className="section-title">{title}</h2>
            <div className="space-y-3 text-sm leading-relaxed">{children}</div>
        </section>
    );
}

export default function Info() {
    useTitle('About & Help');
    const { user, ready } = useAuth();
    const { data: stats } = useApi('/info/stats');
    const faq = [
        ['Do I need an account to read?', <>No. Anyone can browse the library and read the first {FREE_CHAPTERS} chapters of every book.{' '}
            <Link className="link" to="/login?tab=signup">Create a free account</Link> to save books, track your progress and buy books.</>],
        ['How do I find a book by its serial number?', <>Log in, open <Link className="link" to="/browse">Browse</Link> and use the <em>Advanced search</em> box.
            Every book's serial number (for example NB-000001) is shown on its information page.</>],
        ['How does buying a book work?', <>Choose &ldquo;Buy full book&rdquo; on a book's page, then pay from your <Link className="link" to="/cart">Shopping Cart</Link>.
            Once payment succeeds, every chapter is unlocked and the book is added to your library.</>],
        ['How do I publish my own story?', <>Go to <Link className="link" to="/create">Create</Link>, fill in your book's details and cover, then add chapters whenever you are ready.</>],
        ['Where is my reading progress?', <>Your <Link className="link" to="/reading-list">Reading List</Link> has a Library tab for saved books and a History tab showing
            the furthest chapter you have reached in each book.</>],
    ];

    return (
        <div className="grid gap-6 lg:grid-cols-[180px_1fr]">
            <nav aria-label="On this page" className="lg:sticky lg:top-24 lg:self-start">
                <ul className="flex flex-wrap gap-2 lg:flex-col lg:gap-1">
                    {SECTIONS.map(([id, label]) => (
                        <li key={id}><a href={`#${id}`} className="block rounded-full px-3 py-1.5 text-sm font-medium text-stone hover:bg-white/70 hover:text-ink">{label}</a></li>
                    ))}
                </ul>
            </nav>

            <div className="space-y-6">
                <Section id="about" title={`About ${SITE_NAME}`}>
                    <p>{SITE_NAME} is an online library of web novels. Readers can explore books by genre, see what is trending today, and read chapters
                        right in the browser. Members keep a reading list that remembers their progress, review the books they love, and publish their own
                        stories one chapter at a time.</p>
                    {stats && <StatCards items={[[stats.books, 'books'], [stats.chapters, 'chapters'], [stats.genres, 'genres'], [stats.members, 'members']]} />}
                </Section>

                <Section id="help" title="Help">
                    <div className="space-y-2">
                        {faq.map(([q, a]) => (
                            <details key={q} className="group rounded-xl bg-cream/60 px-4 py-3 ring-1 ring-khaki/50 open:bg-white">
                                <summary className="cursor-pointer list-none font-semibold marker:hidden">
                                    <span className="mr-2 inline-block text-sand transition group-open:rotate-90">›</span>{q}
                                </summary>
                                <p className="mt-2 pl-5 text-stone">{a}</p>
                            </details>
                        ))}
                    </div>
                </Section>

                <Section id="terms" title="Terms of Use">
                    <ol className="list-decimal space-y-1 pl-5">
                        <li>You must keep your login details private and are responsible for activity on your account.</li>
                        <li>Books you publish must be your own work. Do not upload content that is copied, illegal or hateful.</li>
                        <li>Purchases unlock a book for your account only and are not transferable.</li>
                        <li>Reviews should be honest and respectful. We may remove reviews or books that break these terms.</li>
                        <li>This site is a student project for IE4727 and payments are simulated; no real money is charged.</li>
                    </ol>
                </Section>

                <Section id="privacy" title="Privacy">
                    <p>We store only what the site needs to work: your username, email, a securely hashed password, an optional profile photo, your reading list,
                        reviews and orders. Card details entered at checkout are checked and then discarded, never saved. A signed session cookie keeps you logged in,
                        an optional &ldquo;remember me&rdquo; cookie stores your username for 30 days, and your preferred reading text size is kept in this browser.
                        Deleting your account removes your personal data.</p>
                </Section>

                <Section id="contact" title="Contact">
                    <ul className="space-y-1">
                        <li><strong>Email:</strong> webmaster@localhost (or use the feedback form below)</li>
                        <li><strong>Address:</strong> School of EEE, Nanyang Technological University, 50 Nanyang Avenue, Singapore 639798</li>
                        <li><strong>Hours:</strong> Monday to Friday, 9am &ndash; 5pm</li>
                    </ul>
                </Section>

                <Section id="feedback" title="Feedback">
                    <p>Found a bug, or have an idea for the library? Let us know.</p>
                    {ready && <FeedbackForm key={user?.id ?? 'guest'} />}
                </Section>
            </div>
        </div>
    );
}
