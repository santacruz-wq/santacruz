import mongoose from "mongoose";

const favoritosSchema = new mongoose.Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "users", required: true },
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "product", required: true }
}, { timestamps: true });

const Favoritos = mongoose.models.BDfavoritos || mongoose.model("BDfavoritos", favoritosSchema, "BDfavoritos");

export default Favoritos;