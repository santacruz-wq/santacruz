import express from "express";

import {
    listarUsuarios,
    cambiarRolUsuario,
    cambiarEstadoUsuario,
    cambiarRolAdministrador,
    cambiarEstadoAdministrador,
} from "../controllers/usuarios.js";

import {
    verificarToken,
    soloAdmin,
} from "../middlewares/auth.js";

const router = express.Router();

// Todas las rutas requieren sesión válida y rol de administrador.
router.use(verificarToken, soloAdmin);

// Gestión de usuarios normales.
router.get("/", listarUsuarios);
router.patch("/:id/rol", cambiarRolUsuario);
router.patch("/:id/estado", cambiarEstadoUsuario);

// Gestión independiente de administradores.
router.patch("/administradores/:id/rol", cambiarRolAdministrador);
router.patch("/administradores/:id/estado", cambiarEstadoAdministrador);

export default router;