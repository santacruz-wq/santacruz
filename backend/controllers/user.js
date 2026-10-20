import user from '../models/user.js';
import RegistroPendiente from '../models/registroPendiente.js';
import { BrevoClient } from "@getbrevo/brevo";
import dotenv from "dotenv";
import { randomInt } from "node:crypto";

dotenv.config();

console.log(
    "BREVO KEY:",
    process.env.BREVO_API_KEY ? "SI existe" : "NO existe/undefined"
);

// CLIENTE DE BREVO
const brevo = new BrevoClient({
    apiKey: process.env.BREVO_API_KEY,
});

// TIEMPOS DE VERIFICACIÓN
const TIEMPO_CODIGO = 15 * 60 * 1000;
const TIEMPO_REGISTRO_TEMPORAL = 24 * 60 * 60 * 1000;

// GENERAR CÓDIGO DE VERIFICACIÓN
const generarCodigo = () => {
    return randomInt(100000, 1000000).toString();
};

// ESCAPAR TEXTO PARA EL HTML DEL CORREO
const escaparHTML = (texto = "") =>
    String(texto).replace(/[&<>"']/g, caracter => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;"
    })[caracter]);


 // ENVIAR CORREO DE VERIFICACIÓN
const enviarCorreoVerificacion = async (
    nombre,
    correo,
    codigo,
    esReenvio = false
) => {
    const nombreSeguro = escaparHTML(nombre);

    const htmlContent = `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificación - Santa Cruz de la Plazuela</title>
</head>

<body style="margin:0; padding:0; background-color:#FAF0E6; font-family:Arial, Helvetica, sans-serif;">

    <div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">
        Tu código de verificación de Santa Cruz de la Plazuela.
    </div>

    <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
        style="background-color:#FAF0E6; padding:30px 12px;">
        <tr>
            <td align="center">

                <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                    style="max-width:560px; background-color:#FFFFFF; border-radius:16px; overflow:hidden;">

                    <!-- ENCABEZADO -->
                    <tr>
                        <td align="center"
                            style="background-color:#3D2314; padding:32px 20px 28px;">

                            <div style="font-size:13px; letter-spacing:4px; color:#E19D55; margin-bottom:12px;">
                                BIENVENIDO A
                            </div>

                            <h1 style="margin:0; color:#FFF8F0; font-size:25px; line-height:1.4; font-weight:bold;">
                                SANTA CRUZ
                                <br>
                                DE LA PLAZUELA
                            </h1>

                            <p style="margin:10px 0 0; color:#E8DCCB; font-size:14px; letter-spacing:2px;">
                                postres y café
                            </p>

                            <div style="width:65px; height:3px; background-color:#C87D32; margin:22px auto 0;"></div>

                        </td>
                    </tr>

                    <!-- CONTENIDO -->
                    <tr>
                        <td style="padding:32px 28px 24px; color:#3D2314;">

                            <h2 style="font-size:23px; line-height:1.4; margin:0 0 22px; color:#3D2314;">
                                ${esReenvio
                                    ? "Tu nuevo código de verificación"
                                    : "¡Gracias por registrarte!"}
                            </h2>

                            <p style="font-size:15px; line-height:1.8; margin:0 0 16px;">
                                Hola <strong>${nombreSeguro}</strong>,
                            </p>

                            <p style="font-size:15px; line-height:1.8; color:#6F4E37; margin:0 0 24px;">
                                ${esReenvio
                                    ? "Aquí tienes tu nuevo código para continuar con la verificación de tu cuenta."
                                    : "Nos alegra que quieras formar parte de nuestra comunidad. Para activar tu cuenta, ingresa el siguiente código de verificación:"}
                            </p>

                            <!-- CÓDIGO DE VERIFICACIÓN -->
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                                style="background-color:#FFF8F0; border:1px solid #E8DCCB; border-radius:12px;">
                                <tr>
                                    <td align="center" style="padding:24px 12px;">

                                        <p style="font-size:12px; letter-spacing:2px; color:#6F4E37; margin:0 0 14px;">
                                            TU CÓDIGO DE VERIFICACIÓN
                                        </p>

                                        <div style="font-family:'Courier New', Courier, monospace; font-size:36px; font-weight:bold; letter-spacing:8px; color:#3D2314; overflow-wrap:anywhere;">
                                            ${escaparHTML(String(codigo))}
                                        </div>

                                        <div style="width:45px; height:3px; background-color:#C87D32; margin:18px auto 0;"></div>

                                    </td>
                                </tr>
                            </table>

                            <!-- VIGENCIA Y SEGURIDAD -->
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                                style="margin-top:24px;">

                                <tr>
                                    <td width="32" valign="top" style="font-size:20px; padding-top:2px;">
                                        &#9200;
                                    </td>

                                    <td style="font-size:14px; line-height:1.7; color:#6F4E37;">
                                        Este código estará vigente durante
                                        <strong style="color:#3D2314;">15 minutos</strong>.
                                        Úsalo antes de que expire.
                                    </td>
                                </tr>

                                <tr>
                                    <td width="32" valign="top" style="font-size:20px; padding-top:14px;">
                                        &#128274;
                                    </td>

                                    <td style="font-size:14px; line-height:1.7; color:#6F4E37; padding-top:14px;">
                                        Por tu seguridad, no compartas este código con nadie.
                                    </td>
                                </tr>

                            </table>

                            <p style="font-size:13px; line-height:1.7; color:#8A7768; margin:28px 0 0;">
                                Si no solicitaste esta verificación, puedes ignorar este correo.
                            </p>

                        </td>
                    </tr>

                    <!-- PIE DEL CORREO -->
                    <tr>
                        <td align="center"
                            style="background-color:#FFF8F0; border-top:1px solid #E8DCCB; padding:24px 20px;">

                            <p style="font-size:14px; font-weight:bold; color:#3D2314; margin:0 0 8px;">
                                Santa Cruz de la Plazuela
                            </p>

                            <p style="font-size:12px; color:#8A7768; line-height:1.7; margin:0 0 14px;">
                                Un lugar para disfrutar los pequeños momentos.
                            </p>

                            <p style="font-size:11px; color:#A39487; margin:0;">
                                © 2026 Santa Cruz de la Plazuela
                                <br>
                                Mensaje automático, por favor no respondas a este correo.
                            </p>

                        </td>
                    </tr>

                </table>

            </td>
        </tr>
    </table>

</body>
</html>
`;

    await brevo.transactionalEmails.sendTransacEmail({
        subject: esReenvio
            ? "Nuevo código de verificación - Santa Cruz de la Plazuela"
            : "Verifica tu cuenta - Santa Cruz de la Plazuela",

        sender: {
            name: "Santa Cruz de la Plazuela",
            email: process.env.EMAIL_USER
        },

        to: [{
            email: correo,
            name: nombre
        }],

        htmlContent
    });
};


