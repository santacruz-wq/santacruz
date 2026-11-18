
import bcrypt from 'bcrypt';
import user from '../models/user.js';
import { crearTokensSesion } from './sesion.js';

export const loginUsers = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                message: 'Por favor, ingrese su correo electrónico y contraseña'
            });
        }

        const correoLimpio = email.trim().toLowerCase();

        const existeUser = await user.findOne({
            email: correoLimpio
        });

        if (!existeUser) {
            return res.status(400).json({
                message: 'Usuario no encontrado'
            });
        }

        // BLOQUEAR CUENTAS ELIMINADAS
        if (existeUser.cuentaEliminada) {
            return res.status(403).json({
                message: 'Esta cuenta fue eliminada. Puedes registrarte nuevamente.'
            });
        }

        if (!existeUser.isVerified) {
            return res.status(403).json({
                message: 'Tu cuenta no está verificada. Ingresa el código enviado a tu correo antes de iniciar sesión.'
            });
        }

        if (!existeUser.activo) {
            return res.status(403).json({
                message: 'Usuario deshabilitado, contacta al administrador'
            });
        }

        if (!existeUser.password) {
            return res.status(400).json({
                message: 'Esta cuenta no tiene una contraseña local. Inicia sesión con Google.'
            });
        }

        const esvalida = await bcrypt.compare(
            password,
            existeUser.password
        );

        if (!esvalida) {
            return res.status(400).json({
                message: 'Contraseña incorrecta'
            });
        }

        const { token, refreshToken } =
            await crearTokensSesion(existeUser);

        return res.status(200).json({
            message: 'inicio de sesion exitoso',
            token,
            refreshToken,
            usuario: {
                _id: existeUser._id,
                nombre: existeUser.nombre,
                email: existeUser.email,
                rol: existeUser.rol,
                activo: existeUser.activo,
                avatar: existeUser.avatar,
                createdAt: existeUser.createdAt
            }
        });
    } catch (error) {
        console.error('Error en login:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};
