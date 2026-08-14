import mongoose from "mongoose";

const ordenSchema = new mongoose.Schema({
    mesa: { type: mongoose.Schema.Types.ObjectId, ref: "mesa", required: true },
    mesero: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true },
    estado: { type: String, enum: ["pendiente", "en_cocina", "listo", "servido", "pagado", "cancelado"], default: "pendiente" },
    total: { type: Number, default: 0 }
}, { timestamps: true });

const Orden = mongoose.models.orden || mongoose.model("orden", ordenSchema);

export default Orden;