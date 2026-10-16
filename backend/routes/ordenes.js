import express from 'express';

import {
    crearOrden,
    getOrdenes,
    getOrdenPorId,
    agregarProducto,
    crearAdicion,
    cambiarEstadoOrden,
    getProductosMasVendidos
} from '../controllers/ordenes.js';

import {
    verificarToken,
    soloMesero,
    permitirRoles
} from '../middlewares/auth.js';

const router = express.Router();

// Crear orden
router.post(
    '/',
    verificarToken,
    soloMesero,
    crearOrden
);

// Productos más vendidos (administrador)
router.get(
    '/estadisticas/productos-mas-vendidos',
    verificarToken,
    permitirRoles('admin'),
    getProductosMasVendidos
);

// Obtener todas las órdenes
router.get(
    '/',
    verificarToken,
    getOrdenes
);

// Obtener orden por ID
router.get(
    '/:id',
    verificarToken,
    getOrdenPorId
);

// Agregar producto a una orden pendiente
router.post(
    '/:id/productos',
    verificarToken,
    soloMesero,
    agregarProducto
);

// Crear adición
router.post(
    '/:id/adiciones',
    verificarToken,
    soloMesero,
    crearAdicion
);

// Cambiar estado de una orden
router.patch(
    '/:id/estado',
    verificarToken,
    permitirRoles('mesero', 'cocina', 'admin'),
    cambiarEstadoOrden
);

export default router;