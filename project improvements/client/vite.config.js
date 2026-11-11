import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

// In development Vite serves the React app on :5173 and forwards API and upload
// requests to the Express server on :3001, so both look like one site to the browser.
const API = 'http://localhost:3001';

export default defineConfig({
    plugins: [react(), tailwindcss()],
    server: {
        port: 5173,
        proxy: {
            '/api': API,
            '/uploads': API,
        },
    },
});