// REGISTRAR NUEVO USUARIO
// El usuario todavía NO se guarda en la colección BDusurios.
export const registrarUser = async (req, res) => {
    try {
        const { nombre, email, password } = req.body;

        if (
            typeof nombre !== "string" ||
            !nombre.trim() ||
            typeof email !== "string" ||
            !email.trim() ||
            typeof password !== "string" ||
            !password
        ) {
            return res.status(400).json({
                mensaje: "Todos los campos son obligatorios"
            });
        }

        const nombreLimpio = nombre.trim();
        const correo = email.trim().toLowerCase();

        // Validar formato básico del correo.
        const formatoCorreo = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!formatoCorreo.test(correo)) {
            return res.status(400).json({
                mensaje: "Ingresa un correo electrónico válido"
            });
        }

        // Entre 6 y 15 caracteres, al menos una mayúscula,
        // una minúscula y un número.
        const formatoPassword =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,15}$/;

        if (!formatoPassword.test(password)) {
            return res.status(400).json({
                mensaje:
                    "La contraseña debe tener entre 6 y 15 caracteres, " +
                    "una mayúscula, una minúscula y un número."
            });
        }

        const existeUser = await user.findOne({ email: correo });

        if (existeUser?.isVerified) {
            return res.status(400).json({
                mensaje: "Ya existe una cuenta con este correo"
            });
        }

        // Eliminar registros pendientes antiguos de la colección principal.
        // Nunca eliminar usuarios verificados.
        if (existeUser && !existeUser.isVerified) {
            await user.deleteOne({
                _id: existeUser._id,
                isVerified: false
            });
        }

        const codigo = generarCodigo();
        const ahora = Date.now();

        // Buscar si ya existe un registro temporal para este correo.
        let pendiente = await RegistroPendiente.findOne({
            email: correo
        });

        if (pendiente) {
            pendiente.nombre = nombreLimpio;
            pendiente.password = password;
            pendiente.codigoVerificacion = codigo;
            pendiente.codigoExpiracion =
                new Date(ahora + TIEMPO_CODIGO);
            pendiente.eliminarEn =
                new Date(ahora + TIEMPO_REGISTRO_TEMPORAL);
        } else {
            pendiente = new RegistroPendiente({
                nombre: nombreLimpio,
                email: correo,
                password,
                codigoVerificacion: codigo,
                codigoExpiracion:
                    new Date(ahora + TIEMPO_CODIGO),
                eliminarEn:
                    new Date(ahora + TIEMPO_REGISTRO_TEMPORAL)
            });
        }

        await pendiente.save();

        try {
            await enviarCorreoVerificacion(
                nombreLimpio,
                correo,
                codigo
            );
        } catch (errorCorreo) {
            console.error("Error al enviar el correo:", errorCorreo);

            // No dejar un registro temporal con un código que no se envió.
            await RegistroPendiente.deleteOne({
                _id: pendiente._id
            });

            return res.status(502).json({
                mensaje:
                    "No se pudo enviar el código de verificación. Inténtalo nuevamente."
            });
        }

        return res.status(201).json({
            mensaje:
                "Hemos enviado un código de 6 dígitos a tu correo para completar el registro.",
            correo
        });

    } catch (error) {
        console.error("Error al registrar usuario:", error);

        if (error.name === "ValidationError") {
            return res.status(400).json({
                mensaje: "Los datos ingresados no son válidos."
            });
        }

        if (error.code === 11000) {
            return res.status(409).json({
                mensaje:
                    "Ya existe un registro temporal con este correo. Intenta nuevamente."
            });
        }

        return res.status(500).json({
            mensaje:
                "No se pudo completar el registro. Verifica el correo e inténtalo nuevamente."
        });
    }
};

