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
//CONTROLLER PARA TRADUCIR TEXTO USANDO LIBRETRANSLATE

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body;

        //VALIDAMOS LOS CAMPOS

        if (!texto || !idiomaDestino) {
            return res.status(400).json({ message: 'Se requiere el texto y el idioma destino' });
        }

        //LLAMAMOS A LA API DE LIBRETRANSLATE

        const respuesta = await fetch('https://libretranslate.com/translate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                q: texto,
                source: idiomaOrigen || 'es',
                target: idiomaDestino,
                format: 'text'
            })
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            return res.status(500).json({ message: 'Error al traducir el texto', error: data });
        }

        res.status(200).json({ message: 'Texto traducido correctamente', textoTraducido: data.translatedText });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};
