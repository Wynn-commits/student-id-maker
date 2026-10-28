import {Router} from 'express';
import {db} from '../db.js';
import {protect,allow,handler,positiveId,requiredText} from '../security.js';
const router=Router();
router.use(protect);
router.get('/',handler((req,res)=>{
  const term=String(req.query.q||'').trim().slice(0,100);
  const q=`%${term.replaceAll('\\','\\\\').replaceAll('%','\\%').replaceAll('_','\\_')}%`;
  res.json(db.prepare("SELECT id,isbn,title,author,category,total_copies,available_copies FROM books WHERE title LIKE ? ESCAPE '\\' OR author LIKE ? ESCAPE '\\' OR isbn LIKE ? ESCAPE '\\' ORDER BY id DESC LIMIT 200").all(q,q,q));
}));
router.post('/',allow('admin','librarian'),handler((req,res)=>{
  const title=requiredText(req.body.title,'title'),author=requiredText(req.body.author,'author');
  const isbn=req.body.isbn ? requiredText(req.body.isbn,'ISBN',30) : null;
  const category=typeof req.body.category==='string'?req.body.category.trim():'';
  if(category.length>100) return res.status(400).json({error:'Category too long'});
  const copies=Number(req.body.total_copies);
  if(!Number.isSafeInteger(copies)||copies<0||copies>100000) return res.status(400).json({error:'Invalid copies'});
  const id=db.prepare('INSERT INTO books(isbn,title,author,category,total_copies,available_copies) VALUES(?,?,?,?,?,?)')
    .run(isbn,title,author,category,copies,copies).lastInsertRowid;
  res.status(201).json({id});
}));
router.patch('/:id',allow('admin','librarian'),handler((req,res)=>{
  const id=positiveId(req.params.id);
  const title=requiredText(req.body.title,'title'),author=requiredText(req.body.author,'author');
  const isbn=req.body.isbn?requiredText(req.body.isbn,'ISBN',30):null;
  const category=typeof req.body.category==='string'?req.body.category.trim():'';
  if(category.length>100) return res.status(400).json({error:'Category too long'});
  const total=Number(req.body.total_copies);
  if(!Number.isSafeInteger(total)||total<0||total>100000) return res.status(400).json({error:'Invalid copies'});
  db.transaction(()=>{
    const old=db.prepare('SELECT * FROM books WHERE id=?').get(id);
    if(!old) throw Object.assign(new Error('Book not found'),{status:404});
    const active=db.prepare('SELECT COUNT(*) n FROM loans WHERE book_id=? AND returned_at IS NULL').get(id).n;
    if(total<active) throw Object.assign(new Error('Total copies cannot be less than active loans'),{status:409});
    db.prepare('UPDATE books SET isbn=?,title=?,author=?,category=?,total_copies=?,available_copies=? WHERE id=?')
      .run(isbn,title,author,category,total,total-active,id);
  })();
  res.json({id});
}));
export default router;
