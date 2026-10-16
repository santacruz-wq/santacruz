
import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";

import {
    verificarToken,
    soloAdmin,
} from "../middlewares/auth.js";

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

router.use(verificarToken, soloAdmin);

router.get("/yo", obtenerMiPerfil);
router.put("/yo", actualizarMiPerfil);
router.patch("/yo/password", cambiarMiPassword);

router.post(
    "/yo/avatar",
    (req, res, next) => {
        subirFoto.single("avatar")(req, res, (error) => {
            if (!error) return next();

            const status = error instanceof multer.MulterError
                ? 400
                : 400;

            return res.status(status).json({
                success: false,
                message: error.message || "No se pudo recibir la imagen",
            });
        });
    },
    actualizarMiAvatar,
);

export default router;
