import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
import user from "../models/user.js";

// Client ID cargado limpiamente desde variables de entorno
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const loginWithGoogle = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({ mensaje: "El token de Google es requerido" });
        }

        let googleId, email, given_name, family_name, picture;

        // Regla de detección: un JWT tiene 3 partes separadas por punto y no inicia por ya29.
        const esJwt = idToken.split(".").length === 3 && !idToken.startsWith("ya29.");

        if (esJwt) {
            // 1. Caso Android / iOS: Verificación formal mediante biblioteca oficial
            const ticket = await client.verifyIdToken({
                idToken,
                audience: process.env.GOOGLE_CLIENT_ID,
            });

            const payload = ticket.getPayload();
            googleId = payload.sub;
            email = payload.email;
            given_name = payload.given_name;
            family_name = payload.family_name;
            picture = payload.picture;
        } else {
            // 2. Caso Flutter Web: Consulta a la API UserInfo oficial de Google
            const userInfoResponse = await fetch(
                "https://www.googleapis.com/oauth2/v3/userinfo",
                {
                    headers: { Authorization: `Bearer ${idToken}` },
                }
            );

            if (!userInfoResponse.ok) {
                throw new Error("El token de acceso de Google no es válido o expiró");
            }

            const userData = await userInfoResponse.json();
            googleId = userData.sub;
            email = userData.email;
            given_name = userData.given_name || userData.name || "USUARIO";
            family_name = userData.family_name || "";
            picture = userData.picture;
        }

        if (!email) {
            return res.status(400).json({ mensaje: "Google no proporcionó un email válido" });
        }

        const correoLimpio = email.toLowerCase().trim();

        // 2. Buscar si el usuario ya existe
        let usuario = await user.findOne({ email: correoLimpio });

        if (usuario) {
            if (!usuario.googleId) usuario.googleId = googleId;
            if (!usuario.isVerified) {
                usuario.isVerified = true;
                usuario.codigoVerificacion = undefined;
                usuario.codigoVerificacionExpiracion = undefined;
            }
            if (!usuario.avatar && picture) usuario.avatar = picture;
            await usuario.save();
        } else {
            // 3. Crear nuevo usuario verificado por defecto
            const nombreCompleto = `${given_name || "USUARIO"} ${family_name || ""}`.trim();

            usuario = new user({
                nombre: nombreCompleto,
                email: correoLimpio,
                googleId,
                avatar: picture || "",
                isVerified: true,
                rol: "usuario",
            });
            await usuario.save();
        }

        // 4. Firmar el JWT propio de la aplicación
        const token = jwt.sign(
            { id: usuario._id, email: usuario.email },
            process.env.JWT_SECRET,
            { expiresIn: "1h" }
        );

        return res.status(200).json({
            mensaje: "Inicio de sesión con Google exitoso",
            token,
            usuario: {
                _id: usuario._id,
                email: usuario.email,
                nombre: usuario.nombre,
                rol: usuario.rol,
                avatar: usuario.avatar,
            },
        });
    } catch (error) {
        console.error("Error al autenticar con Google:", error);
        return res.status(401).json({
            mensaje: "Token de Google inválido o expirado",
            error: error.message,
        });
    }
};