// VERIFICAR CUENTA CON CÓDIGO DE 6 DÍGITOS
export const verificarCuenta = async (req, res) => {
    try {
        const { email, codigo } = req.body;

        if (
            typeof email !== "string" ||
            !email.trim() ||
            (typeof codigo !== "string" &&
                typeof codigo !== "number") ||
            !String(codigo).trim()
        ) {
            return res.status(400).json({
                mensaje: "El correo y el código son obligatorios"
            });
        }

        const correo = email.trim().toLowerCase();
        const codigoIngresado = String(codigo).trim();

        const pendiente = await RegistroPendiente.findOne({
            email: correo
        });

        if (!pendiente) {
            const usuarioExistente = await user.findOne({
                email: correo
            });

            if (usuarioExistente?.isVerified) {
                return res.status(400).json({
                    mensaje: "Esta cuenta ya ha sido verificada"
                });
            }

            return res.status(404).json({
                mensaje:
                    "No existe un registro temporal vigente. Regístrate nuevamente para recibir un código."
            });
        }

        if (
            !pendiente.codigoVerificacion ||
            pendiente.codigoVerificacion !== codigoIngresado
        ) {
            return res.status(400).json({
                mensaje: "El código ingresado es incorrecto"
            });
        }

        if (
            !pendiente.codigoExpiracion ||
            pendiente.codigoExpiracion.getTime() <= Date.now()
        ) {
            return res.status(400).json({
                mensaje: "El código ha expirado. Solicita uno nuevo."
            });
        }

        const usuarioExistente = await user.findOne({
            email: correo
        });

        if (usuarioExistente?.isVerified) {
            await RegistroPendiente.deleteOne({
                _id: pendiente._id
            });

            return res.status(400).json({
                mensaje: "Ya existe una cuenta verificada con este correo"
            });
        }

        if (usuarioExistente && !usuarioExistente.isVerified) {
            await user.deleteOne({
                _id: usuarioExistente._id,
                isVerified: false
            });
        }

        // La contraseña ya fue cifrada por el modelo temporal.
        // Crear el usuario definitivo usando ese mismo hash.
        const nuevoUsuario = {
            nombre: pendiente.nombre,
            email: pendiente.email,
            password: pendiente.password,
            rol: "usuario",
            isVerified: true,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null,
            activo: true,
            createdAt: new Date(),
            updatedAt: new Date()
        };

        // Escritura directa para no ejecutar nuevamente el hook bcrypt.
        await user.collection.insertOne(nuevoUsuario);

        await RegistroPendiente.deleteOne({
            _id: pendiente._id
        });

        return res.status(200).json({
            mensaje:
                "¡Tu cuenta fue verificada exitosamente! Ya puedes iniciar sesión."
        });

    } catch (error) {
        console.error("Error al verificar cuenta:", error);

        if (error.code === 11000) {
            return res.status(409).json({
                mensaje:
                    "Ya existe una cuenta con este correo. Intenta iniciar sesión."
            });
        }

        return res.status(500).json({
            mensaje: "Error al verificar la cuenta"
        });
    }
};

