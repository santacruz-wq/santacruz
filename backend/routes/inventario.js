import express from "express";
import {
    getInventario,
    getInventarioPorProducto,
    crearInventario,
    actualizarCantidadMinMax,
    registrarMovimiento,
    getMovimientos,
    getMovimientosPorProducto
} from "../controllers/inventario.js";
import { verificarToken, soloAdmin, permitirRoles } from "../middlewares/auth.js";

const router = express.Router();

//RUTAS DE INVENTARIO
router.get("/", verificarToken, getInventario);
router.get("/producto/:productoId", verificarToken, getInventarioPorProducto);
router.post("/", verificarToken, soloAdmin, crearInventario);
router.put("/producto/:productoId/minmax", verificarToken, soloAdmin, actualizarCantidadMinMax);

//RUTAS DE MOVIMIENTOS
router.get("/movimientos", verificarToken, permitirRoles('cocina', 'admin'),getMovimientos);
router.get("/movimientos/producto/:productoId", verificarToken, permitirRoles('cocina', 'admin'), getMovimientosPorProducto);
router.post("/movimientos", verificarToken, permitirRoles('cocina', 'admin'), registrarMovimiento);

export default router;