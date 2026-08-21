import express from 'express';
import { traducirTexto } from '../controllers/traducir.js';

const router = express.Router();

//RUTA PÚBLICA - CUALQUIER USUARIO PUEDE TRADUCIR CONTENIDO
router.post('/', traducirTexto);

export default router;