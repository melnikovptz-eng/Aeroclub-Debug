# KD-PILOT PHP + MySQL backend

This backend is being developed separately from the currently published static GitHub Pages prototype. The existing `index.html` and Pages deployment remain unchanged.

## Stack
- PHP 8.2+ (8.3 recommended)
- MySQL 8.0+ / MariaDB 10.6+
- PDO MySQL with prepared statements
- UTF-8 (`utf8mb4`)

## Layout
- `public/api/` — web-accessible API endpoints; configure the PHP host document root to this backend's `public` directory.
- `src/` — application bootstrap and private PHP code; keep outside the document root.
- `database/schema.sql` — initial schema for accounts, pilots, spots, flights and participants.
- `.env.example` — required environment variables. Create real environment variables in the hosting control panel; never commit passwords.

## Initial setup
1. Create a PHP hosting account and a MySQL database/user.
2. Set the domain/subdomain document root to `backend/public`.
3. Configure environment variables using `.env.example` as a template.
4. Import `database/schema.sql` into MySQL.
5. Open `/api/health.php`; success returns JSON with `ok: true` and `database: connected`.

## Security baseline
- Never put database credentials in browser JavaScript or commit real credentials.
- Keep `src` and `database` outside the public document root.
- Use HTTPS.
- Authentication endpoints must use `password_hash()` / `password_verify()`, secure session cookies, CSRF protection and rate limiting.
- All SQL writes must use PDO prepared statements and server-side role checks.

## Deployment note
GitHub Pages cannot execute PHP or host MySQL. Keep it as the static frontend preview until a PHP-capable host is selected. The production frontend can later call this API over HTTPS.
