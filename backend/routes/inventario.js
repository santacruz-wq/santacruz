
import express from "express";

import {
  getInventario,
  getInventarioPorProducto,
  crearInventario,
  crearInsumo,
  actualizarInsumo,
  eliminarInsumo,
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

// ==========================================
// INVENTARIO GENERAL
// ==========================================

// Obtener todo el inventario
router.get("/", verificarToken, getInventario);

// Consultar inventario de un producto del menú
router.get(
  "/producto/:productoId",
  verificarToken,
  getInventarioPorProducto
);

// Crear inventario para un producto
router.post(
  "/",
  verificarToken,
  soloAdmin,
  crearInventario
);

// ==========================================
// INSUMOS INDEPENDIENTES
// ==========================================

// Crear un insumo
router.post(
  "/insumos",
  verificarToken,
  soloAdmin,
  crearInsumo
);

// Editar nombre y unidad de medida de un insumo
router.put(
  "/insumos/:inventarioId",
  verificarToken,
  soloAdmin,
  actualizarInsumo
);

// Eliminar un insumo sin movimientos registrados
router.delete(
  "/insumos/:inventarioId",
  verificarToken,
  soloAdmin,
  eliminarInsumo
);

// ==========================================
// CANTIDADES MÍNIMAS Y MÁXIMAS
// ==========================================

// Actualizar límites del inventario de un producto
router.put(
  "/producto/:productoId/minmax",
  verificarToken,
  soloAdmin,
  actualizarCantidadMinMax
);

// Actualizar límites de un registro de inventario
router.put(
  "/registro/:inventarioId/minmax",
  verificarToken,
  soloAdmin,
  actualizarCantidadMinMax
);

// ==========================================
// MOVIMIENTOS DE INVENTARIO
// ==========================================

// Obtener todos los movimientos
router.get(
  "/movimientos",
  verificarToken,
  permitirRoles("cocina", "admin"),
  getMovimientos
);

// Obtener movimientos de un producto
router.get(
  "/movimientos/producto/:productoId",
  verificarToken,
  permitirRoles("cocina", "admin"),
  getMovimientosPorProducto
);

// Registrar entrada o salida
router.post(
  "/movimientos",
  verificarToken,
  permitirRoles("cocina", "admin"),
  registrarMovimiento
);

export default router;
