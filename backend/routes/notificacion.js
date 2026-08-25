import express from "express";
import {
    crearNotificacion,
    getNotificaciones,
    getNotificacionPorId,
    marcarComoLeida,
    marcarTodasComoLeidas,
    eliminarNotificacion
} from "../controllers/notificacion.js";
import { verificarToken } from "../middlewares/auth.js";

const router = express.Router();

router.get("/", verificarToken, getNotificaciones);
router.get("/:id", verificarToken, getNotificacionPorId);
router.post("/", verificarToken, crearNotificacion);
router.put("/:id/leida", verificarToken, marcarComoLeida);
router.put("/leidas/todas", verificarToken, marcarTodasComoLeidas);
router.delete("/:id", verificarToken, eliminarNotificacion);

export default router;