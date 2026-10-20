
import mongoose from "mongoose";
import User from "../models/user.js";

// LISTAR USUARIOS: SOLO CUENTAS VERIFICADAS
export const listarUsuarios = async (req, res) => {
    try {
        const usuarios = await User.find({
            isVerified: true,
        })
            .select(
                "-password -codigoRecuperacion -codigoExpiracion " +
                "-codigoVerificacion -codigoVerificacionExpiracion -googleId"
            )
            .sort({ createdAt: -1 })
            .lean();

        return res.status(200).json({
            success: true,
            total: usuarios.length,
            usuarios,
        });
    } catch (error) {
        console.error("Error listando usuarios:", error);

        return res.status(500).json({
            success: false,
            message: "Error al consultar los usuarios",
        });
    }
};

// CAMBIAR ROL DE USUARIOS NORMALES
export const cambiarRolUsuario = async (req, res) => {
    try {
        const { id } = req.params;
        const { rol } = req.body;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({
                success: false,
                message: "El ID del usuario no es válido",
            });
        }

        if (!["usuario", "mesero", "cocina"].includes(rol)) {
            return res.status(400).json({
                success: false,
                message: "El rol debe ser usuario, mesero o cocina",
            });
        }

        const usuario = await User.findById(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        if (usuario._id.equals(req.usuario._id)) {
            return res.status(403).json({
                success: false,
                message: "No puedes cambiar tu propio rol",
            });
        }

        if (usuario.rol === "admin") {
            return res.status(403).json({
                success: false,
                message:
                    "Los administradores se gestionan desde su sección independiente",
            });
        }

        usuario.rol = rol;
        await usuario.save();

        return res.status(200).json({
            success: true,
            message: "Rol actualizado correctamente",
            usuario: {
                _id: usuario._id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
                activo: usuario.activo,
                isVerified: usuario.isVerified,
            },
        });
    } catch (error) {
        console.error("Error cambiando rol:", error);

        return res.status(500).json({
            success: false,
            message: "Error al cambiar el rol",
        });
    }
};

// ACTIVAR O DESACTIVAR CUENTAS DE USUARIOS NORMALES
export const cambiarEstadoUsuario = async (req, res) => {
    try {
        const { id } = req.params;
        const { activo } = req.body;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({
                success: false,
                message: "El ID del usuario no es válido",
            });
        }

        if (typeof activo !== "boolean") {
            return res.status(400).json({
                success: false,
                message: "El estado debe ser true o false",
            });
        }

        const usuario = await User.findById(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        if (usuario._id.equals(req.usuario._id)) {
            return res.status(403).json({
                success: false,
                message:
                    "No puedes desactivar tu propia cuenta desde esta sección",
            });
        }

        if (usuario.rol === "admin") {
            return res.status(403).json({
                success: false,
                message:
                    "Los administradores se gestionan desde su sección independiente",
            });
        }

        usuario.activo = activo;
        await usuario.save();

        return res.status(200).json({
            success: true,
            message: activo
                ? "Cuenta activada correctamente"
                : "Cuenta desactivada correctamente",
            usuario: {
                _id: usuario._id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
                activo: usuario.activo,
                isVerified: usuario.isVerified,
            },
        });
    } catch (error) {
        console.error("Error cambiando estado:", error);

        return res.status(500).json({
            success: false,
            message: "Error al cambiar el estado de la cuenta",
        });
    }
};

// VERIFICAR LA CONTRASEÑA DEL ADMINISTRADOR AUTENTICADO
const verificarPasswordAdministrador = async (req, password) => {
    if (typeof password !== "string" || !password.trim()) {
        return {
            valido: false,
            status: 400,
            message: "Debes ingresar tu contraseña de administrador",
        };
    }

    const administrador = await User.findById(req.usuario._id)
        .select("+password");

    if (!administrador || administrador.rol !== "admin") {
        return {
            valido: false,
            status: 403,
            message:
                "La cuenta autenticada ya no tiene permisos de administrador",
        };
    }

    // Las cuentas que solo usan Google pueden no tener contraseña local.
    if (!administrador.password) {
        return {
            valido: false,
            status: 400,
            message:
                "Esta cuenta no tiene contraseña local. Configura una antes de continuar",
        };
    }

    const coincide = await administrador.compararPassword(password);

    if (!coincide) {
        return {
            valido: false,
            status: 401,
            message: "La contraseña de administrador es incorrecta",
        };
    }

    return {
        valido: true,
        administrador,
    };
};

