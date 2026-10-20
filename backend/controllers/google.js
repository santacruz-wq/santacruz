import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
import user from "../models/user.js";
import RegistroPendiente from "../models/registroPendiente.js";
import dotenv from "dotenv";

dotenv.config();

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const loginWithGoogle = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (typeof idToken !== "string" || !idToken.trim()) {
            return res.status(400).json({
                mensaje: "El token de Google es requerido",
            });
        }

        let googleId;
        let email;
        let given_name;
        let family_name;
        let picture;
        let emailVerificadoPorGoogle = false;

        // Detectar si es un ID Token JWT.
        const esJwt =
            idToken.split(".").length === 3 &&
            !idToken.startsWith("ya29.");

        if (esJwt) {
            // Android / iOS.
            const ticket = await client.verifyIdToken({
                idToken,
                audience: process.env.GOOGLE_CLIENT_ID,
            });

            const payload = ticket.getPayload();

            if (!payload) {
                return res.status(401).json({
                    mensaje: "No se pudieron validar los datos de Google",
                });
            }

            googleId = payload.sub;
            email = payload.email;
            given_name = payload.given_name;
            family_name = payload.family_name;
            picture = payload.picture;
            emailVerificadoPorGoogle = payload.email_verified === true;
        } else {
            // Google Access Token.
            const userInfoResponse = await fetch(
                "https://www.googleapis.com/oauth2/v3/userinfo",
                {
                    headers: {
                        Authorization: `Bearer ${idToken}`,
                    },
                }
            );

            if (!userInfoResponse.ok) {
                return res.status(401).json({
                    mensaje: "El token de acceso de Google no es válido o expiró",
                });
            }

            const userData = await userInfoResponse.json();

            googleId = userData.sub;
            email = userData.email;
            given_name =
                userData.given_name ||
                userData.name ||
                "USUARIO";
            family_name = userData.family_name || "";
            picture = userData.picture;
            emailVerificadoPorGoogle = userData.email_verified === true;
        }

        if (!email || !googleId || !emailVerificadoPorGoogle) {
            return res.status(401).json({
                mensaje:
                    "Google debe proporcionar un correo verificado para iniciar sesión",
            });
        }

        const correoLimpio = email.toLowerCase().trim();

        // Buscar usuario definitivo.
        let usuario = await user.findOne({
            email: correoLimpio,
        });

        // Si existe un registro pendiente por correo y contraseña,
        // no vincularlo automáticamente a Google.
        const registroPendiente = await RegistroPendiente.findOne({
            email: correoLimpio,
        });

        if (registroPendiente && !usuario) {
            return res.status(409).json({
                mensaje:
                    "Este correo tiene un registro pendiente de verificación. Verifica el código enviado a tu correo antes de continuar con ese registro.",
            });
        }

        if (usuario) {
            // No permitir vincular un Google ID diferente al ya registrado.
            if (usuario.googleId && usuario.googleId !== googleId) {
                return res.status(409).json({
                    mensaje:
                        "Este correo ya está vinculado a otra cuenta de Google.",
                });
            }

            // Si el usuario se registró con correo y contraseña,
            // permitir vincular Google únicamente si su cuenta ya está verificada.
            if (!usuario.isVerified) {
                return res.status(403).json({
                    mensaje:
                        "Esta cuenta todavía no está verificada. Verifica tu correo antes de iniciar sesión.",
                });
            }

            if (!usuario.googleId) {
                usuario.googleId = googleId;
            }

            // Guardar foto si todavía no tiene.
            if (!usuario.avatar && picture) {
                usuario.avatar = picture;
            }

            await usuario.save();
        } else {
            // Crear usuario nuevo con correo confirmado por Google.
            const nombreCompleto =
                `${given_name || "USUARIO"} ${family_name || ""}`.trim();

            usuario = new user({
                nombre: nombreCompleto,
                email: correoLimpio,
                googleId,
                avatar: picture || "",
                isVerified: true,
                rol: "usuario",
                activo: true,
            });

            await usuario.save();
        }

        if (!usuario.activo) {
            return res.status(403).json({
                mensaje: "Esta cuenta se encuentra desactivada. Contacta al administrador.",
            });
        }

        if (!process.env.JWT_SECRET) {
            console.error("JWT_SECRET no está configurado.");
            return res.status(500).json({
                mensaje: "Error de configuración del servidor.",
            });
        }

        // JWT PROPIO DE SANTA CRUZ.
        const token = jwt.sign(
            {
                id: usuario._id,
                email: usuario.email,
            },
            process.env.JWT_SECRET,
            {
                expiresIn: "1h",
            }
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
        console.error(
            "Error al autenticar con Google:",
            error
        );

        if (error.code === 11000) {
            return res.status(409).json({
                mensaje:
                    "La cuenta ya existe o está vinculada. Intenta iniciar sesión nuevamente.",
            });
        }

        return res.status(401).json({
            mensaje: "No fue posible autenticar con Google",
        });
    }
};