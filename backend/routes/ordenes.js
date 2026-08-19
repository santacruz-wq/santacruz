import express from 'express';
import {
    crearOrden,
    getOrdenes,
    getOrdenPorId,
    agregarProducto,
    cambiarEstadoOrden
} from '../controllers/ordenes.js';
import { verificarToken, soloMesero, soloCocina, soloAdmin } from '../middlewares/auth.js';

const router = express.Router();

//CREAR UNA NUEVA ORDEN (MESERO)

router.post('/', verificarToken, soloMesero, crearOrden);

//OBTENER TODAS LAS ÓRDENES (CUALQUIER USUARIO AUTENTICADO)

router.get('/', verificarToken, getOrdenes);

//OBTENER UNA ORDEN POR ID

router.get('/:id', verificarToken, getOrdenPorId);

//AGREGAR UN PRODUCTO A UNA ORDEN EXISTENTE (MESERO)

router.post('/:id/productos', verificarToken, soloMesero, agregarProducto);

//CAMBIAR ESTADO DE LA ORDEN (MESERO, COCINA O ADMIN)

router.patch('/:id/estado', verificarToken, cambiarEstadoOrden);

export default router;