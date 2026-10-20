import user from "../models/user.js";
import nodemailer from "nodemailer";
import bcrypt from "bcrypt";
import dotenv from "dotenv";

dotenv.config();

//CONFIGURAR TRANSPORTE DE CORREO
const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

//FUNCION PARA GENERAR CODIGO DE RECUPERACION
const generarCode = () => {
    return Math.floor(100000 + Math.random() * 900000).toString(); // genera un código de 6 dígitos
};

//FUNCION PARA SOLICITAR CODIGO DE RECUPERACION
export const solicitarCode = async (req, res) => {
    try {
        const { email } = req.body;

        //VALIDAMOS QUE EL CAMPO ESTE PRESENTE
        if (!email) {
            return res.status(400).json({ message: "El campo email es requerido" });
        }

        //BUSCAMOS USUARIO POR EMAIL
        const usuario = await user.findOne({ email });
        if (!usuario) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        //VERIFICAMOS QUE EL USUARIO ESTE ACTIVO
        if (!usuario.activo) {
            return res.status(403).json({ message: "Usuario deshabilitado, contacta al administrador" });
        }

        //GENERAMOS EL CODIGO DE RECUPERACION
        const codigo = generarCode();

        //GUARDAMOS EL CODIGO CON FECHA DE EXPIRACION DE 15 MINUTOS
        usuario.codigoRecuperacion = codigo;
        usuario.codigoExpiracion = Date.now() + 900000; // 15 minutos en milisegundos
        await usuario.save();

        
        // CONSTRUIMOS EL CORREO DE RECUPERACIÓN DE CONTRASEÑA
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Recupera tu contraseña - Santa Cruz de la Plazuela",
            html: `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperación de contraseña</title>
</head>

<body style="margin:0; padding:0; background-color:#FAF0E6; font-family:Arial, Helvetica, sans-serif;">

    <div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">
        Tu código para recuperar la contraseña de Santa Cruz de la Plazuela.
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
                                SANTA CRUZ DE LA
                            </div>

                            <h1 style="margin:0; color:#FFF8F0; font-size:25px; line-height:1.4; font-weight:bold;">
                                PLAZUELA
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
                                Recuperación de contraseña
                            </h2>

                            <p style="font-size:15px; line-height:1.8; margin:0 0 16px;">
                                Hola <strong>${usuario.nombre || 'Usuario'}</strong>,
                            </p>

                            <p style="font-size:15px; line-height:1.8; color:#6F4E37; margin:0 0 16px;">
                                Recibimos una solicitud para restablecer la contraseña de tu cuenta.
                            </p>

                            <p style="font-size:15px; line-height:1.8; color:#6F4E37; margin:0 0 24px;">
                                Para continuar con el proceso, ingresa el siguiente código en la aplicación:
                            </p>

                            <!-- CÓDIGO -->
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                                style="background-color:#FFF8F0; border:1px solid #E8DCCB; border-radius:12px;">
                                <tr>
                                    <td align="center" style="padding:24px 12px;">

                                        <p style="font-size:12px; letter-spacing:2px; color:#6F4E37; margin:0 0 14px;">
                                            TU CÓDIGO DE RECUPERACIÓN
                                        </p>

                                        <div style="font-family:'Courier New', Courier, monospace; font-size:36px; font-weight:bold; letter-spacing:8px; color:#3D2314; overflow-wrap:anywhere;">
                                            ${codigo}
                                        </div>

                                        <div style="width:45px; height:3px; background-color:#C87D32; margin:18px auto 0;"></div>

                                    </td>
                                </tr>
                            </table>

                            <!-- VIGENCIA -->
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                                style="margin-top:24px;">
                                <tr>
                                    <td width="32" valign="top"
                                        style="font-size:20px; padding-top:2px;">
                                        &#9200;
                                    </td>

                                    <td style="font-size:14px; line-height:1.7; color:#6F4E37;">
                                        Este código estará vigente durante
                                        <strong style="color:#3D2314;">15 minutos</strong>.
                                        Utilízalo antes de que expire.
                                    </td>
                                </tr>

                                <tr>
                                    <td width="32" valign="top"
                                        style="font-size:20px; padding-top:14px;">
                                        &#128274;
                                    </td>

                                    <td style="font-size:14px; line-height:1.7; color:#6F4E37; padding-top:14px;">
                                        Si no solicitaste recuperar tu contraseña, ignora este correo.
                                        Tu contraseña actual permanecerá sin cambios mientras no completes
                                        el proceso de restablecimiento.
                                    </td>
                                </tr>
                            </table>

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
            `
        };


        //ENVIAMOS EL CORREO
        await transporter.sendMail(mailOptions);
        res.status(200).json({ message: "Código de recuperación enviado al correo" });

    } catch (error) {
        console.error("Error al solicitar código de recuperación:", error);
        res.status(500).json({ message: "Error al solicitar el codigo de recuperacion" });
    }
};

