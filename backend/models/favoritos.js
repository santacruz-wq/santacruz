import mongoose from "mongoose";

const favoritosSchema = new mongoose.Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true },
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "product", required: true }
}, { timestamps: true });

const Favoritos = mongoose.models.favoritos || mongoose.model("favoritos", favoritosSchema);

export default Favoritos;