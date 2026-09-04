//CONTROLLER PARA TRADUCIR TEXTO USANDO MYMEMORY (GRATIS, SIN API KEY)

export const traducirTexto = async (req, res) => {
    try {
        const { texto, idiomaDestino, idiomaOrigen } = req.body;

        //VALIDAMOS LOS CAMPOS

        if (!texto || !idiomaDestino) {
            return res.status(400).json({ message: 'Se requiere el texto y el idioma destino' });
        }

        //LLAMAMOS A LA API DE MYMEMORY

        const origen = idiomaOrigen || 'es';
        const langpair = `${origen}|${idiomaDestino}`;
        const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(texto)}&langpair=${langpair}`;

        const respuesta = await fetch(url);
        const data = await respuesta.json();

        if (data.responseStatus !== 200) {
            return res.status(500).json({ message: 'Error al traducir el texto', error: data });
        }

        res.status(200).json({ message: 'Texto traducido correctamente', textoTraducido: data.responseData.translatedText });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};