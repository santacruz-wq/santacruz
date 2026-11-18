import mongoose from "mongoose";
import { OAuth2Client } from "google-auth-library";

import User from "../models/user.js";
import Favoritos from "../models/favoritos.js";
import Notificacion from "../models/notificacion.js"; // VERIFICA LA RUTA Y EL NOMBRE DEL ARCHIVO
import Orden from "../models/ordenes.js";
import cloudinary from "../config/cloudinary.js";

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// DATOS PÚBLICOS DEL USUARIO AUTENTICADO
const datosPerfil = (usuario) => ({
    _id: usuario._id,
    nombre: usuario.nombre,
    email: usuario.email,
    rol: usuario.rol,
    activo: usuario.activo,
    isVerified: usuario.isVerified,
    avatar: usuario.avatar || "",
});

// OBTENER EL PUBLIC ID DE UN AVATAR DE NUESTRA CARPETA
const obtenerPublicIdAvatar = (avatar) => {
    try {
        if (
            !avatar ||
            !/^https?:\/\/res\.cloudinary\.com\//i.test(avatar)
        ) {
            return null;
        }

        const url = new URL(avatar);
        const partes = url.pathname.split("/");
        const indiceUpload = partes.indexOf("upload");

        if (indiceUpload === -1) {
            return null;
        }

        const partesPublicId = partes.slice(indiceUpload + 1);

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

        if (!publicId.startsWith("santacruz-plazuela/perfiles/")) {
            return null;
        }

        return publicId;
    } catch (error) {
        console.error("Error obteniendo public ID del avatar:", error);
        return null;
    }
};

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

        if (!usuario || usuario.cuentaEliminada) {
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

        // SE USA 400 Y NO 401 PARA QUE EL CLIENTE NO LO TOME COMO SESIÓN VENCIDA
        if (!coincide) {
            return res.status(400).json({
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

        usuario.avatar = req.file.path;

        await usuario.save();

        const publicIdAnterior = obtenerPublicIdAvatar(avatarAnterior);

        if (publicIdAnterior) {
            try {
                await cloudinary.uploader.destroy(publicIdAnterior);
            } catch (error) {
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

// ELIMINAR CUENTA PROPIA Y ANONIMIZAR SU INFORMACIÓN
export const eliminarMiCuenta = async (req, res) => {
    let session;

    try {
        const { passwordActual, idToken } = req.body;

        const usuario = await User.findById(req.usuario._id)
            .select("+password");

        if (!usuario || usuario.cuentaEliminada) {
            return res.status(404).json({
                success: false,
                message: "La cuenta no existe o ya fue eliminada",
            });
        }

        // VERIFICAR IDENTIDAD CON CONTRASEÑA O GOOGLE
        // SE USA 400 Y NO 401 PARA QUE EL CLIENTE NO LO TOME COMO SESIÓN VENCIDA
        if (usuario.password) {
            if (
                typeof passwordActual !== "string" ||
                !passwordActual
            ) {
                return res.status(400).json({
                    success: false,
                    message: "Debes ingresar tu contraseña actual para eliminar la cuenta",
                });
            }

            const passwordCorrecta =
                await usuario.compararPassword(passwordActual);

            if (!passwordCorrecta) {
                return res.status(400).json({
                    success: false,
                    message: "La contraseña actual es incorrecta",
                });
            }
        } else if (usuario.googleId) {
            if (typeof idToken !== "string" || !idToken.trim()) {
                return res.status(400).json({
                    success: false,
                    message: "Debes volver a autenticarte con Google para eliminar la cuenta",
                });
            }

            if (!process.env.GOOGLE_CLIENT_ID) {
                return res.status(500).json({
                    success: false,
                    message: "No está configurada la autenticación de Google en el servidor",
                });
            }

            let payload;

            try {
                const ticket = await googleClient.verifyIdToken({
                    idToken,
                    audience: process.env.GOOGLE_CLIENT_ID,
                });

                payload = ticket.getPayload();
            } catch (error) {
                return res.status(400).json({
                    success: false,
                    message: "La autenticación de Google no es válida o ha expirado",
                });
            }

            if (
                !payload ||
                payload.sub !== usuario.googleId ||
                payload.email_verified !== true ||
                payload.email?.toLowerCase() !== usuario.email
            ) {
                return res.status(400).json({
                    success: false,
                    message: "La cuenta de Google no coincide con esta cuenta",
                });
            }
        } else {
            return res.status(400).json({
                success: false,
                message: "No se pudo verificar la identidad de esta cuenta",
            });
        }

        // PROTEGER AL ÚLTIMO ADMINISTRADOR ACTIVO
        if (usuario.rol === "admin" && usuario.activo) {
            const otrosAdministradores = await User.countDocuments({
                rol: "admin",
                activo: true,
                cuentaEliminada: { $ne: true },
                _id: { $ne: usuario._id },
            });

            if (otrosAdministradores === 0) {
                return res.status(400).json({
                    success: false,
                    message: "No puedes eliminar la cuenta porque eres el último administrador activo. Primero debe existir otro administrador activo.",
                });
            }
        }

        // NO PERMITIR ELIMINAR UN MESERO CON PEDIDOS SIN FINALIZAR
        if (usuario.rol === "mesero") {
            const pedidosPendientes = await Orden.exists({
                mesero: usuario._id,
                estado: { $nin: ["pagado", "cancelado"] },
            });

            if (pedidosPendientes) {
                return res.status(400).json({
                    success: false,
                    message: "No puedes eliminar tu cuenta mientras tengas pedidos pendientes. Finaliza o entrega esos pedidos primero.",
                });
            }
        }

        const avatarAnterior = usuario.avatar;

        // ELIMINAR FAVORITOS, NOTIFICACIONES Y ANONIMIZAR EN UNA SOLA TRANSACCIÓN
        session = await mongoose.startSession();

        await session.withTransaction(async () => {
            await Favoritos.deleteMany(
                { usuario: usuario._id },
                { session },
            );

            await Notificacion.deleteMany(
                { usuario: usuario._id },
                { session },
            );

            usuario.nombre = "USUARIO ELIMINADO";
            usuario.email = `eliminado_${usuario._id}@deleted.invalid`;

            usuario.password = undefined;
            usuario.googleId = undefined;

            usuario.avatar = "";
            usuario.activo = false;
            usuario.isVerified = false;
            usuario.cuentaEliminada = true;

            usuario.codigoRecuperacion = null;
            usuario.codigoExpiracion = null;
            usuario.codigoVerificacion = null;
            usuario.codigoVerificacionExpiracion = null;

            usuario.fcmTokens = [];
            usuario.refreshSessions = [];

            await usuario.save({ session });
        });

        // CERRAR LA SESIÓN DE MONGODB
        await session.endSession();
        session = null;

        // ELIMINAR AVATAR DE CLOUDINARY SI PERTENECE A NUESTRA CARPETA
        const publicIdAvatar = obtenerPublicIdAvatar(avatarAnterior);

        if (publicIdAvatar) {
            try {
                await cloudinary.uploader.destroy(publicIdAvatar);
            } catch (error) {
                console.error(
                    "No se pudo eliminar el avatar de Cloudinary:",
                    error,
                );
            }
        }

        return res.status(200).json({
            success: true,
            message: "Tu cuenta fue eliminada correctamente. Tus reseñas y el historial de pedidos se conservaron de forma anonimizada.",
        });
    } catch (error) {
        console.error("Error eliminando cuenta:", error);

        if (error.code === 11000) {
            return res.status(409).json({
                success: false,
                message: "No se pudo anonimizar la cuenta por un conflicto de datos",
            });
        }

        return res.status(500).json({
            success: false,
            message: "No se pudo eliminar la cuenta",
        });
    } finally {
        if (session) {
            await session.endSession().catch((error) => {
                console.error("Error cerrando sesión de MongoDB:", error);
            });
        }
    }
};