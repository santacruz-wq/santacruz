import express from "express";
import {
    crearResena,
    getResenas,
    getResenasPorProducto,
    getResenaPorId,
    actualizarResena,
    eliminarResena
} from "../controllers/resena.js";
import { soloUsuario, verificarToken } from "../middlewares/auth.js";

const router = express.Router();

router.get("/", getResenas);
router.get("/producto/:productoId", getResenasPorProducto);
router.get("/:id", getResenaPorId);
router.post("/", verificarToken, soloUsuario, crearResena);
router.put("/:id", verificarToken, soloUsuario, actualizarResena);
router.delete("/:id", verificarToken, eliminarResena);

export default router;