import express from "express";

import {
  getInventario,
  getInventarioPorProducto,
  crearInventario,
  crearInsumo,
  actualizarCantidadMinMax,
  registrarMovimiento,
  getMovimientos,
  getMovimientosPorProducto,
} from "../controllers/inventario.js";

import {
  verificarToken,
  soloAdmin,
  permitirRoles,
} from "../middlewares/auth.js";

const router = express.Router();

// INVENTARIO
router.get("/", verificarToken, getInventario);

router.get(
  "/producto/:productoId",
  verificarToken,
  getInventarioPorProducto
);

router.post("/", verificarToken, soloAdmin, crearInventario);

// Crear insumos independientes: harina, azúcar, leche, etc.
router.post("/insumos", verificarToken, soloAdmin, crearInsumo);

router.put(
  "/producto/:productoId/minmax",
  verificarToken,
  soloAdmin,
  actualizarCantidadMinMax
);

// MOVIMIENTOS
router.get(
  "/movimientos",
  verificarToken,
  permitirRoles("cocina", "admin"),
  getMovimientos
);

router.get(
  "/movimientos/producto/:productoId",
  verificarToken,
  permitirRoles("cocina", "admin"),
  getMovimientosPorProducto
);

router.post(
  "/movimientos",
  verificarToken,
  permitirRoles("cocina", "admin"),
  registrarMovimiento
);

router.put(
  "/registro/:inventarioId/minmax",
  verificarToken,
  soloAdmin,
  actualizarCantidadMinMax
);

export default router;