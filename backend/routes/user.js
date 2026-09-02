import express from 'express';
import { registrarUser, verificarCuenta, reenviarCodigoVerificacion } from '../controllers/user.js';

const router = express.Router();

router.post('/registrar', registrarUser);
router.post('/verificar-codigo', verificarCuenta);
router.post('/reenviar-codigo', reenviarCodigoVerificacion);

export default router;