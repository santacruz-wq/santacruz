import express from "express";
import {
    crearResena,
    getResenas,
    getResenasPorProducto,
    getResenaPorId,
    actualizarResena,
    eliminarResena
} from "../controllers/resena.js";
import { soloAdmin, verificarToken } from "../middlewares/auth.js";

const router = express.Router();

router.get("/", getResenas);
router.get("/producto/:productoId", getResenasPorProducto);
router.get("/:id", getResenaPorId);
router.post("/", verificarToken, crearResena);
router.put("/:id", verificarToken, actualizarResena);
router.delete("/:id", verificarToken,soloAdmin, eliminarResena);

export default router;