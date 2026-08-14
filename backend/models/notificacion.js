import mongoose from "mongoose";

const notificacionSchema = new mongoose.Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true },
    orden: { type: mongoose.Schema.Types.ObjectId, ref: "orden", required: true },
    mensaje: { type: String, required: true, trim: true },
    leida: { type: Boolean, default: false }
}, { timestamps: true });

const Notificacion = mongoose.models.notificacion || mongoose.model("notificacion", notificacionSchema);

export default Notificacion;