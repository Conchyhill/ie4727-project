// Routes: the same 10 pages as the PHP version, as client-side routes.
// Each page is loaded on demand (code splitting), so the first visit downloads less JavaScript.
import { lazy } from 'react';
import { Route, Routes } from 'react-router';
import { AuthProvider } from './context/AuthContext.jsx';
import { FlashProvider } from './context/FlashContext.jsx';
import Layout from './components/Layout.jsx';
import RequireAuth from './components/RequireAuth.jsx';

const Home = lazy(() => import('./pages/Home.jsx'));
const Browse = lazy(() => import('./pages/Browse.jsx'));
const Book = lazy(() => import('./pages/Book.jsx'));
const Reader = lazy(() => import('./pages/Reader.jsx'));
const Login = lazy(() => import('./pages/Login.jsx'));
const Account = lazy(() => import('./pages/Account.jsx'));
const ReadingList = lazy(() => import('./pages/ReadingList.jsx'));
const Create = lazy(() => import('./pages/Create.jsx'));
const ChapterForm = lazy(() => import('./pages/ChapterForm.jsx'));
const Cart = lazy(() => import('./pages/Cart.jsx'));
const Info = lazy(() => import('./pages/Info.jsx'));
const NotFound = lazy(() => import('./pages/NotFound.jsx'));

const members = (page) => <RequireAuth>{page}</RequireAuth>;

export default function App() {
    return (
        <FlashProvider>
            <AuthProvider>
                <Routes>
                    <Route element={<Layout />}>
                        <Route index element={<Home />} />
                        <Route path="browse" element={<Browse />} />
                        <Route path="books/:id" element={<Book />} />
                        <Route path="books/:id/read/:ch" element={<Reader />} />
                        <Route path="login" element={<Login />} />
                        <Route path="info" element={<Info />} />
                        <Route path="account" element={members(<Account />)} />
                        <Route path="reading-list" element={members(<ReadingList />)} />
                        <Route path="create" element={members(<Create />)} />
                        <Route path="create/edit/:id" element={members(<Create />)} />
                        <Route path="create/:id/chapter" element={members(<ChapterForm />)} />
                        <Route path="create/:id/chapter/:ch" element={members(<ChapterForm />)} />
                        <Route path="cart" element={members(<Cart />)} />
                        <Route path="*" element={<NotFound />} />
                    </Route>
                </Routes>
            </AuthProvider>
        </FlashProvider>
    );
}
