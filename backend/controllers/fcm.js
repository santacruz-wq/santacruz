
import User from '../models/user.js';
import { fcmMessaging } from '../services/firebaseAdmin.js';

// REGISTRAR O ACTUALIZAR TOKEN FCM
export const registrarTokenFCM = async (req, res) => {
    try {
        const { token, platform = 'android' } = req.body;

        if (!token || typeof token !== 'string' || !token.trim()) {
            return res.status(400).json({
                message: 'El token FCM es obligatorio'
            });
        }

        if (platform !== 'android') {
            return res.status(400).json({
                message: 'Por ahora solo se admiten dispositivos Android'
            });
        }

        const tokenLimpio = token.trim();

        // Evitar que el mismo dispositivo quede asociado a varias cuentas.
        await User.updateMany(
            { 'fcmTokens.token': tokenLimpio },
            { $pull: { fcmTokens: { token: tokenLimpio } } }
        );

        // Registrar el dispositivo en la cuenta autenticada.
        await User.findByIdAndUpdate(
            req.usuario._id,
            {
                $push: {
                    fcmTokens: {
                        token: tokenLimpio,
                        platform: 'android',
                        updatedAt: new Date()
                    }
                }
            }
        );

        return res.status(200).json({
            message: 'Dispositivo registrado correctamente'
        });

    } catch (error) {
        console.error('Error al registrar token FCM:', error);

        return res.status(500).json({
            message: 'Error al registrar el dispositivo'
        });
    }
};

// ELIMINAR TOKEN FCM DE LA CUENTA AUTENTICADA
export const eliminarTokenFCM = async (req, res) => {
    try {
        const { token } = req.body;

        if (!token || typeof token !== 'string') {
            return res.status(400).json({
                message: 'El token FCM es obligatorio'
            });
        }

        await User.updateOne(
            { _id: req.usuario._id },
            {
                $pull: {
                    fcmTokens: { token: token.trim() }
                }
            }
        );

        return res.status(200).json({
            message: 'Dispositivo desvinculado correctamente'
        });

    } catch (error) {
        console.error('Error al eliminar token FCM:', error);

        return res.status(500).json({
            message: 'Error al desvincular dispositivo'
        });
    }
};

// ENVIAR NOTIFICACIONES A USUARIOS SEGÚN SU ROL
export const enviarNotificacionPorRol = async ({
    roles,
    titulo,
    mensaje,
    data = {}
}) => {
    try {
        if (!Array.isArray(roles) || roles.length === 0) {
            throw new Error('Debes indicar al menos un rol');
        }

        const usuarios = await User.find({
            rol: { $in: roles },
            activo: true,
            'fcmTokens.0': { $exists: true }
        }).select('fcmTokens');

        const tokens = [
            ...new Set(
                usuarios.flatMap(usuario =>
                    usuario.fcmTokens.map(dispositivo => dispositivo.token)
                )
            )
        ];

        if (tokens.length === 0) {
            console.log('FCM: No hay dispositivos registrados para:', roles);

            return {
                success: true,
                enviados: 0,
                fallidos: 0
            };
        }

        const datos = Object.fromEntries(
            Object.entries(data).map(([clave, valor]) => [
                clave,
                String(valor)
            ])
        );

        let enviados = 0;
        let fallidos = 0;
        const tokensInvalidos = [];

        // Firebase admite hasta 500 destinatarios por envío.
        for (let i = 0; i < tokens.length; i += 500) {
            const grupoTokens = tokens.slice(i, i + 500);

            const respuesta = await fcmMessaging.sendEachForMulticast({
                tokens: grupoTokens,
                notification: {
                    title: titulo,
                    body: mensaje
                },
                data: datos,
                android: {
                    priority: 'high',
                    notification: {
                        channelId: 'pedidos',
                        sound: 'default'
                    }
                }
            });

            enviados += respuesta.successCount;
            fallidos += respuesta.failureCount;

            respuesta.responses.forEach((resultado, indice) => {
                if (
                    !resultado.success &&
                    [
                        'messaging/registration-token-not-registered',
                        'messaging/invalid-registration-token'
                    ].includes(resultado.error?.code)
                ) {
                    tokensInvalidos.push(grupoTokens[indice]);
                }
            });
        }

        // Limpiar tokens que ya no son válidos.
        if (tokensInvalidos.length > 0) {
            await User.updateMany(
                { 'fcmTokens.token': { $in: tokensInvalidos } },
                {
                    $pull: {
                        fcmTokens: {
                            token: { $in: tokensInvalidos }
                        }
                    }
                }
            );
        }

        console.log(
            `FCM: ${enviados} enviadas, ${fallidos} fallidas`
        );

        return {
            success: true,
            enviados,
            fallidos
        };

    } catch (error) {
        console.error('Error enviando notificaciones FCM:', error);

        return {
            success: false,
            error: error.message
        };
    }
};
