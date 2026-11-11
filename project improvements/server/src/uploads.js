// Image uploads for book covers and profile photos (the Node version of upload_image() in PHP).
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import multer from 'multer';
import { MAX_IMAGE_BYTES } from '@novel/shared';
import { serverRoot } from './db.js';

export const UPLOAD_ROOT = path.join(serverRoot, 'uploads');

// Keep the file in memory first so its real contents can be checked before anything is saved
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: MAX_IMAGE_BYTES, files: 1 } });

// Express middleware: parse a multipart form with one optional image field
export function imageField(field) {
    return (req, res, next) => {
        upload.single(field)(req, res, (err) => {
            if (err) {
                const message = err.code === 'LIMIT_FILE_SIZE' ? 'Images must be 2 MB or smaller.' : 'The image could not be uploaded.';
                return res.status(400).json({ errors: { [field]: message } });
            }
            req.body ??= {};
            next();
        });
    };
}

// Work out the type from the first bytes, not the name or type the browser sent
function imageType(buffer) {
    const starts = (bytes, offset = 0) => bytes.every((b, i) => buffer[offset + i] === b);
    if (starts([0xff, 0xd8, 0xff])) return 'jpg';
    if (starts([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) return 'png';
    if (buffer.subarray(0, 6).toString('latin1').match(/^GIF8[79]a$/)) return 'gif';
    if (buffer.subarray(0, 4).toString('latin1') === 'RIFF' && buffer.subarray(8, 12).toString('latin1') === 'WEBP') return 'webp';
    return null;
}

// Save req.file to uploads/<folder>. Returns { path } (the URL path to store) or { error }.
export function saveImage(file, folder) {
    const type = imageType(file.buffer);
    if (!type) return { error: 'Only JPG, PNG, GIF or WEBP images are allowed.' };
    const name = crypto.randomBytes(8).toString('hex') + '.' + type;
    fs.mkdirSync(path.join(UPLOAD_ROOT, folder), { recursive: true });
    fs.writeFileSync(path.join(UPLOAD_ROOT, folder, name), file.buffer);
    return { path: `/uploads/${folder}/${name}` };
}

// Remove an earlier upload when it is replaced (never touches anything outside uploads/)
export function deleteUpload(urlPath) {
    if (typeof urlPath !== 'string' || !/^\/uploads\/(covers|avatars)\/[a-f0-9]+\.(jpg|png|gif|webp)$/.test(urlPath)) return;
    fs.rm(path.join(UPLOAD_ROOT, urlPath.replace('/uploads/', '')), { force: true }, () => {});
}
