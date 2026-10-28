import jwt from 'jsonwebtoken';
import {db} from './db.js';

export function requiredText(value, label, max = 200) {
  if (typeof value !== 'string' || !value.trim() || value.trim().length > max) {
    throw Object.assign(new Error(`Invalid ${label}`), { status: 400 });
  }
  return value.trim();
}
export function positiveId(value) {
  const number = Number(value);
  if (!Number.isSafeInteger(number) || number < 1) throw Object.assign(new Error('Invalid ID'), { status: 400 });
  return number;
}
export function protect(req,res,next) {
  const token = req.headers.authorization?.match(/^Bearer (.+)$/)?.[1];
  if (!token) return res.status(401).json({error:'Authentication required'});
  try {
    const payload = jwt.verify(token,process.env.JWT_SECRET,{algorithms:['HS256']});
    const id=positiveId(payload.id);
    const user=db.prepare('SELECT id,role FROM users WHERE id=?').get(id);
    if (!user) return res.status(401).json({error:'Account not found'});
    req.user=user;
    next();
  } catch { res.status(401).json({error:'Session expired or invalid'}); }
}
export const allow = (...roles) => (req,res,next) => roles.includes(req.user.role)
  ? next() : res.status(403).json({error:'Not authorized'});
export const handler = fn => (req,res,next) => { try { fn(req,res,next); } catch(error) { next(error); } };
