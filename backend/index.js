import express from 'express';
import "dotenv/config";
import { connectDB } from "./db/db.js";

const app = express();
const port = 3000;

connectDB();
app.use(express.json());

app.listen(port, () => {
    console.log(`Servidor corriendo en el puerto ${port}`);
});