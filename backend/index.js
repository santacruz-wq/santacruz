
 // ============================
 // 🔹 IMPORTS
 // ============================

import express from 'express';
import "dotenv/config";
import http from "http";
import { Server } from "socket.io";
import { connectDB } from "./db/db.js";
import dns from "dns";

// Rutas
import userRoutes from './routes/user.js';
import loginRoutes from './routes/login.js';
import recuperarRoutes from './routes/recuperar.js';
import productoRoutes from './routes/product.js';
import categoriaRoutes from "./routes/categoria.js";
import mesaRoutes from './routes/mesa.js';
import ordenesRoutes from './routes/ordenes.js';
import traducirRoutes from './routes/traducir.js';
import resenaRoutes from "./routes/resena.js";
import inventarioRoutes from "./routes/inventario.js";
import notificacionRoutes from "./routes/notificacion.js";
import favoritosRoutes from "./routes/favoritos.js";
import chatRoutes from "./routes/chatroutes.js";
import adminUsuariosRoutes from "./routes/usuarios.js";
import perfilRoutes from "./routes/perfil.js";
import interpreteRoutes from "./routes/interprete.js";
import fcmRoutes from './routes/fcm.js';


// ============================
// 🔹 CONFIGURACIÓN
// ============================

const app = express();

dns.setServers(["8.8.8.8", "1.1.1.1"]);

connectDB();

app.use(express.json());

app.use('/uploads', express.static('uploads'));

const PORT = process.env.PORT || 3000;


// ============================
// 🔹 SOCKET.IO
// ============================

const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: "*"
    }
});

// GUARDAMOS LA INSTANCIA DE IO
// PARA USARLA EN LOS CONTROLLERS

app.set("io", io);


io.on("connection", (socket) => {

    console.log(
        "Cliente conectado:",
        socket.id
    );


    // ============================
    // 🔹 SALA INDIVIDUAL DEL MESERO
    // ============================

    socket.on("join", (usuarioId) => {

        socket.join(usuarioId);

        console.log(
            `Usuario ${usuarioId} se unió a su sala`
        );

    });


    // ============================
    // 🔹 SALA GENERAL DE MESEROS
    // ============================

    socket.on("joinMeseros", () => {

        socket.join("meseros");

        console.log(
            `Mesero se unió a la sala: ${socket.id}`
        );

    });


    // ============================
    // 🔹 SALA DE COCINA
    // ============================

    socket.on("joinCocina", () => {

        socket.join("cocina");

        console.log(
            `Cocina se unió a la sala: ${socket.id}`
        );

    });


    // ============================
    // 🔹 DESCONECTAR
    // ============================

    socket.on("disconnect", () => {

        console.log(
            "Cliente desconectado:",
            socket.id
        );

    });

});


// ============================
// 🔹 RUTAS DE LA API
// ============================

// ESTADO DEL SERVIDOR
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// RUTA PRINCIPAL
app.get('/', (req, res) => {
    res.send('¡Mi API está corriendo al 100%! 🚀');
});


// ============================
// 🔹 ELIMINACIÓN DE CUENTAS
// ============================

app.get('/eliminar-cuenta', (req, res) => {

    res.status(200).type('html').send(`
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <title>Eliminar cuenta - Santa Cruz de la Plazuela</title>

            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #FAF0E6;
                    color: #3D2314;
                    margin: 0;
                    padding: 30px 15px;
                    line-height: 1.6;
                }

                main {
                    max-width: 750px;
                    margin: auto;
                    background: #FFFFFF;
                    padding: 30px;
                    border-radius: 12px;
                }

                h1, h2 {
                    color: #6F4E37;
                }

                a {
                    color: #9B5B20;
                    font-weight: bold;
                }

                .contacto {
                    background: #FFF8F0;
                    padding: 18px;
                    border-radius: 8px;
                }
            </style>
        </head>

        <body>

            <main>

                <h1>Eliminación de cuenta</h1>

                <h2>Santa Cruz de la Plazuela</h2>

                <p>
                    Los usuarios de Santa Cruz de la Plazuela pueden
                    solicitar la eliminación de su cuenta y de los datos
                    personales asociados.
                </p>


                <h2>¿Cómo solicitar la eliminación?</h2>

                <ol>
                    <li>
                        Envía un correo electrónico a nuestra dirección
                        oficial de soporte.
                    </li>

                    <li>
                        Utiliza como asunto:
                        Solicitud de eliminación de cuenta.
                    </li>

                    <li>
                        Indica el correo electrónico asociado a tu cuenta
                        en la aplicación.
                    </li>

                    <li>
                        Nuestro equipo verificará la solicitud y la
                        identidad del titular antes de procesarla.
                    </li>
                </ol>


                <div class="contacto">

                    <h2>Solicitar eliminación</h2>

                    <p>Correo de soporte:</p>

                    <p>
                        <a href="mailto:santacruzdelaplazuela@gmail.com?subject=Solicitud%20de%20eliminacion%20de%20cuenta">
                            santacruzdelaplazuela@gmail.com
                        </a>
                    </p>

                </div>


                <h2>¿Qué información se elimina?</h2>

                <ul>
                    <li>
                        Nombre y correo personal, que son reemplazados
                        por datos anónimos.
                    </li>

                    <li>Contraseña y vinculación con Google.</li>

                    <li>Fotografía de perfil.</li>

                    <li>Favoritos y notificaciones.</li>

                    <li>Tokens de notificaciones y sesiones activas.</li>

                    <li>Códigos de recuperación y verificación.</li>
                </ul>


                <h2>¿Qué información se conserva?</h2>

                <p>
                    El historial de pedidos y las reseñas se conservan
                    de forma anonimizada, sin mantener el nombre ni el
                    correo personal del usuario asociados a esos registros.
                </p>

                <p>
                    La información conservada se mantiene sin una
                    identificación personal directa. No se establece
                    aquí un plazo de eliminación para esos registros.
                </p>


                <h2>Eliminación desde la aplicación</h2>

                <p>
                    Si todavía tienes acceso a tu cuenta, también puedes
                    solicitar su eliminación desde la opción de
                    eliminación de cuenta disponible en la aplicación.
                </p>


                <p>
                    Para consultas adicionales, puedes comunicarte con
                    nuestro equipo mediante el correo de soporte indicado.
                </p>

            </main>

        </body>
        </html>
    `);

});


// ============================
// 🔹 MONTAJE DE LAS RUTAS
// ============================

app.use('/api/usuarios', userRoutes);
app.use('/api/login', loginRoutes);
app.use('/api/recuperar', recuperarRoutes);
app.use('/api/productos', productoRoutes);
app.use("/api/categorias", categoriaRoutes);

app.use('/api/mesas', mesaRoutes);
app.use('/api/ordenes', ordenesRoutes);
app.use('/api/traducir', traducirRoutes);
app.use("/api/resenas", resenaRoutes);

app.use("/api/inventario", inventarioRoutes);
app.use("/api/notificacion", notificacionRoutes);
app.use('/api/fcm', fcmRoutes);
app.use("/api/favoritos", favoritosRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/admin/usuarios", adminUsuariosRoutes);
app.use("/api/perfil", perfilRoutes);
app.use("/api/interprete", interpreteRoutes);


// ============================
// 🔹 SERVIDOR
// ============================

server.listen(PORT, () => {

    console.log(
        `Servidor corriendo en http://localhost:${PORT}`
    );

});
