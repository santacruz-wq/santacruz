
import Traduccion from '../models/traducir.js';

// Traducción con MyMemory y caché en MongoDB.

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

        // Si ambos idiomas son iguales, no es necesario traducir.
        if (origen === destino) {
            return res.status(200).json({
                message: 'El texto ya está en el idioma solicitado',
                textoTraducido: textoOriginal,
            });
        }

        // 1. Buscar la traducción en MongoDB.
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

        // 2. Preparar la petición a MyMemory.
        const parametros = new URLSearchParams({
            q: textoOriginal,
            langpair: `${origen}|${destino}`,
        });

        // El correo aumenta la cuota disponible de MyMemory.
        if (process.env.MYMEMORY_EMAIL) {
            parametros.set('de', process.env.MYMEMORY_EMAIL.trim());
        }

        const url =
            `https://api.mymemory.translated.net/get?${parametros.toString()}`;

        const respuesta = await fetch(url, {
            signal: AbortSignal.timeout(10000),
        });

        // 3. Comprobar la respuesta HTTP.
        if (!respuesta.ok) {
            console.error(
                'MyMemory respondió HTTP:',
                respuesta.status,
                'Texto:',
                textoOriginal
            );

            if (respuesta.status === 429) {
                return res.status(503).json({
                    message: 'Se alcanzó el límite de traducciones. Intenta más tarde.',
                });
            }

            return res.status(502).json({
                message: 'El servicio de traducción no está disponible',
            });
        }

        const data = await respuesta.json();

        // 4. Validar la traducción devuelta.
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

            if (data.responseStatus === 429 || data.quotaFinished === true) {
                return res.status(503).json({
                    message: 'Se alcanzó el límite de traducciones. Intenta más tarde.',
                });
            }

            return res.status(502).json({
                message: 'MyMemory no pudo traducir el texto',
            });
        }

        const textoTraducido = data.responseData.translatedText.trim();

        // 5. Guardar la traducción para reutilizarla.
        let traduccion;

        try {
            traduccion = await Traduccion.create({
                textoOriginal,
                idiomaOrigen: origen,
                idiomaDestino: destino,
                textoTraducido,
            });
        } catch (error) {
            // Otra solicitud pudo guardar la misma traducción al mismo tiempo.
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

        if (
            error.name === 'TimeoutError' ||
            error.name === 'AbortError'
        ) {
            return res.status(504).json({
                message: 'Tiempo de espera agotado al traducir',
            });
        }

        return res.status(500).json({
            message: 'Error interno al traducir el texto',
        });
    }
};