// GESTIONAR ROL DE ADMINISTRADOR CON CONFIRMACIÓN DE CONTRASEÑA
export const cambiarRolAdministrador = async (req, res) => {
    try {
        const { id } = req.params;
        const { rol, password } = req.body;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({
                success: false,
                message: "El ID del usuario no es válido",
            });
        }

        if (!["admin", "usuario", "mesero", "cocina"].includes(rol)) {
            return res.status(400).json({
                success: false,
                message: "El rol solicitado no es válido",
            });
        }

        const usuario = await User.findById(id);

        if (!usuario) {
            return res.status(404).json({
                success: false,
                message: "Usuario no encontrado",
            });
        }

        if (usuario._id.equals(req.usuario._id)) {
            return res.status(403).json({
                success: false,
                message:
                    "No puedes cambiar tu propio rol de administrador",
            });
        }

        if (usuario.rol === rol) {
            return res.status(400).json({
                success: false,
                message: "La cuenta ya tiene ese rol",
            });
        }

        // Verificar la contraseña del administrador que realiza la acción.
        const verificacion = await verificarPasswordAdministrador(
            req,
            password,
        );

        if (!verificacion.valido) {
            return res.status(verificacion.status).json({
                success: false,
                message: verificacion.message,
            });
        }

        // No permitir quitar el último administrador activo.
        if (usuario.rol === "admin" && rol !== "admin") {
            const otrosAdminsActivos = await User.countDocuments({
                rol: "admin",
                activo: true,
                _id: { $ne: usuario._id },
            });

            if (otrosAdminsActivos === 0) {
                return res.status(409).json({
                    success: false,
                    message:
                        "No puedes quitar el rol al último administrador activo",
                });
            }
        }

        usuario.rol = rol;
        await usuario.save();

        return res.status(200).json({
            success: true,
            message: rol === "admin"
                ? "Administrador asignado correctamente"
                : "Rol de administrador retirado correctamente",
            usuario: {
                _id: usuario._id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
                activo: usuario.activo,
                isVerified: usuario.isVerified,
            },
        });
    } catch (error) {
        console.error("Error gestionando administrador:", error);

        return res.status(500).json({
            success: false,
            message: "Error al gestionar el rol de administrador",
        });
    }
};

// ACTIVAR O DESACTIVAR CUENTAS DE ADMINISTRADORES
export const cambiarEstadoAdministrador = async (req, res) => {
    try {
        const { id } = req.params;
        const { activo } = req.body;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({
                success: false,
                message: "El ID del usuario no es válido",
            });
        }

        if (typeof activo !== "boolean") {
            return res.status(400).json({
                success: false,
                message: "El estado debe ser true o false",
            });
        }

        const usuario = await User.findById(id);

        if (!usuario || usuario.rol !== "admin") {
            return res.status(404).json({
                success: false,
                message: "Administrador no encontrado",
            });
        }

        if (usuario._id.equals(req.usuario._id)) {
            return res.status(403).json({
                success: false,
                message: "No puedes desactivar tu propia cuenta",
            });
        }

        if (usuario.activo && !activo) {
            const otrosAdminsActivos = await User.countDocuments({
                rol: "admin",
                activo: true,
                _id: { $ne: usuario._id },
            });

            if (otrosAdminsActivos === 0) {
                return res.status(409).json({
                    success: false,
                    message:
                        "No puedes desactivar al último administrador activo",
                });
            }
        }

        usuario.activo = activo;
        await usuario.save();

        return res.status(200).json({
            success: true,
            message: activo
                ? "Administrador activado correctamente"
                : "Administrador desactivado correctamente",
            usuario: {
                _id: usuario._id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
                activo: usuario.activo,
                isVerified: usuario.isVerified,
            },
        });
    } catch (error) {
        console.error(
            "Error cambiando estado del administrador:",
            error,
        );

        return res.status(500).json({
            success: false,
            message: "Error al cambiar el estado del administrador",
        });
    }
};
