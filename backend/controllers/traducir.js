import Traduccion from '../models/traducir.js';

const IDIOMAS_PERMITIDOS = new Set([
    'es', // Español
    'en', // Inglés
    'fr', // Francés
    'pt', // Portugués
    'it', // Italiano
    'de', // Alemán
    'ja', // Japonés
    'ko', // Coreano
    'zh', // Chino
    'ru', // Ruso
    'ar', // Árabe
    'hi', // Hindi
    'nl', // Neerlandés
    'tr', // Turco
]);

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body ?? {};

        // Validar texto.
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

        // Validar idiomas.
        const origen = idiomaOrigen || 'es';

        if (
            typeof origen !== 'string' ||
            typeof idiomaDestino !== 'string' ||
            !IDIOMAS_PERMITIDOS.has(origen) ||
            !IDIOMAS_PERMITIDOS.has(idiomaDestino) ||
            origen === idiomaDestino
        ) {
            return res.status(400).json({
                message: 'Los idiomas seleccionados no son válidos o son iguales.',
                idiomasPermitidos: [...IDIOMAS_PERMITIDOS],
            });
        }

        // Buscar primero en MongoDB para reutilizar la traducción guardada.
        const existente = await Traduccion.findOne({
            textoOriginal: textoLimpio,
            idiomaOrigen: origen,
            idiomaDestino,
        });

        if (existente) {
            return res.status(200).json({
                message: 'Traducción obtenida de MongoDB.',
                textoTraducido: existente.textoTraducido,
                desdeCache: true,
            });
        }

        // Solo consultar MyMemory cuando no existe una traducción guardada.
        const url = new URL(
            'https://api.mymemory.translated.net/get'
        );

        url.searchParams.set('q', textoLimpio);
        url.searchParams.set(
            'langpair',
            `${origen}|${idiomaDestino}`
        );

        console.log('Solicitando traducción a MyMemory:', {
            idiomaOrigen: origen,
            idiomaDestino,
            longitudTexto: textoLimpio.length,
        });

        const respuesta = await fetch(url, {
            signal: AbortSignal.timeout(15000),
            headers: {
                Accept: 'application/json',
                'User-Agent': 'SantaCruzDeLaPlazuela/1.0',
            },
        });

        if (!respuesta.ok) {
            const detalle = await respuesta.text();

            console.error('ERROR MYMEMORY:', {
                status: respuesta.status,
                respuesta: detalle,
                idiomaOrigen: origen,
                idiomaDestino,
            });

            return res.status(502).json({
                message: 'El servicio de traducción no está disponible.',
            });
        }

        const data = await respuesta.json();

        if (
            Number(data.responseStatus) !== 200 ||
            typeof data.responseData?.translatedText !== 'string' ||
            !data.responseData.translatedText.trim()
        ) {
            console.error('RESPUESTA INVÁLIDA DE MYMEMORY:', {
                responseStatus: data.responseStatus,
                responseDetails: data.responseDetails,
                quotaFinished: data.quotaFinished,
                idiomaOrigen: origen,
                idiomaDestino,
            });

            return res.status(502).json({
                message: 'No fue posible traducir el texto.',
            });
        }

        const textoTraducido =
            data.responseData.translatedText.trim();

        // Guardar la traducción para reutilizarla en próximas solicitudes.
        try {
            await Traduccion.create({
                textoOriginal: textoLimpio,
                idiomaOrigen: origen,
                idiomaDestino,
                textoTraducido,
            });
        } catch (errorBD) {
            // Si ya existe por una solicitud simultánea, recuperar la guardada.
            if (errorBD.code === 11000) {
                const traduccionGuardada = await Traduccion.findOne({
                    textoOriginal: textoLimpio,
                    idiomaOrigen: origen,
                    idiomaDestino,
                });

                if (traduccionGuardada) {
                    return res.status(200).json({
                        message: 'Traducción obtenida de MongoDB.',
                        textoTraducido: traduccionGuardada.textoTraducido,
                        desdeCache: true,
                    });
                }
            }

            // No se pierde la traducción obtenida si falla el guardado.
            console.error(
                'No se pudo guardar la traducción en MongoDB:',
                errorBD.message
            );
        }

        return res.status(200).json({
            message: 'Texto traducido correctamente.',
            textoTraducido,
            desdeCache: false,
        });
    } catch (error) {
        console.error('ERROR AL TRADUCIR:', {
            nombre: error.name,
            mensaje: error.message,
        });

        if (
            error.name === 'TimeoutError' ||
            error.name === 'AbortError'
        ) {
            return res.status(504).json({
                message: 'El servicio de traducción tardó demasiado.',
            });
        }

        return res.status(500).json({
            message: 'Error interno al traducir el texto.',
        });
    }
};