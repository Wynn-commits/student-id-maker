import rateLimit from 'express-rate-limit';

// Scoped to /api/auth/login only — nothing else on the API is throttled.
// 5 attempts per 15 minutes per IP is generous for a real admin who
// mistypes a password, but slow enough to make brute-forcing the "admin"
// account impractical.
export const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 5,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many login attempts. Please wait 15 minutes and try again.' },
});
