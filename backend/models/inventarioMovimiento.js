import mongoose from "mongoose";

const inventarioMovimientoSchema = new mongoose.Schema({
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "product", required: true },
    tipo: { type: String, enum: ["entrada", "salida"], required: true },
    cantidad: { type: Number, required: true },
    motivo: { type: String, trim: true },
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true }
}, { timestamps: true });

const InventarioMovimiento = mongoose.models.BDinventarioMovimiento || mongoose.model("BDinventarioMovimiento", inventarioMovimientoSchema, "BDinventarioMovimiento");

export default InventarioMovimiento;