import express from 'express';
import { loginUsers } from '../controllers/login.js';

const router = express.Router();

router.post('/', loginUsers);

export default router;