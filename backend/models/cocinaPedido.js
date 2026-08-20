import mongoose from "mongoose";

const cocinaPedidoSchema = new mongoose.Schema({
    orden: { type: mongoose.Schema.Types.ObjectId, ref: "orden", required: true },
    estado: { type: String, enum: ["pendiente", "preparando", "listo"], default: "pendiente" },
    horaInicio: { type: Date },
    horaListo: { type: Date }
}, { timestamps: true });

const CocinaPedido = mongoose.models.BDcocinaPedido || mongoose.model("BDcocinaPedido", cocinaPedidoSchema, "BDcocinaPedido");

export default CocinaPedido;