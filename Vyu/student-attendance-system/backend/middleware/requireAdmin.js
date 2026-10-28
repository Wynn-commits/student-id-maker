import jwt from 'jsonwebtoken';

// This is the actual access control. The admin frontend's route guard
// (admin/src/router/index.js) only controls what the browser SHOWS —
// a request straight to the API with no valid token still has to get
// past this middleware, which is mounted in front of every /api/admin
// route in index.js.
export function requireAdmin(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token) {
    return res.status(401).json({ error: 'Not authenticated.' });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload.role !== 'admin') {
      return res.status(403).json({ error: 'Admin access only.' });
    }
    req.admin = payload;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Session expired. Please log in again.' });
  }
}
