import mongoose from "mongoose";

const mesaSchema = new mongoose.Schema({
    nombre: { type: String, required: true, unique: true, trim: true },
    capacidad: { type: Number, required: true },
    estado: { type: String, enum: ["libre", "ocupada", "reservada"], default: "libre" },
    activo: { type: Boolean, default: true }
}, { timestamps: true });

const Mesa = mongoose.models.BDmesa || mongoose.model("BDmesa", mesaSchema, "BDmesa");

export default Mesa;