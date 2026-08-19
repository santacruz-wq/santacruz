// ============================
// 🔹 IMPORTS
// ============================
import express from 'express';
import "dotenv/config";
import { connectDB } from "./db/db.js";

// Rutas
import userRoutes from './routes/user.js';
import loginRoutes from './routes/login.js';
import recuperarRoutes from './routes/recuperar.js';
import productoRoutes from './routes/product.js';
import mesaRoutes from './routes/mesa.js';
import ordenesRoutes from './routes/ordenes.js';





// ============================
// 🔹 CONFIGURACIÓN
// ============================
const app = express();
connectDB();
app.use(express.json());

const PORT = process.env.PORT || 3000;



// ============================
// 🔹 RUTAS DE LA API
// ============================
app.use('/api/usuarios', userRoutes);
app.use('/api/login', loginRoutes);
app.use('/api/recuperar', recuperarRoutes);
app.use('/api/productos', productoRoutes);
app.use('/api/mesas', mesaRoutes);
app.use('/api/ordenes', ordenesRoutes);

// ============================
// 🔹 SERVIDOR
// ============================
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
