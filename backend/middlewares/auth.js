
import jwt from 'jsonwebtoken';
import users from '../models/user.js';

// VERIFICA EL TOKEN Y CONSULTA EL USUARIO ACTUALIZADO EN BD
export const verificarToken = async (req, res, next) => {
    try {
        const authHeader = req.headers["authorization"];

        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            return res.status(401).json({
                message: "Token requerido, debe loguearse"
            });
        }

        const token = authHeader.split(" ")[1];

        // DECODIFICA Y VERIFICA EL TOKEN
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // CONSULTA EL USUARIO ACTUALIZADO EN LA BD
        const usuario = await users.findById(decoded.id).select("-password");

        if (!usuario) {
            return res.status(401).json({
                message: "Usuario no encontrado"
            });
        }

        // GUARDAMOS EL USUARIO COMPLETO EN REQ
        // PARA USARLO EN LOS CONTROLADORES
        req.usuario = usuario;

        next();

    } catch (error) {

        if (error.name === "TokenExpiredError") {
            return res.status(401).json({
                message: "Token expirado"
            });
        }

        if (error.name === "JsonWebTokenError") {
            return res.status(401).json({
                message: "Token inválido"
            });
        }

        console.error("Error verificando token:", error);

        return res.status(500).json({
            message: "Error en el servidor"
        });
    }
};

// SOLO ADMINISTRADORES
export const soloAdmin = (req, res, next) => {
    if (req.usuario?.rol !== "admin") {
        return res.status(403).json({
            message: "Acceso denegado. Solo administradores."
        });
    }

    next();
};

// SOLO USUARIOS
export const soloUser = (req, res, next) => {
    if (req.usuario?.rol !== "user") {
        return res.status(403).json({
            message: "Acceso denegado. Solo usuarios."
        });
    }

    next();
};

// SOLO MESEROS
export const soloMesero = (req, res, next) => {
    if (req.usuario?.rol !== "mesero") {
        return res.status(403).json({
            message: "Acceso denegado. Solo meseros."
        });
    }

    next();
};

// SOLO COCINA
export const soloCocina = (req, res, next) => {
    if (req.usuario?.rol !== "cocina") {
        return res.status(403).json({
            message: "Acceso denegado. Solo personal de cocina."
        });
    }

    next();
};

// PERMITE VARIOS ROLES A LA VEZ
export const permitirRoles = (...rolesPermitidos) => {
    return (req, res, next) => {

        if (!rolesPermitidos.includes(req.usuario?.rol)) {
            return res.status(403).json({
                message: `Acceso denegado. Roles permitidos: ${rolesPermitidos.join(", ")}.`
            });
        }

        next();
    };
};

