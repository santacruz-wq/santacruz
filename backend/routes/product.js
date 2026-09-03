import express from 'express';
import {
    getProductos,
    getProductoPorId,
    crearProducto,
    actualizarProducto,
    eliminarProducto,
    cambiarDisponibilidad
} from '../controllers/product.js';
import { verificarToken, soloAdmin, permitirRoles } from '../middlewares/auth.js';
import { upload } from '../middlewares/upload.js';

const router = express.Router();

//VER PRODUCTOS (PÚBLICO O CUALQUIER USUARIO LOGUEADO)

router.get('/', getProductos);
router.get('/:id', getProductoPorId);

//CREAR, EDITAR Y ELIMINAR PRODUCTOS (SOLO ADMIN)

router.post('/', verificarToken, soloAdmin, upload.single('imagen'), crearProducto);
router.put('/:id', verificarToken, soloAdmin, upload.single('imagen'), actualizarProducto);
router.delete('/:id', verificarToken, soloAdmin, eliminarProducto);

//CAMBIAR DISPONIBILIDAD (SOLO ADMIN O COCINA)

router.patch('/:id/disponibilidad', verificarToken, permitirRoles('admin', 'cocina'), cambiarDisponibilidad);

export default router;