import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
    productId: { type: String, required: true, unique: true, trim: true },
    nombre: { type: String, required: true, trim: true },
    descripcion: { type: String, required: true, trim: true },
    precio: { type: Number, required: true },
    imagen: { type: String, default: "assets/img/fondo.avif" },
    categoria: { type: mongoose.Schema.Types.ObjectId, ref: "BDcategoria", required: true },
    disponible: { type: Boolean, default: true }
}, { timestamps: true });

const Product = mongoose.models.BDproduct || mongoose.model("BDproduct", productSchema, "BDproduct" );

export default Product;