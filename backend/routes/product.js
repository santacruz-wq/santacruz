import express from 'express';
import {
    getProductos,
    getProductoPorId,
    crearProducto,
    actualizarProducto,
    eliminarProducto
} from '../controllers/product.js';

const router = express.Router();

router.get('/', getProductos);
router.get('/:id', getProductoPorId);
router.post('/', crearProducto);
router.put('/:id', actualizarProducto);
router.delete('/:id', eliminarProducto);

export default router; 