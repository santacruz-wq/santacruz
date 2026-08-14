import mongoose from "mongoose";

const cocinaPedidoSchema = new mongoose.Schema({
    orden: { type: mongoose.Schema.Types.ObjectId, ref: "orden", required: true },
    estado: { type: String, enum: ["pendiente", "preparando", "listo"], default: "pendiente" },
    horaInicio: { type: Date },
    horaListo: { type: Date }
}, { timestamps: true });

const CocinaPedido = mongoose.models.cocinaPedido || mongoose.model("cocinaPedido", cocinaPedidoSchema);

export default CocinaPedido;