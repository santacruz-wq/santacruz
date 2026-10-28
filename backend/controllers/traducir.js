
import Traduccion from '../models/traducir.js';

// Controlador de traducción con caché en MongoDB y MyMemory.

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body;

        // Validar los datos recibidos.
        if (
            typeof texto !== 'string' ||
            !texto.trim() ||
            typeof idiomaDestino !== 'string' ||
            !idiomaDestino.trim()
        ) {
            return res.status(400).json({
                message: 'Se requiere el texto y el idioma destino',
            });
        }

        const textoOriginal = texto.trim();
        const origen = (
            typeof idiomaOrigen === 'string' && idiomaOrigen.trim()
                ? idiomaOrigen
                : 'es'
        ).trim().toLowerCase();

        const destino = idiomaDestino.trim().toLowerCase();

        if (origen === destino) {
            return res.status(200).json({
                message: 'El texto ya está en el idioma solicitado',
                textoTraducido: textoOriginal,
            });
        }

        // Buscar primero en MongoDB.
        const existente = await Traduccion.findOne({
            textoOriginal,
            idiomaOrigen: origen,
            idiomaDestino: destino,
        });

        if (existente) {
            return res.status(200).json({
                message: 'Texto traducido correctamente (caché)',
                textoTraducido: existente.textoTraducido,
            });
        }

        // Consultar MyMemory.
        const langpair = `${origen}|${destino}`;
        const url =
            `https://api.mymemory.translated.net/get?q=${encodeURIComponent(textoOriginal)}` +
            `&langpair=${encodeURIComponent(langpair)}`;

        const respuesta = await fetch(url, {
            signal: AbortSignal.timeout(10000),
        });

        if (!respuesta.ok) {
            console.error(
                'MyMemory respondió HTTP:',
                respuesta.status,
                'Texto:',
                textoOriginal
            );

            return res.status(502).json({
                message: 'El servicio de traducción no está disponible',
            });
        }

        const data = await respuesta.json();

        if (
            data.responseStatus !== 200 ||
            typeof data.responseData?.translatedText !== 'string' ||
            !data.responseData.translatedText.trim()
        ) {
            console.error('Respuesta inválida de MyMemory:', {
                status: data.responseStatus,
                details: data.responseDetails,
                quotaFinished: data.quotaFinished,
                texto: textoOriginal,
                origen,
                destino,
            });

            return res.status(502).json({
                message: 'MyMemory no pudo traducir el texto',
            });
        }

        const textoTraducido = data.responseData.translatedText.trim();

        // Guardar en caché. Si dos solicitudes intentan guardar
        // la misma traducción, recuperar el registro existente.
        let traduccion;

        try {
            traduccion = await Traduccion.create({
                textoOriginal,
                idiomaOrigen: origen,
                idiomaDestino: destino,
                textoTraducido,
            });
        } catch (error) {
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
            message: 'Texto traducido correctamente',
            textoTraducido: traduccion.textoTraducido,
        });
    } catch (error) {
        console.error('ERROR EN traducirTexto:', error);

        if (error.name === 'TimeoutError' || error.name === 'AbortError') {
            return res.status(504).json({
                message: 'Tiempo de espera agotado al traducir',
            });
        }

        return res.status(500).json({
            message: 'Error interno al traducir el texto',
        });
    }
};
