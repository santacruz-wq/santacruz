
import Traduccion from '../models/traducir.js';

const IDIOMAS_PERMITIDOS = new Set(['es', 'en']);

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body ?? {};

        if (typeof texto !== 'string' || !texto.trim()) {
            return res.status(400).json({
                message: 'Debes proporcionar un texto para traducir.',
            });
        }

        const textoLimpio = texto.trim();

        if (textoLimpio.length > 500) {
            return res.status(400).json({
                message: 'El texto no puede superar los 500 caracteres.',
            });
        }

        const origen = idiomaOrigen || 'es';

        if (
            typeof origen !== 'string' ||
            typeof idiomaDestino !== 'string' ||
            !IDIOMAS_PERMITIDOS.has(origen) ||
            !IDIOMAS_PERMITIDOS.has(idiomaDestino) ||
            origen === idiomaDestino
        ) {
            return res.status(400).json({
                message: 'Los idiomas deben ser es y en, y deben ser diferentes.',
            });
        }

        const existente = await Traduccion.findOne({
            textoOriginal: textoLimpio,
            idiomaOrigen: origen,
            idiomaDestino,
        });

        if (existente) {
            return res.status(200).json({
                message: 'Traducción obtenida de la caché.',
                textoTraducido: existente.textoTraducido,
            });
        }

        const langpair = `${origen}|${idiomaDestino}`;
        const url = new URL('https://api.mymemory.translated.net/get');

        url.searchParams.set('q', textoLimpio);
        url.searchParams.set('langpair', langpair);

        const respuesta = await fetch(url, {
            signal: AbortSignal.timeout(10000),
        });

        if (!respuesta.ok) {
            return res.status(502).json({
                message: 'El servicio de traducción no está disponible.',
            });
        }

        const data = await respuesta.json();

        if (
            data.responseStatus !== 200 ||
            typeof data.responseData?.translatedText !== 'string' ||
            !data.responseData.translatedText.trim()
        ) {
            return res.status(502).json({
                message: 'No fue posible traducir el texto.',
            });
        }

        const textoTraducido = data.responseData.translatedText.trim();

        await Traduccion.create({
            textoOriginal: textoLimpio,
            idiomaOrigen: origen,
            idiomaDestino,
            textoTraducido,
        });

        return res.status(200).json({
            message: 'Texto traducido correctamente.',
            textoTraducido,
        });
    } catch (error) {
        if (error.name === 'TimeoutError' || error.name === 'AbortError') {
            return res.status(504).json({
                message: 'El servicio de traducción tardó demasiado.',
            });
        }

        console.error('Error al traducir:', error.message);

        return res.status(500).json({
            message: 'Error interno al traducir el texto.',
        });
    }
};
