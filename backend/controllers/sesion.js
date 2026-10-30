
import crypto from 'node:crypto';
import jwt from 'jsonwebtoken';
import User from '../models/user.js';

const DURACION_REFRESH_MS = 30 * 24 * 60 * 60 * 1000;

const crearHash = (token) =>
    crypto.createHash('sha256').update(token).digest('hex');

export const crearTokensSesion = async (usuario) => {
    if (!process.env.JWT_SECRET) {
        throw new Error('JWT_SECRET no está configurado');
    }

    const ahora = new Date();

    usuario.refreshSessions = (usuario.refreshSessions || []).filter(
        (sesion) => new Date(sesion.expiresAt) > ahora
    );

    const refreshToken = crypto.randomBytes(64).toString('hex');

    usuario.refreshSessions.push({
        tokenHash: crearHash(refreshToken),
        expiresAt: new Date(ahora.getTime() + DURACION_REFRESH_MS)
    });

    await usuario.save();

    const token = jwt.sign(
        {
            id: usuario._id,
            email: usuario.email,
            rol: usuario.rol
        },
        process.env.JWT_SECRET,
        { expiresIn: '1h' }
    );

    return { token, refreshToken };
};

export const renovarSesion = async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (typeof refreshToken !== 'string' || !refreshToken.trim()) {
            return res.status(400).json({
                message: 'Refresh token requerido'
            });
        }

        const tokenHash = crearHash(refreshToken);

        const usuario = await User.findOne({
            'refreshSessions.tokenHash': tokenHash
        });

        if (!usuario) {
            return res.status(401).json({
                message: 'Sesión inválida o expirada. Inicia sesión nuevamente.'
            });
        }

        const ahora = new Date();

        const sesion = usuario.refreshSessions.find(
            (item) => item.tokenHash === tokenHash
        );

        if (!sesion || new Date(sesion.expiresAt) <= ahora) {
            usuario.refreshSessions = usuario.refreshSessions.filter(
                (item) => item.tokenHash !== tokenHash
            );

            await usuario.save();

            return res.status(401).json({
                message: 'Sesión expirada. Inicia sesión nuevamente.'
            });
        }

        if (!usuario.activo || !usuario.isVerified) {
            usuario.refreshSessions = usuario.refreshSessions.filter(
                (item) => item.tokenHash !== tokenHash
            );

            await usuario.save();

            return res.status(403).json({
                message: 'La cuenta está desactivada o no está verificada.'
            });
        }

        // Rotar el refresh token: el anterior deja de ser válido.
        usuario.refreshSessions = usuario.refreshSessions.filter(
            (item) => item.tokenHash !== tokenHash
        );

        const nuevoRefreshToken = crypto.randomBytes(64).toString('hex');

        usuario.refreshSessions.push({
            tokenHash: crearHash(nuevoRefreshToken),
            expiresAt: new Date(ahora.getTime() + DURACION_REFRESH_MS)
        });

        await usuario.save();

        const token = jwt.sign(
            {
                id: usuario._id,
                email: usuario.email,
                rol: usuario.rol
            },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );

        return res.status(200).json({
            token,
            refreshToken: nuevoRefreshToken
        });
    } catch (error) {
        console.error('Error renovando sesión:', error);

        return res.status(500).json({
            message: 'Error al renovar la sesión'
        });
    }
};

export const cerrarSesion = async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (typeof refreshToken === 'string' && refreshToken.trim()) {
            const tokenHash = crearHash(refreshToken);

            await User.updateOne(
                { 'refreshSessions.tokenHash': tokenHash },
                { $pull: { refreshSessions: { tokenHash } } }
            );
        }

        return res.status(200).json({
            message: 'Sesión cerrada correctamente'
        });
    } catch (error) {
        console.error('Error cerrando sesión:', error);

        return res.status(500).json({
            message: 'Error al cerrar la sesión'
        });
    }
};
