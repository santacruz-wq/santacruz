import mongoose from "mongoose";

//DEFINIMOS EL ESQUEMA DE TRADUCCION (CACHE DE TEXTOS TRADUCIDOS)
const traduccionSchema = new mongoose.Schema({
    textoOriginal: { type: String, required: true, trim: true },
    idiomaOrigen: { type: String, required: true, trim: true }, // ej. "es"
    idiomaDestino: { type: String, required: true, trim: true }, // ej. "en"
    textoTraducido: { type: String, required: true, trim: true }
}, { timestamps: true });

//EVITAMOS DUPLICADOS PARA LA MISMA COMBINACION TEXTO+IDIOMAS
traduccionSchema.index({ textoOriginal: 1, idiomaOrigen: 1, idiomaDestino: 1 }, { unique: true });

const Traduccion = mongoose.models.BDtraduccion || mongoose.model("BDtraduccion", traduccionSchema, "BDtraducciones");

export default Traduccion;
