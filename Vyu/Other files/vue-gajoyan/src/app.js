import express from 'express';
import cors from 'cors';
import {db} from './db.js';
import auth from './routes/auth.js';
import books from './routes/books.js';
import loans from './routes/loans.js';

if (!process.env.JWT_SECRET || process.env.JWT_SECRET.length<32) throw new Error('Set JWT_SECRET (32+ characters)');
const app=express();
app.disable('x-powered-by');
app.use(cors({origin:process.env.CLIENT_ORIGIN || 'http://127.0.0.1:5173'}));
app.use(express.json({limit:'20kb'}));
app.get('/api/health',(req,res)=>res.json({ok:true}));
app.use('/api/auth',auth);
app.use('/api/books',books);
app.use('/api/loans',loans);
app.use('/api',(req,res)=>res.status(404).json({error:'Route not found'}));
app.use((err,req,res,next)=>{
  const status=err.status || (err.code?.startsWith('SQLITE_CONSTRAINT')?409:500);
  if(status===500) console.error(err);
  res.status(status).json({error:status===500?'Internal server error':status===409&&err.code?.startsWith('SQLITE_CONSTRAINT')?'Duplicate or invalid record':err.message});
});
const port=Number(process.env.PORT)||3000;
app.listen(port,'127.0.0.1',()=>console.log(`API: http://127.0.0.1:${port}`));
