import user from '../models/user.js';
import nodemailer from "nodemailer";
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

//FUNCION PARA GENERAR CODIGO DE VERIFICACION
const generarCodigo = () => {
    return Math.floor(100000 + Math.random() * 900000).toString();
};

// REGISTRAR NUEVO USUARIO 
export const registrarUser = async (req, res) => {
    try {
        const { nombre, email, password } = req.body;

        // TODOS LOS CAMPOS SON OBLIGATORIOS
        if (!nombre || !email || !password) {
            return res.status(400).json({ mensaje: 'Todos los campos son obligatorios' });
        }

        //VALIDAR SI EL USUARIO YA EXISTE 
        const existeUser = await user.findOne({ email });

        if (existeUser) {
            return res.status(400).json({ mensaje: 'El usuario ya existe' });
        }

        //GENERAMOS EL CODIGO DE VERIFICACION
        const codigo = generarCodigo();

        // CREAMOS EL USUARIO
        const nuevoUser = new user({
            nombre,
            email,
            password,
            rol: "usuario",
            isVerified: false,
            codigoVerificacion: codigo,
            codigoVerificacionExpiracion: Date.now() + 900000 // 15 minutos
        });

        //GUARDAMOS EL USUARIO EN LA BASE DE DATOS
        await nuevoUser.save();

        //CONSTRUIMOS EL CORREO DE VERIFICACION
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: nuevoUser.email,
            subject: "Verifica tu cuenta - Santa Cruz de la Plazuela",
            html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h2 style="color: #16a316eb; margin: 0;">🍽️ Santa Cruz de la Plazuela</h2>
                </div>

                <h3 style="color: #4d4b4b;">¡Gracias por registrarte!</h3>

                <p>Hola <strong>${nuevoUser.nombre}</strong>,</p>

                <p>Para activar tu cuenta, ingresa el siguiente código de verificación:</p>

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
                    🔒 Si no creaste esta cuenta, puedes ignorar este mensaje.
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

        res.status(201).json({
            mensaje: 'Hemos enviado un código de 6 dígitos a tu correo para completar el registro.',
            correo: nuevoUser.email
        });

    } catch (error) {

        console.log(error);

        if (error.name === 'ValidationError' && error.errors.password) {
            return res.status(400).json({ mensaje: 'La contraseña debe tener al menos 6 caracteres' });
        }

        res.status(500).json({
            mensaje: 'Error al registrar el usuario',
            error: error.message
        });
    }
};

//VERIFICAR CUENTA CON EL CODIGO DE 6 DIGITOS
export const verificarCuenta = async (req, res) => {
    try {
        const { email, codigo } = req.body;

        if (!email || !codigo) {
            return res.status(400).json({ mensaje: 'El correo y el código son obligatorios' });
        }

        const usuario = await user.findOne({ email });

        if (!usuario) {
            return res.status(404).json({ mensaje: 'Usuario no encontrado' });
        }

        if (usuario.isVerified) {
            return res.status(400).json({ mensaje: 'Esta cuenta ya ha sido verificada' });
        }

        if (usuario.codigoVerificacion !== codigo.trim()) {
            return res.status(400).json({ mensaje: 'El código ingresado es incorrecto' });
        }

        if (usuario.codigoVerificacionExpiracion < Date.now()) {
            return res.status(400).json({ mensaje: 'El código ha expirado. Solicita uno nuevo.' });
        }

        usuario.isVerified = true;
        usuario.codigoVerificacion = null;
        usuario.codigoVerificacionExpiracion = null;
        await usuario.save();

        res.status(200).json({ mensaje: '¡Tu cuenta fue verificada exitosamente! Ya puedes iniciar sesión.' });

    } catch (error) {
        console.log(error);
        res.status(500).json({ mensaje: 'Error al verificar la cuenta', error: error.message });
    }
};

//REENVIAR CODIGO DE VERIFICACION
export const reenviarCodigoVerificacion = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ mensaje: 'El correo electrónico es requerido' });
        }

        const usuario = await user.findOne({ email });

        if (!usuario) {
            return res.status(404).json({ mensaje: 'No existe una cuenta con este correo' });
        }

        if (usuario.isVerified) {
            return res.status(400).json({ mensaje: 'Esta cuenta ya se encuentra verificada' });
        }

        const nuevoCodigo = generarCodigo();
        usuario.codigoVerificacion = nuevoCodigo;
        usuario.codigoVerificacionExpiracion = Date.now() + 900000;
        await usuario.save();

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: usuario.email,
            subject: "Nuevo código de verificación - Santa Cruz de la Plazuela",
            html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333333;">
                <div style="text-align: center; margin-bottom: 30px;">
                    <h2 style="color: #16a316eb; margin: 0;">🍽️ Santa Cruz de la Plazuela</h2>
                </div>

                <h3 style="color: #4d4b4b;">Nuevo Código de Verificación</h3>

                <p>Hola <strong>${usuario.nombre}</strong>,</p>

                <p>Tu nuevo código de verificación es:</p>

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
                        ${nuevoCodigo}
                    </h1>
                </div>

                <p style="color: #666666; font-size: 14px;">
                    ⏱️ Este código expirará en <strong>15 minutos</strong>.
                </p>

                <hr style="margin: 30px 0; border: none; border-top: 1px solid #dddddd;">

                <p style="color: #999999; font-size: 12px; text-align: center;">
                    © 2026 Santa Cruz de la Plazuela
                </p>
            </div>
            `
        };

        await transporter.sendMail(mailOptions);

        res.status(200).json({ mensaje: 'Se ha enviado un nuevo código de 6 dígitos a tu correo.' });

    } catch (error) {
        console.log(error);
        res.status(500).json({ mensaje: 'Error al reenviar el código', error: error.message });
    }
};