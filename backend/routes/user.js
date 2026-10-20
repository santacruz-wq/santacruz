import express from 'express';

import {
    registrarUser,
    verificarCuenta,
    reenviarCodigoVerificacion
} from '../controllers/user.js';

import { loginWithGoogle } from '../controllers/google.js';

const router = express.Router();

// Registro temporal y envío del código.
router.post('/registrar', registrarUser);

// Verificar el código y crear la cuenta definitiva.
router.post('/verificar-codigo', verificarCuenta);

// Reenviar el código de verificación.
router.post('/reenviar-codigo', reenviarCodigoVerificacion);

// Inicio de sesión con Google.
router.post('/login-google', loginWithGoogle);

export default router;