// REENVIAR CÓDIGO DE VERIFICACIÓN
export const reenviarCodigoVerificacion = async (req, res) => {
    try {
        const { email } = req.body;

        if (typeof email !== "string" || !email.trim()) {
            return res.status(400).json({
                mensaje: "El correo electrónico es requerido"
            });
        }

        const correo = email.trim().toLowerCase();

        const pendiente = await RegistroPendiente.findOne({
            email: correo
        });

        if (!pendiente) {
            const usuarioExistente = await user.findOne({
                email: correo
            });

            if (usuarioExistente?.isVerified) {
                return res.status(400).json({
                    mensaje: "Esta cuenta ya se encuentra verificada"
                });
            }

            return res.status(404).json({
                mensaje:
                    "No existe un registro pendiente con este correo. Regístrate nuevamente."
            });
        }

        const nuevoCodigo = generarCodigo();

        // Enviar primero para no invalidar el código anterior si Brevo falla.
        await enviarCorreoVerificacion(
            pendiente.nombre,
            correo,
            nuevoCodigo,
            true
        );

        const ahora = Date.now();

        pendiente.codigoVerificacion = nuevoCodigo;
        pendiente.codigoExpiracion =
            new Date(ahora + TIEMPO_CODIGO);
        pendiente.eliminarEn =
            new Date(ahora + TIEMPO_REGISTRO_TEMPORAL);

        await pendiente.save();

        return res.status(200).json({
            mensaje:
                "Se ha enviado un nuevo código de 6 dígitos a tu correo."
        });

    } catch (error) {
        console.error("Error al reenviar código:", error);

        return res.status(500).json({
            mensaje: "Error al reenviar el código de verificación"
        });
    }
};

// LOGIN / REGISTRO CON GOOGLE
export const loginConGoogle = async (req, res) => {
    try {
        const { nombre, email, googleId, avatar } = req.body;

        if (
            typeof email !== "string" ||
            !email.trim() ||
            typeof googleId !== "string" ||
            !googleId.trim()
        ) {
            return res.status(400).json({
                mensaje: "Faltan datos de Google (email o googleId)"
            });
        }

        const correo = email.trim().toLowerCase();

        let usuario = await user.findOne({ email: correo });

        if (usuario) {
            // No vincular una cuenta pendiente a Google sin resolverla primero.
            if (!usuario.isVerified && !usuario.googleId) {
                return res.status(409).json({
                    mensaje:
                        "Este correo tiene un registro pendiente de verificación. Verifica tu correo antes de continuar."
                });
            }

            if (
                usuario.googleId &&
                usuario.googleId !== googleId
            ) {
                return res.status(409).json({
                    mensaje:
                        "La cuenta de Google no coincide con la cuenta registrada."
                });
            }

            if (!usuario.googleId) {
                usuario.googleId = googleId;

                if (avatar) {
                    usuario.avatar = avatar;
                }

                // Google confirma el correo.
                usuario.isVerified = true;
                usuario.codigoVerificacion = null;
                usuario.codigoVerificacionExpiracion = null;

                await usuario.save();
            }
        } else {
            // Google confirma el correo: crear la cuenta verificada.
            usuario = new user({
                nombre: nombre || "Usuario",
                email: correo,
                googleId,
                avatar: avatar || "",
                rol: "usuario",
                isVerified: true
            });

            await usuario.save();
        }

        return res.status(200).json({
            mensaje: "Inicio de sesión con Google exitoso",
            usuario: {
                _id: usuario._id,
                nombre: usuario.nombre,
                email: usuario.email,
                rol: usuario.rol,
                avatar: usuario.avatar
            }
        });

    } catch (error) {
        console.error("Error al iniciar sesión con Google:", error);

        return res.status(500).json({
            mensaje: "Error al iniciar sesión con Google"
        });
    }
};