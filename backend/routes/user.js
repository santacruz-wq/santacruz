import express from 'express';
import { registrarUser, verificarCuenta, reenviarCodigoVerificacion } from '../controllers/user.js';
import { loginWithGoogle } from "../controllers/google.js";



const router = express.Router();

router.post('/registrar', registrarUser);
router.post('/verificar-codigo', verificarCuenta);
router.post('/reenviar-codigo', reenviarCodigoVerificacion);
router.post("/login-google", loginWithGoogle);

export default router;