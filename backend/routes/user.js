import express from 'express';
import { registrarUser } from '../controllers/user.js';

const router = express.Router();

router.post('/registrar', registrarUser);

export default router;