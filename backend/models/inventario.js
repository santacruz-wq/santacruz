import mongoose from "mongoose";

const inventarioSchema = new mongoose.Schema({
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "product", required: true, unique: true },
    cantidadDisponible: { type: Number, required: true, default: 0 },
    cantidadMinima: { type: Number, default: 5 }
}, { timestamps: true });

const Inventario = mongoose.models.inventario || mongoose.model("inventario", inventarioSchema);

export default Inventario;