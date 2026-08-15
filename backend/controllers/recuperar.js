import user from "../models/user.js";
import nodemailer from "nodemailer";
import dotenv from "dotenv";

dotenv.config();

//configurar transporte de correo
const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

// función para generar código de recuperación

const generarCode=()=>{
    return Math.floor(100000 + Math.random() * 900000).toString(); // genera un código de 6 dígitos
};

// funcion para enviar o solicitar correo de recuperación

export const solicitarCode=async (req,res)=>{
    try {
        const { email } = req.body;
        // verificar que el campo este presente 
        if (!email) {
            return res.status(400).json({ message: "El campo email es requerido" });
        }

        // buscar usuario por email
        const usuario = await user.findOne({ email });
        if (!usuario) {
            return res.status(404).json({ message: "Usuario no encontrado" });
        }

        // generar código de recuperación 
        const codigo = generarCode();

        // guardar el codigo en la base de datos  con fecha de expiración de 15 minutos
        usuario.codigoRecuperacion = codigo;
        usuario.codigoexpiracion = Date.now() + 900000; // 15 minutos en milisegundos
        await usuario.save();

        //creamos o construimos el correo
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Código de recuperación de contraseña - Santa Cruz de la Plazuela",
            html:`
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
        }
        //enviar el correo
        await transporter.sendMail(mailOptions);
        res.status(200).json({ message: "Código de recuperación enviado al correo" });

    } catch (error) {
        console.error("Error al solicitar código de recuperación:", error);
        res.status(500).json({ message: "Error al solicitar el codigo de recuperacion" });
    }
}

// funcion para cambiar contraseña 

export const cambiarPassword=async (req,res)=>{
    try {
        const { email, codigo, nuevaPassword } = req.body;

        // verificar que los campos estén presentes
        if (!email || !codigo || !nuevaPassword) {
            return res.status(400).json({ message: "todos los campos son requeridos" });
        }

        // contarseña debe tener almenos 6 caracteres
        if (nuevaPassword.length < 6) {
            return res.status(400).json({ message: "la contraseña debe tener al menos 6 caracteres" });
        }

        // buscar usuario en la base de datos 
        const usuario = await user.findOne({ email, 
                                            codigoRecuperacion: codigo, 
                                            codigoexpiracion: { $gt: Date.now() } });

        if (!usuario) {
            return res.status(400).json({ message: "Código de recuperación inválido o expirado" });
        }

        //cambiar la contraseña 
        usuario.password = nuevaPassword;
        usuario.codigoRecuperacion = null;
        usuario.codigoexpiracion = null;

        //guardar los cambios en la base de datos
        await usuario.save();

        const mailOptions = {
            from:process.env.EMAIL_USER,
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
        }
        await transporter.sendMail(mailOptions);
        res.status(200).json({ message: "Contraseña cambiada exitosamente" });

    } catch (error) {
        console.error("Error al cambiar la contraseña:", error);
        res.status(500).json({ message: "Error al cambiar la contraseña",error: error.message });
    }
}