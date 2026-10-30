
import User from "../models/user.js";
import cloudinary from "../config/cloudinary.js";

// Datos públicos del usuario autenticado.
const datosPerfil = (usuario) => ({
    _id: usuario._id,
    nombre: usuario.nombre,
    email: usuario.email,
    rol: usuario.rol,
    activo: usuario.activo,
    isVerified: usuario.isVerified,
    avatar: usuario.avatar || "",
});

// CONSULTAR PERFIL PROPIO
export const obtenerMiPerfil = async (req, res) => {
    try {
        const usuario = await User.findById(req.usuario._id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        return res.status(200).json({
            success: true,
            usuario: datosPerfil(usuario),
        });
    } catch (error) {
        console.error("Error consultando perfil:", error);

        return res.status(500).json({
            success: false,
            message: "No se pudo consultar el perfil",
        });
    }
};

// ACTUALIZAR NOMBRE Y CORREO PROPIOS
export const actualizarMiPerfil = async (req, res) => {
    try {
        const { nombre, email } = req.body;

        if (
            typeof nombre !== "string" ||
            !nombre.trim() ||
            typeof email !== "string" ||
            !email.trim()
        ) {
            return res.status(400).json({
                success: false,
                message: "El nombre y el correo son obligatorios",
            });
        }

        const nombreLimpio = nombre.trim();
        const emailLimpio = email.trim().toLowerCase();

        if (nombreLimpio.length > 100) {
            return res.status(400).json({
                success: false,
                message: "El nombre no puede superar 100 caracteres",
            });
        }

        const formatoEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!formatoEmail.test(emailLimpio)) {
            return res.status(400).json({
                success: false,
                message: "El correo electrónico no es válido",
            });
        }

        const usuario = await User.findById(req.usuario._id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        const correoOcupado = await User.findOne({
            email: emailLimpio,
            _id: { $ne: usuario._id },
        });

        if (correoOcupado) {
            return res.status(409).json({
                success: false,
                message: "Ese correo ya está registrado",
            });
        }

        usuario.nombre = nombreLimpio;
        usuario.email = emailLimpio;

        await usuario.save();

        return res.status(200).json({
            success: true,
            message: "Perfil actualizado correctamente",
            usuario: datosPerfil(usuario),
        });
    } catch (error) {
        console.error("Error actualizando perfil:", error);

        if (error.code === 11000) {
            return res.status(409).json({
                success: false,
                message: "Ese correo ya está registrado",
            });
        }

        return res.status(500).json({
            success: false,
            message: "No se pudo actualizar el perfil",
        });
    }
};

// CAMBIAR CONTRASEÑA DESDE EL PERFIL
export const cambiarMiPassword = async (req, res) => {
    try {
        const {
            passwordActual,
            nuevaPassword,
            confirmarPassword,
        } = req.body;

        if (
            typeof passwordActual !== "string" ||
            typeof nuevaPassword !== "string" ||
            typeof confirmarPassword !== "string" ||
            !passwordActual ||
            !nuevaPassword ||
            !confirmarPassword
        ) {
            return res.status(400).json({
                success: false,
                message: "Completa todos los campos de contraseña",
            });
        }

        if (nuevaPassword.length < 6) {
            return res.status(400).json({
                success: false,
                message: "La nueva contraseña debe tener al menos 6 caracteres",
            });
        }

        if (nuevaPassword !== confirmarPassword) {
            return res.status(400).json({
                success: false,
                message: "Las contraseñas nuevas no coinciden",
            });
        }

        const usuario = await User.findById(req.usuario._id)
            .select("+password");

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        if (!usuario.password) {
            return res.status(400).json({
                success: false,
                message: "Esta cuenta no tiene contraseña local. Usa la recuperación de contraseña para configurarla.",
            });
        }

        const coincide = await usuario.compararPassword(passwordActual);

        if (!coincide) {
            return res.status(401).json({
                success: false,
                message: "La contraseña actual es incorrecta",
            });
        }

        const esLaMisma = await usuario.compararPassword(nuevaPassword);

        if (esLaMisma) {
            return res.status(400).json({
                success: false,
                message: "La nueva contraseña debe ser diferente a la actual",
            });
        }

        usuario.password = nuevaPassword;
        await usuario.save();

        return res.status(200).json({
            success: true,
            message: "Contraseña actualizada correctamente",
        });
    } catch (error) {
        console.error("Error cambiando contraseña:", error);

        return res.status(500).json({
            success: false,
            message: "No se pudo cambiar la contraseña",
        });
    }
};

// GUARDAR LA FOTO DE PERFIL EN CLOUDINARY
export const actualizarMiAvatar = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: "Selecciona una imagen",
            });
        }

        const usuario = await User.findById(req.usuario._id);

        if (!usuario) {
            // La imagen ya fue subida a Cloudinary.
            await cloudinary.uploader.destroy(req.file.filename).catch(
                (error) => {
                    console.error(
                        "No se pudo eliminar el avatar sin usuario:",
                        error,
                    );
                },
            );

            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        const avatarAnterior = usuario.avatar;

        // CloudinaryStorage proporciona la URL pública en req.file.path.
        usuario.avatar = req.file.path;

        await usuario.save();

        // Eliminar la foto anterior solo si es un recurso de Cloudinary
        // de nuestra carpeta de perfiles.
        if (
            avatarAnterior &&
            /^https?:\/\/res\.cloudinary\.com\//i.test(avatarAnterior)
        ) {
            try {
                const urlAnterior = new URL(avatarAnterior);
                const partes = urlAnterior.pathname.split("/");
                const indiceUpload = partes.indexOf("upload");

                if (indiceUpload !== -1) {
                    const partesPublicId = partes.slice(indiceUpload + 1);

                    // Ignorar versiones v123456789/ y conservar carpetas/nombre.
                    if (
                        partesPublicId.length > 0 &&
                        /^v\d+$/.test(partesPublicId[0])
                    ) {
                        partesPublicId.shift();
                    }

                    const ultimo = partesPublicId.length - 1;

                    if (ultimo >= 0) {
                        partesPublicId[ultimo] = partesPublicId[ultimo]
                            .replace(/\.[^.]+$/, "");
                    }

                    const publicId = partesPublicId.join("/");

                    if (publicId.startsWith("santacruz-plazuela/perfiles/")) {
                        await cloudinary.uploader.destroy(publicId);
                    }
                }
            } catch (error) {
                // No se revierte la actualización si falla la limpieza.
                console.error(
                    "No se pudo eliminar el avatar anterior de Cloudinary:",
                    error,
                );
            }
        }

        return res.status(200).json({
            success: true,
            message: "Foto de perfil actualizada correctamente",
            usuario: datosPerfil(usuario),
        });
    } catch (error) {
        console.error("Error actualizando foto:", error);

        return res.status(500).json({
            success: false,
            message: "No se pudo actualizar la foto de perfil",
        });
    }
};
