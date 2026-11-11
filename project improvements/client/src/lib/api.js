// Small wrapper around fetch() for the Express API.
// Errors come back as ApiError, with .status, a readable .message and .errors ({ field: message }).

export class ApiError extends Error {
    constructor(status, body) {
        const errors = body?.errors ?? {};
        super(body?.error ?? Object.values(errors)[0] ?? 'Something went wrong. Please try again.');
        this.status = status;
        this.errors = errors;
        this.body = body;
    }
}

async function request(method, url, body) {
    const options = { method, credentials: 'same-origin', headers: { Accept: 'application/json' } };
    if (body instanceof FormData) {
        options.body = body;  // the browser sets the multipart boundary itself
    } else if (body !== undefined) {
        options.headers['Content-Type'] = 'application/json';
        options.body = JSON.stringify(body);
    }

    let response;
    try {
        response = await fetch('/api' + url, options);
    } catch {
        throw new ApiError(0, { error: 'Could not reach the server. Is it running?' });
    }
    const isJson = response.headers.get('content-type')?.includes('application/json');
    const data = isJson ? await response.json() : null;
    if (!response.ok) throw new ApiError(response.status, data);
    return data;
}

export const api = {
    get: (url) => request('GET', url),
    post: (url, body) => request('POST', url, body),
    put: (url, body) => request('PUT', url, body),
    delete: (url, body) => request('DELETE', url, body),
};
