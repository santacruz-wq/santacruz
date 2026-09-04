import Groq from "groq-sdk";
import Producto from "../models/product.js";

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

export const chatearConBarista = async (req, res) => {
try {
    const { mensaje } = req.body;

    if (!mensaje || !mensaje.trim()) {
    return res.status(400).json({ message: "Debes enviar un mensaje válido." });
    }

    // Consultar solo los productos disponibles directamente en MongoDB
    const productos = await Producto.find({ disponible: true }, "nombre descripcion precio").lean();

    if (!productos || productos.length === 0) {
    return res.status(200).json({
        respuesta: "¡Hola! En este momento no tenemos productos disponibles en el menú."
    });
    }

    const catalogoTexto = productos.map(p =>
      `- **${p.nombre}**: $${p.precio.toLocaleString("es-CO")} COP | Descripción: ${p.descripcion}`
    ).join("\n");

    const systemPrompt = `
Eres el asistente virtual de Santa Cruz de la Plazuela: cálido, educado y muy natural.

CATÁLOGO DISPONIBLE:
${catalogoTexto}

PAUTAS DE ATENCIÓN:
1. SALUDOS INICIALES: si el cliente solo saluda, responde cordialmente sin enviar el catálogo:
"¡Hola! Bienvenido a Santa Cruz de la Plazuela ☕ ¿En qué te puedo colaborar hoy?"
Nunca envíes el catálogo ni precios si no los han pedido explícitamente.

2. MENÚ Y PRECIOS: si preguntan qué hay disponible o los precios, entrégalos según el catálogo, en pesos colombianos ($ COP).

3. RECOMENDACIONES: usa las descripciones del catálogo para sugerir según los gustos del cliente.

4. PRODUCTOS FUERA DEL CATÁLOGO: si preguntan por algo que no está, acláralo con amabilidad y ofrece lo disponible.

5. Sé conciso y completa tus oraciones con claridad.
`;

    const completion = await groq.chat.completions.create({
    model: "openai/gpt-oss-20b",
    messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: mensaje }
    ],
    temperature: 0.3,
    max_tokens: 500,
    });

    const respuestaTexto = completion.choices[0]?.message?.content || "No pude generar una respuesta.";

    return res.status(200).json({ respuesta: respuestaTexto });

} catch (error) {
    console.error("Error en Groq Chat:", error);
    return res.status(500).json({
    message: "Error al procesar la respuesta del asistente",
    error: error.message
    });
}
};