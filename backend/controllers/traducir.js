
import Groq from "groq-sdk";
import Traduccion from "../models/traducir.js";

const groq = new Groq({
    apiKey: process.env.GROQ_API_KEY,
});

const idiomas = {
    es: "español",
    en: "inglés",
    fr: "francés",
    pt: "portugués",
    ar: "árabe",
    "zh-hans": "chino mandarín simplificado",
    zh: "chino mandarín simplificado",
    hi: "hindi",
    de: "alemán",
    ru: "ruso",
    ja: "japonés",
    ko: "coreano",
    id: "indonesio",
    it: "italiano",
    bn: "bengalí",
    tr: "turco",
};

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body;

        if (
            typeof texto !== "string" ||
            !texto.trim() ||
            typeof idiomaDestino !== "string" ||
            !idiomaDestino.trim()
        ) {
            return res.status(400).json({
                message: "Se requiere el texto y el idioma destino",
            });
        }

        const textoOriginal = texto.trim();

        const origen = (
            typeof idiomaOrigen === "string" && idiomaOrigen.trim()
                ? idiomaOrigen
                : "es"
        ).trim().toLowerCase().replace("_", "-");

        const destino = idiomaDestino
            .trim()
            .toLowerCase()
            .replace("_", "-");

        if (origen === destino) {
            return res.status(200).json({
                textoTraducido: textoOriginal,
            });
        }

        const idiomaOrigenNombre =
            idiomas[origen] || "español";

        const idiomaDestinoNombre = idiomas[destino];

        if (!idiomaDestinoNombre) {
            return res.status(400).json({
                message: "Idioma de destino no soportado",
            });
        }

        // 1. Buscar traducción guardada en MongoDB.
        const existente = await Traduccion.findOne({
            textoOriginal,
            idiomaOrigen: origen,
            idiomaDestino: destino,
        });

        if (existente) {
            return res.status(200).json({
                message: "Traducción obtenida de caché",
                textoTraducido: existente.textoTraducido,
            });
        }

        // 2. Traducir mediante Groq.
        const completion = await groq.chat.completions.create({
            model: "openai/gpt-oss-20b",
            messages: [
                {
                    role: "system",
                    content: `
Eres un traductor profesional.

Traduce el texto recibido desde ${idiomaOrigenNombre}
hacia ${idiomaDestinoNombre}.

REGLAS:
- Devuelve únicamente la traducción.
- No agregues explicaciones ni comentarios.
- No agregues comillas.
- Conserva el significado original.
- Utiliza una traducción natural y correcta.
- Traduce nombres de productos y descripciones.
- Conserva nombres propios y marcas comerciales.
- No resumas ni elimines información.
- Respeta números, cantidades y unidades.
                    `.trim(),
                },
                {
                    role: "user",
                    content: textoOriginal,
                },
            ],
            temperature: 0.2,
            max_tokens: 300,
        });

        const textoTraducido =
            completion.choices[0]?.message?.content?.trim();

        if (!textoTraducido) {
            return res.status(502).json({
                message: "Groq no devolvió una traducción válida",
            });
        }

        // 3. Guardar la traducción en MongoDB.
        let traduccion;

        try {
            traduccion = await Traduccion.create({
                textoOriginal,
                idiomaOrigen: origen,
                idiomaDestino: destino,
                textoTraducido,
            });
        } catch (error) {
            // Evitar errores si otra solicitud guardó la misma traducción.
            if (error.code !== 11000) {
                throw error;
            }

            traduccion = await Traduccion.findOne({
                textoOriginal,
                idiomaOrigen: origen,
                idiomaDestino: destino,
            });

            if (!traduccion) {
                throw error;
            }
        }

        return res.status(200).json({
            message: "Texto traducido correctamente con Groq",
            textoTraducido: traduccion.textoTraducido,
        });

    } catch (error) {
        console.error("ERROR EN traducirTexto:", error);

        return res.status(500).json({
            message: "Error al traducir el texto con Groq",
        });
    }
};
