import mongoose from "mongoose";

const favoritosSchema = new mongoose.Schema({
    usuario: { type: mongoose.Schema.Types.ObjectId, ref: "BDusurios", required: true },
    producto: { type: mongoose.Schema.Types.ObjectId, ref: "BDproduct", required: true }
}, { timestamps: true });

const Favoritos = mongoose.models.BDfavoritos || mongoose.model("BDfavoritos", favoritosSchema, "BDfavoritos");

export default Favoritos;