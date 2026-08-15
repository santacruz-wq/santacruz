import express from 'express';
import { solicitarCode, cambiarPassword } from '../controllers/recuperar.js';

const router = express.Router();

router.post('/solicitar', solicitarCode);
router.post('/cambiar', cambiarPassword);

export default router;