
import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";

import { verificarToken } from "../middlewares/auth.js";

import {
    obtenerMiPerfil,
    actualizarMiPerfil,
    cambiarMiPassword,
    actualizarMiAvatar,
} from "../controllers/perfil.js";

const router = express.Router();

const carpetaPerfiles = path.join(
    process.cwd(),
    "uploads",
    "perfiles",
);

fs.mkdirSync(carpetaPerfiles, { recursive: true });

const almacenamiento = multer.diskStorage({
    destination: (_req, _file, callback) => {
        callback(null, carpetaPerfiles);
    },

    filename: (_req, file, callback) => {
        const extension = path.extname(file.originalname).toLowerCase();

        callback(
            null,
            `${Date.now()}-${Math.round(Math.random() * 1e9)}${extension}`,
        );
    },
});

const subirFoto = multer({
    storage: almacenamiento,

    limits: {
        fileSize: 5 * 1024 * 1024,
    },

    fileFilter: (_req, file, callback) => {
        const tiposPermitidos = [
            "image/jpeg",
            "image/png",
            "image/webp",
        ];

        if (!tiposPermitidos.includes(file.mimetype)) {
            return callback(
                new Error("La foto debe ser JPG, PNG o WEBP"),
            );
        }

        callback(null, true);
    },
});

// Todos los roles necesitan una sesión válida.
router.use(verificarToken);

// Consultar los datos del perfil propio.
router.get("/yo", obtenerMiPerfil);

// Actualizar nombre y correo del perfil propio.
router.put("/yo", actualizarMiPerfil);

// Cambiar la contraseña propia.
router.patch("/yo/password", cambiarMiPassword);

// Subir o cambiar la foto de perfil propia.
router.post(
    "/yo/avatar",
    (req, res, next) => {
        subirFoto.single("avatar")(req, res, (error) => {
            if (!error) {
                return next();
            }

            return res.status(400).json({
                success: false,
                message:
                    error.message ||
                    "No se pudo recibir la imagen",
            });
        });
    },
    actualizarMiAvatar,
);

export default router;
