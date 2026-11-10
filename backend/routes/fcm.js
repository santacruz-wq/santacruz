import express from 'express';

import {
    registrarTokenFCM,
    eliminarTokenFCM
} from '../controllers/fcm.js';

import { verificarToken } from '../middlewares/auth.js';

const router = express.Router();

// Registrar el dispositivo Android
router.post('/token', verificarToken, registrarTokenFCM);

// Desvincular el dispositivo
router.post('/token/eliminar', verificarToken, eliminarTokenFCM);

export default router;