//FUNCION PARA CAMBIAR CONTRASEÑA
export const cambiarPassword = async (req, res) => {
    try {
        const { email, codigo, nuevaPassword } = req.body;

        //VALIDAMOS QUE LOS CAMPOS ESTEN PRESENTES
        if (!email || !codigo || !nuevaPassword) {
            return res.status(400).json({ message: "todos los campos son requeridos" });
        }

        //VALIDAMOS QUE LA CONTRASEÑA TENGA AL MENOS 6 CARACTERES
        if (nuevaPassword.length < 6) {
            return res.status(400).json({ message: "la contraseña debe tener al menos 6 caracteres" });
        }

        //BUSCAMOS USUARIO POR EMAIL, CODIGO Y VIGENCIA
        const usuario = await user.findOne({
            email,
            codigoRecuperacion: codigo,
            codigoExpiracion: { $gt: Date.now() }
        });

        if (!usuario) {
            return res.status(400).json({ message: "Código de recuperación inválido o expirado" });
        }


        //ACTUALIZAMOS LA CONTRASEÑA Y LIMPIAMOS EL CODIGO
        usuario.password = nuevaPassword;
        usuario.codigoRecuperacion = null;
        usuario.codigoExpiracion = null;

        //GUARDAMOS LOS CAMBIOS
        await usuario.save();

        //CONSTRUIMOS EL CORREO DE CONFIRMACION
        
        // CORREO DE CONFIRMACIÓN DE CAMBIO DE CONTRASEÑA
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Contraseña cambiada exitosamente - Santa Cruz de la Plazuela",
            html: `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contraseña actualizada</title>
</head>

<body style="margin:0; padding:0; background-color:#FAF0E6; font-family:Arial, Helvetica, sans-serif;">

    <div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">
        Tu contraseña de Santa Cruz de la Plazuela ha sido actualizada.
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
                                SANTA CRUZ DE LA
                            </div>

                            <h1 style="margin:0; color:#FFF8F0; font-size:25px; line-height:1.4; font-weight:bold;">
                                PLAZUELA
                            </h1>

                            <p style="margin:10px 0 0; color:#E8DCCB; font-size:14px; letter-spacing:2px;">
                                postres y café
                            </p>

                            <div style="width:65px; height:3px; background-color:#C87D32; margin:22px auto 0;"></div>

                        </td>
                    </tr>

                    <!-- CONTENIDO -->
                    <tr>
                        <td style="padding:32px 28px 30px; color:#3D2314;">

                            <div style="text-align:center; margin-bottom:24px;">
                                <div style="display:inline-block; width:64px; height:64px; line-height:64px; border-radius:50%; background-color:#FFF8F0; border:1px solid #E8DCCB; color:#C87D32; font-size:32px;">
                                    &#10003;
                                </div>
                            </div>

                            <h2 style="font-size:23px; line-height:1.4; text-align:center; margin:0 0 24px; color:#3D2314;">
                                ¡Contraseña actualizada!
                            </h2>

                            <p style="font-size:15px; line-height:1.8; margin:0 0 16px;">
                                Hola <strong>${usuario.nombre || 'Usuario'}</strong>,
                            </p>

                            <p style="font-size:15px; line-height:1.8; color:#6F4E37; margin:0 0 22px;">
                                Te confirmamos que la contraseña de tu cuenta de
                                <strong>Santa Cruz de la Plazuela</strong> se ha cambiado exitosamente.
                            </p>

                            <!-- AVISO DE SEGURIDAD -->
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0"
                                style="background-color:#FFF8F0; border:1px solid #E8DCCB; border-left:4px solid #C87D32; border-radius:8px;">
                                <tr>
                                    <td style="padding:20px;">

                                        <p style="font-size:15px; font-weight:bold; color:#3D2314; margin:0 0 10px;">
                                            &#128274; Aviso de seguridad
                                        </p>

                                        <p style="font-size:14px; line-height:1.8; color:#6F4E37; margin:0;">
                                            Si realizaste este cambio, no necesitas hacer nada más.
                                            Si no reconoces esta actividad, contacta con el administrador
                                            del servicio y toma medidas para proteger tu cuenta.
                                        </p>

                                    </td>
                                </tr>
                            </table>

                            <p style="font-size:14px; line-height:1.8; color:#6F4E37; margin:24px 0 0;">
                                Gracias por confiar en nosotros. Seguimos trabajando para ofrecerte
                                una experiencia segura en Santa Cruz de la Plazuela.
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
            `
        };


        //ENVIAMOS EL CORREO DE CONFIRMACION
        await transporter.sendMail(mailOptions);
        res.status(200).json({ message: "Contraseña cambiada exitosamente" });

    } catch (error) {
        console.error("Error al cambiar la contraseña:", error);
        res.status(500).json({ message: "Error al cambiar la contraseña", error: error.message });
    }
};