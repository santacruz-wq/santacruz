import mongoose from "mongoose";

const resenaSchema = new mongoose.Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true },
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "product", required: true },
    calificacion: { type: Number, required: true, min: 1, max: 5 },
    comentario: { type: String, trim: true }
}, { timestamps: true });

const Resena = mongoose.models.resena || mongoose.model("resena", resenaSchema);

export default Resena;