
// ============================
// 🔹 IMPORTS
// ============================
import express from 'express';
import "dotenv/config";
import http from "http";
import { Server } from "socket.io";
import { connectDB } from "./db/db.js";

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






// ============================
// 🔹 CONFIGURACIÓN
// ============================
const app = express();
connectDB();
app.use(express.json());
app.use('/uploads', express.static('uploads')); // 👈 NUEVO: sirve las imágenes de productos

const PORT = process.env.PORT || 3000;

// ============================
// 🔹 SOCKET.IO
// ============================
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: "*" }
});

//GUARDAMOS LA INSTANCIA DE IO PARA USARLA EN LOS CONTROLLERS
app.set("io", io);

io.on("connection", (socket) => {
    console.log("Cliente conectado:", socket.id);

    //EL MESERO SE UNE A UNA SALA CON SU PROPIO ID DE USUARIO
    socket.on("join", (usuarioId) => {
        socket.join(usuarioId);
        console.log(`Usuario ${usuarioId} se unió a su sala`);
    });

    socket.on("disconnect", () => {
        console.log("Cliente desconectado:", socket.id);
    });
});



// ============================
// 🔹 RUTAS DE LA API
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
app.use("/api/notificaciones", notificacionRoutes);
app.use("/api/favoritos", favoritosRoutes);
// ============================
// 🔹 SERVIDOR
// ============================
server.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});