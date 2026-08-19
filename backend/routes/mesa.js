import express from 'express';
import {
    getMesas,
    getMesaPorId,
    crearMesa,
    actualizarMesa,
    cambiarEstadoMesa,
    eliminarMesa
} from '../controllers/mesa.js';
import { verificarToken, soloAdmin } from '../middlewares/auth.js';

const router = express.Router();

//OBTENER TODAS LAS MESAS

router.get('/', verificarToken, getMesas);

//OBTENER UNA MESA POR ID

router.get('/:id', verificarToken, getMesaPorId);

//CREAR UNA MESA (SOLO ADMIN)

router.post('/', verificarToken, soloAdmin, crearMesa);

//ACTUALIZAR UNA MESA (SOLO ADMIN)

router.put('/:id', verificarToken, soloAdmin, actualizarMesa);

//CAMBIAR ESTADO DE LA MESA (MESERO O ADMIN)

router.patch('/:id/estado', verificarToken, cambiarEstadoMesa);

//ELIMINAR UNA MESA (SOLO ADMIN)

router.delete('/:id', verificarToken, soloAdmin, eliminarMesa);

export default router;