import mongoose from "mongoose";

const ordenDetalleSchema = new mongoose.Schema({
    orden: { type: mongoose.Schema.Types.ObjectId, ref: "BDordenes", required: true },
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "BDproduct", required: true },
    cantidad: { type: Number, required: true, default: 1 },
    precioUnitario: { type: Number, required: true },
    subtotal: { type: Number, required: true },
    notas: { type: String, trim: true }
}, { timestamps: true });

const OrdenDetalle = mongoose.models.BDordenDetalle || mongoose.model("BDordenDetalle", ordenDetalleSchema, "BDordenDetalle");

export default OrdenDetalle;