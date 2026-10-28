import Traduccion from '../models/traducir.js';

//CONTROLLER PARA TRADUCIR TEXTO USANDO MYMEMORY (GRATIS, SIN API KEY)
//CON CACHÉ EN MONGO PARA NO REPETIR LLAMADAS A LA API EXTERNA

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body;

        //VALIDAMOS LOS CAMPOS

        if (!texto || !idiomaDestino) {
            return res.status(400).json({ message: 'Se requiere el texto y el idioma destino' });
        }

        const origen = idiomaOrigen || 'es';

        //BUSCAMOS SI YA EXISTE ESTA TRADUCCIÓN EN CACHÉ

        const existente = await Traduccion.findOne({
            textoOriginal: texto,
            idiomaOrigen: origen,
            idiomaDestino,
        });

        if (existente) {
            return res.status(200).json({
                message: 'Texto traducido correctamente (caché)',
                textoTraducido: existente.textoTraducido,
            });
        }

        //SI NO EXISTE, LLAMAMOS A LA API DE MYMEMORY

        const langpair = `${origen}|${idiomaDestino}`;
        const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(texto)}&langpair=${langpair}`;

        const respuesta = await fetch(url);
        const data = await respuesta.json();

        if (data.responseStatus !== 200) {
            return res.status(500).json({ message: 'Error al traducir el texto', error: data });
        }

        const textoTraducido = data.responseData.translatedText;

        //GUARDAMOS EN CACHÉ PARA LA PRÓXIMA VEZ

        await Traduccion.create({
            textoOriginal: texto,
            idiomaOrigen: origen,
            idiomaDestino,
            textoTraducido,
        });

        res.status(200).json({ message: 'Texto traducido correctamente', textoTraducido });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};