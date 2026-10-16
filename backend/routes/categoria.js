import { Router } from "express";

import {
  getCategorias,
  getCategoriaPorId,
  crearCategoria,
  actualizarCategoria,
  eliminarCategoria,
  cambiarEstadoCategoria,
} from "../controllers/categoria.js";

import { verificarToken, soloAdmin } from "../middlewares/auth.js";

const router = Router();

// Consultar categorías
router.get("/", getCategorias);
router.get("/:id", getCategoriaPorId);

// Crear categoría
router.post("/", verificarToken, soloAdmin, crearCategoria);

// Actualizar nombre y descripción
router.put("/:id", verificarToken, soloAdmin, actualizarCategoria);

// Cambiar estado: activar o desactivar
router.patch(
  "/:id/estado",
  verificarToken,
  soloAdmin,
  cambiarEstadoCategoria
);

// Desactivar categoría (se conserva la ruta anterior)
router.delete("/:id", verificarToken, soloAdmin, eliminarCategoria);

export default router;