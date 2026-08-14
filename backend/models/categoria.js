import mongoose from "mongoose";

const categoriaSchema = new mongoose.Schema({
    nombre: { type: String, required: true, unique: true, trim: true },
    descripcion: { type: String, trim: true },
    imagen: { type: String, default: "assets/img/categoria.avif" },
    activo: { type: Boolean, default: true }
}, { timestamps: true });

const Categoria = mongoose.models.categoria || mongoose.model("categoria", categoriaSchema);

export default Categoria;