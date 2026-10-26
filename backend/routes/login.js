
import express from 'express';
import { loginUsers } from '../controllers/login.js';
import {
    renovarSesion,
    cerrarSesion
} from '../controllers/sesion.js';

const router = express.Router();

router.post('/', loginUsers);
router.post('/refresh', renovarSesion);
router.post('/logout', cerrarSesion);

export default router;
