
import express from 'express';
import {
    getProductos,
    getProductoPorId,
    crearProducto,
    actualizarProducto,
    eliminarProducto,
    cambiarDisponibilidad,
    cambiarEstadoMenu
} from '../controllers/product.js';
import {
    verificarToken,
    soloAdmin,
    permitirRoles
} from '../middlewares/auth.js';
import { upload } from '../middlewares/upload.js';

const router = express.Router();

router.get('/', getProductos);
router.get('/:id', getProductoPorId);

router.post('/', verificarToken, soloAdmin, upload.single('imagen'), crearProducto);
router.put('/:id', verificarToken, soloAdmin, upload.single('imagen'), actualizarProducto);
router.delete('/:id', verificarToken, soloAdmin, eliminarProducto);

router.patch('/:id/disponibilidad', verificarToken, permitirRoles('admin', 'cocina'), cambiarDisponibilidad);

// Cambiar entre disponible, agotado y oculto: solo administrador.
router.patch('/:id/estado-menu', verificarToken, soloAdmin, cambiarEstadoMenu);

export default router;
