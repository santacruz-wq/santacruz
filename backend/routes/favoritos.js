import express from "express";
import {
    agregarFavorito,
    getFavoritos,
    verificarFavorito,
    eliminarFavorito
} from "../controllers/favoritos.js";
import { verificarToken } from "../middlewares/auth.js";

const router = express.Router();

router.get("/", verificarToken, getFavoritos);
router.get("/verificar/:productoId", verificarToken, verificarFavorito);
router.post("/", verificarToken, agregarFavorito);
router.delete("/:productoId", verificarToken, eliminarFavorito);

export default router;