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


// ============================
// 🔹 SERVIDOR
// ============================
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
