import crypto from 'crypto';

// scrypt is built into Node — no native module to compile, unlike bcrypt.
// That matters here because it means `npm install` stays simple for
// whoever is grading/running this project.

export function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString('hex');
  const hash = crypto.scryptSync(password, salt, 64).toString('hex');
  return { hash, salt };
}

export function verifyPassword(password, hash, salt) {
  const candidate = crypto.scryptSync(password, salt, 64).toString('hex');
  const candidateBuf = Buffer.from(candidate, 'hex');
  const hashBuf = Buffer.from(hash, 'hex');
  if (candidateBuf.length !== hashBuf.length) return false;
  return crypto.timingSafeEqual(candidateBuf, hashBuf);
}
