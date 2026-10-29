
import Groq from "groq-sdk";

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

const idiomas = {
  es: "español",
  en: "inglés",
  pt: "portugués",
  fr: "francés",
  de: "alemán",
  it: "italiano",
  zh: "chino simplificado",
  hi: "hindi",
  ar: "árabe",
  ru: "ruso",
  ja: "japonés",
  ko: "coreano",
  id: "indonesio",
  bn: "bengalí",
  tr: "turco",
};

export const traducirAudio = async (req, res) => {
  try {
    if (!process.env.GROQ_API_KEY) {
      return res.status(500).json({
        mensaje: "Falta configurar GROQ_API_KEY en el backend.",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        mensaje: "Debes enviar un archivo de audio.",
      });
    }

    const idiomaDestino = String(
      req.body.idiomaDestino || ""
    ).toLowerCase();

    const idiomaOrigen = String(
      req.body.idiomaOrigen || "auto"
    ).toLowerCase();

    if (!idiomas[idiomaDestino]) {
      return res.status(400).json({
        mensaje: "El idioma de destino no es válido.",
      });
    }

    if (idiomaOrigen !== "auto" && !idiomas[idiomaOrigen]) {
      return res.status(400).json({
        mensaje: "El idioma de origen no es válido.",
      });
    }

    const archivoAudio = new File(
      [req.file.buffer],
      req.file.originalname || "audio.wav",
      {
        type: req.file.mimetype || "audio/wav",
      }
    );

    // Transcripción multilingüe. Si se conoce el idioma de origen,
    // se lo indicamos a Whisper; con "auto" lo detecta.
    const opcionesTranscripcion = {
      file: archivoAudio,
      model: "whisper-large-v3-turbo",
      response_format: "verbose_json",
    };

    if (idiomaOrigen !== "auto") {
      opcionesTranscripcion.language = idiomaOrigen;
    }

    const transcripcion =
      await groq.audio.transcriptions.create(
        opcionesTranscripcion
      );

    const textoOriginal = transcripcion.text?.trim();

    if (!textoOriginal) {
      return res.status(422).json({
        mensaje: "No se pudo reconocer una frase en el audio.",
      });
    }

    const destino = idiomas[idiomaDestino];
    const origen =
      idiomaOrigen === "auto"
        ? "el idioma detectado automáticamente"
        : idiomas[idiomaOrigen];

    const respuesta = await groq.chat.completions.create({
      model: "openai/gpt-oss-20b",
      messages: [
        {
          role: "system",
          content:
            "Eres un intérprete profesional multilingüe. " +
            "Traduce el mensaje al idioma de destino indicado. " +
            "Conserva el significado, el tono y los nombres propios. " +
            "No respondas al mensaje original, no añadas explicaciones " +
            "y devuelve únicamente la traducción. Si el texto ya está " +
            "en el idioma de destino, devuélvelo correctamente.",
        },
        {
          role: "user",
          content:
            `Idioma de origen: ${origen}.\n` +
            `Idioma de destino: ${destino}.\n` +
            `Texto original:\n${textoOriginal}`,
        },
      ],
      temperature: 0.2,
    });

    const textoTraducido =
      respuesta.choices?.[0]?.message?.content?.trim();

    if (!textoTraducido) {
      return res.status(502).json({
        mensaje: "Groq no devolvió una traducción.",
      });
    }

    return res.json({
      textoOriginal,
      textoTraducido,
      idiomaOrigenDetectado:
        transcripcion.language || idiomaOrigen,
      idiomaDestino,
    });
  } catch (error) {
    console.error(
      "Error en el intérprete de Groq:",
      error.message
    );

    return res.status(500).json({
      mensaje: "No se pudo procesar el audio. Inténtalo de nuevo.",
    });
  }
};
