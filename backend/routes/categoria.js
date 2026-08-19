import { Router } from "express";
import {
    getCategorias,
    getCategoriaPorId,
    crearCategoria,
    actualizarCategoria,
    eliminarCategoria
} from "../controllers/categoria.js";
import { verificarToken, soloAdmin } from "../middlewares/auth.js";

const router = Router();

//RUTAS PUBLICAS DE LECTURA (SOLO REQUIEREN TOKEN VALIDO)
router.get("/", getCategorias);
router.get("/:id", getCategoriaPorId);

//RUTAS SOLO ADMIN
router.post("/", verificarToken, soloAdmin, crearCategoria);
router.put("/:id", verificarToken, soloAdmin, actualizarCategoria);
router.delete("/:id", verificarToken, soloAdmin, eliminarCategoria);

export default router;