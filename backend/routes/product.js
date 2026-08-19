import express from 'express';
import {
    getProductos,
    getProductoPorId,
    crearProducto,
    actualizarProducto,
    eliminarProducto
} from '../controllers/product.js';
import { verificarToken, soloAdmin } from '../middlewares/auth.js';

const router = express.Router();

//VER PRODUCTOS (PÚBLICO O CUALQUIER USUARIO LOGUEADO)

router.get('/', getProductos);
router.get('/:id', getProductoPorId);

//CREAR, EDITAR Y ELIMINAR PRODUCTOS (SOLO ADMIN)

router.post('/', verificarToken, soloAdmin, crearProducto);
router.put('/:id', verificarToken, soloAdmin, actualizarProducto);
router.delete('/:id', verificarToken, soloAdmin, eliminarProducto);

export default router;