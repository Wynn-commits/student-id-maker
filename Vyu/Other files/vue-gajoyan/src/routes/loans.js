import {Router} from 'express';
import {db} from '../db.js';
import {protect,allow,handler,positiveId} from '../security.js';
const router=Router();
router.use(protect);
router.get('/',handler((req,res)=>{
  const privileged=['admin','librarian'].includes(req.user.role);
  const sql=`SELECT l.id,l.member_id,l.book_id,l.borrowed_at,l.due_at,l.returned_at,b.title,u.name member
    FROM loans l JOIN books b ON b.id=l.book_id JOIN users u ON u.id=l.member_id`;
  res.json(db.prepare(sql+(privileged?'':' WHERE l.member_id=?')+' ORDER BY l.id DESC LIMIT 200')
    .all(...(privileged?[]:[req.user.id])));
}));
router.post('/',allow('admin','librarian'),handler((req,res)=>{
  const member=positiveId(req.body.member_id),book=positiveId(req.body.book_id);
  const days=Number(req.body.days);
  if(!Number.isSafeInteger(days)||days<1||days>60) return res.status(400).json({error:'Loan period must be 1â€“60 days'});
  const due=new Date(Date.now()+days*86400000).toISOString();
  const id=db.transaction(()=>{
    if(!db.prepare("SELECT 1 FROM users WHERE id=? AND role='member'").get(member)) throw Object.assign(new Error('Member not found'),{status:404});
    const updated=db.prepare('UPDATE books SET available_copies=available_copies-1 WHERE id=? AND available_copies>0').run(book);
    if(!updated.changes) throw Object.assign(new Error('Book unavailable'),{status:409});
    return db.prepare('INSERT INTO loans(member_id,book_id,issued_by,due_at) VALUES(?,?,?,?)')
      .run(member,book,req.user.id,due).lastInsertRowid;
  })();
  res.status(201).json({id});
}));
router.post('/:id/return',allow('admin','librarian'),handler((req,res)=>{
  const id=positiveId(req.params.id);
  db.transaction(()=>{
    const loan=db.prepare('SELECT book_id FROM loans WHERE id=? AND returned_at IS NULL').get(id);
    if(!loan) throw Object.assign(new Error('Active loan not found'),{status:404});
    db.prepare('UPDATE loans SET returned_at=CURRENT_TIMESTAMP,returned_by=? WHERE id=?').run(req.user.id,id);
    db.prepare('UPDATE books SET available_copies=available_copies+1 WHERE id=?').run(loan.book_id);
  })();
  res.json({id,returned:true});
}));
export default router;
