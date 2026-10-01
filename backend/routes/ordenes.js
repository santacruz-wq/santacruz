import express from 'express';

import {
    crearOrden,
    getOrdenes,
    getOrdenPorId,
    agregarProducto,
    crearAdicion,
    cambiarEstadoOrden
} from '../controllers/ordenes.js';

import {
    verificarToken,
    soloMesero,
    permitirRoles
} from '../middlewares/auth.js';

const router = express.Router();

// CREAR UNA NUEVA ORDEN (MESERO)

router.post(
    '/',
    verificarToken,
    soloMesero,
    crearOrden
);

// OBTENER TODAS LAS ÓRDENES

router.get(
    '/',
    verificarToken,
    getOrdenes
);

// OBTENER UNA ORDEN POR ID

router.get(
    '/:id',
    verificarToken,
    getOrdenPorId
);

// AGREGAR UN PRODUCTO A UNA ORDEN
// SOLO SI TODAVÍA ESTÁ PENDIENTE

router.post(
    '/:id/productos',
    verificarToken,
    soloMesero,
    agregarProducto
);

// CREAR UNA ADICIÓN A UNA ORDEN
// SE PUEDE HACER AUNQUE YA ESTÉ EN COCINA

router.post(
    '/:id/adiciones',
    verificarToken,
    soloMesero,
    crearAdicion
);

// CAMBIAR ESTADO DE LA ORDEN
// MESERO, COCINA O ADMIN

router.patch(
    '/:id/estado',
    verificarToken,
    permitirRoles(
        'mesero',
        'cocina',
        'admin'
    ),
    cambiarEstadoOrden
);

export default router;