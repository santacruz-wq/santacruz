import express from "express";
import {
    crearResena,
    getResenas,
    getResenasPorProducto,
    getResenaPorId,
    actualizarResena,
    eliminarResena
} from "../controllers/resena.js";
import { verificarToken } from "../middlewares/auth.js";

const router = express.Router();

router.get("/", verificarToken, getResenas);
router.get("/producto/:productoId", verificarToken, getResenasPorProducto);
router.get("/:id", verificarToken, getResenaPorId);
router.post("/", verificarToken, crearResena);
router.put("/:id", verificarToken, actualizarResena);
router.delete("/:id", verificarToken, eliminarResena);

export default router;