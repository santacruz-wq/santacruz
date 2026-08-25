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

        //CONSTRUIMOS EL CORREO
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Código de recuperación de contraseña - Santa Cruz de la Plazuela",
            html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h2 style="color: #16a316eb; margin: 0;">🍽️ Santa Cruz de la Plazuela</h2>
                </div>
                
                <h3 style="color: #4d4b4b;">Recuperación de Contraseña</h3>
                
                <p>Hola <strong>${usuario.nombre || 'Usuario'}</strong>,</p>
                
                <p>Recibimos una solicitud para restablecer tu contraseña.</p>
                
                <p>Tu código de verificación es:</p>
                
                <div style="background: linear-gradient(135deg, #269d20 0%, #c3d936 100%); 
                            padding: 30px 20px; 
                            border-radius: 10px; 
                            text-align: center; 
                            margin: 30px 0;">
                    
                    <h1 style="color: #ffffff; 
                            font-size: 36px; 
                            letter-spacing: 8px; 
                            margin: 0;
                            font-family: 'Courier New', Courier, monospace;">
                        ${codigo}
                    </h1>
                </div>
                
                <p style="color: #666666; font-size: 14px;">
                    ⏱️ Este código expirará en <strong>15 minutos</strong>.
                </p>
                
                <p style="color: #666666; font-size: 14px;">
                    🔒 Si no solicitaste este cambio, ignora este email y tu contraseña permanecerá segura.
                </p>
                
                <hr style="margin: 30px 0; border: none; border-top: 1px solid #dddddd;">
                
                <p style="color: #999999; font-size: 12px; text-align: center;">
                    © 2026 Santa Cruz de la Plazuela
                </p>
            </div>
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
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Contraseña cambiada exitosamente - Santa Cruz de la Plazuela",
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333;">
                    <div style="text-align: center; margin-bottom: 30px;">
                        <h2 style="color: #16a316eb; margin: 0;">🍽️ Santa Cruz de la Plazuela</h2>
                    </div>
                    
                    <h3 style="color: #4d4b4b;">Contraseña Cambiada Exitosamente</h3>
                    
                    <p>Hola <strong>${usuario.nombre || 'Usuario'}</strong>,</p>
                    
                    <p>Te informamos que tu contraseña ha sido cambiada exitosamente.</p>
                    
                    <p>Si no solicitaste este cambio, por favor contacta con nosotros de inmediato.</p>
                    
                    <hr style="margin: 30px 0; border: none; border-top: 1px solid #dddddd;">
                    
                    <p style="color: #999999; font-size: 12px; text-align: center;">
                        © 2026 Santa Cruz de la Plazuela
                    </p>
                </div>
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