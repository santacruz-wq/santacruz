import express from "express";
import {
    getInventario,
    getInventarioPorProducto,
    crearInventario,
    actualizarCantidadMinima,
    registrarMovimiento,
    getMovimientos,
    getMovimientosPorProducto
} from "../controllers/inventario.js";
import { verificarToken, soloAdmin, soloCocina } from "../middlewares/auth.js";

const router = express.Router();

//RUTAS DE INVENTARIO
router.get("/", verificarToken, getInventario);
router.get("/producto/:productoId", verificarToken, getInventarioPorProducto);
router.post("/", verificarToken, soloAdmin, crearInventario);
router.put("/producto/:productoId/minima", verificarToken, soloAdmin, actualizarCantidadMinima);

//RUTAS DE MOVIMIENTOS
router.get("/movimientos", verificarToken, getMovimientos);
router.get("/movimientos/producto/:productoId", verificarToken, getMovimientosPorProducto);
router.post("/movimientos", verificarToken, registrarMovimiento);

export default router;