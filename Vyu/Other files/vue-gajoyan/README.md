# CPSU Library Management

A Vue 3 staff workspace backed by an Express API and a local SQLite database. It supports a searchable book catalog, member accounts, checkouts, returns, loan due dates, and overdue tracking.

## Requirements

- Node.js 22.18 or newer
- npm

## Setup

Install the client and API dependencies:

```sh
npm install
```

Create a `.env` file in the project root with a unique JWT secret and the first administrator credentials. Use at least 32 characters for `JWT_SECRET` and at least 12 for `ADMIN_PASSWORD`:

```env
JWT_SECRET=replace-with-a-long-random-secret-value
ADMIN_EMAIL=admin@cpsu.edu.ph
ADMIN_PASSWORD=replace-with-a-12-character-password
DB_PATH=library.sqlite
CLIENT_ORIGIN=http://127.0.0.1:5173
PORT=3000
```

The SQLite database and its tables are created automatically at first server start. The administrator account is created on the first run only.

This local workspace is configured with `admin@cpsu.edu.ph` and password `test123` for convenience. This short password is for local testing only; use a strong password before deploying or exposing the app. New member accounts can be created from the sign-up screen and require a password of at least 12 characters.

## Run locally

Start the Vue client and API together:

```sh
npm run dev:all
```

Open the Vite URL shown in the terminal, normally `http://localhost:5173`. The Vite development server forwards `/api` requests to the Express API on port 3000.

To run either process separately, use `npm run dev` for the client and `npm run server:dev` for the API. Sign in with the administrator email and password from `.env`.

## Production build

```sh
npm run build
```

Run the API in production with `npm run server:start`; serve the generated `dist` directory from a web server configured to forward `/api` requests to the API.
