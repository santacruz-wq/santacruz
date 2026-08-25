import Notificacion from "../models/notificacion.js";

//FUNCION PARA CREAR UNA NOTIFICACION
export const crearNotificacion = async (req, res) => {
    try {
        const { usuario, orden, mensaje } = req.body;

        //VALIDAMOS LOS CAMPOS
        if (!usuario || !orden || !mensaje) {
            return res.status(400).json({ message: "El usuario, orden y mensaje son requeridos" });
        }

        //CREAMOS LA NOTIFICACION
        const nuevaNotificacion = new Notificacion({
            usuario,
            orden,
            mensaje
        });

        await nuevaNotificacion.save();

        //EMITIMOS LA NOTIFICACION EN TIEMPO REAL SI EL USUARIO ESTA CONECTADO
        const io = req.app.get("io");
        if (io) {
            io.to(usuario.toString()).emit("nuevaNotificacion", nuevaNotificacion);
        }

        res.status(201).json({ message: "Notificacion creada correctamente", notificacion: nuevaNotificacion });

    } catch (error) {
        console.error("Error al crear la notificacion:", error);
        res.status(500).json({ message: "Error al crear la notificacion", error: error.message });
    }
};

//FUNCION PARA OBTENER LAS NOTIFICACIONES DEL USUARIO AUTENTICADO
export const getNotificaciones = async (req, res) => {
    try {
        const usuario = req.usuario._id;

        const notificaciones = await Notificacion.find({ usuario })
            .populate("orden")
            .sort({ createdAt: -1 });

        res.status(200).json({ message: "Notificaciones obtenidas correctamente", notificaciones });

    } catch (error) {
        console.error("Error al obtener las notificaciones:", error);
        res.status(500).json({ message: "Error al obtener las notificaciones", error: error.message });
    }
};

//FUNCION PARA OBTENER UNA NOTIFICACION POR ID
export const getNotificacionPorId = async (req, res) => {
    try {
        const { id } = req.params;

        const notificacion = await Notificacion.findById(id).populate("orden");

        if (!notificacion) {
            return res.status(404).json({ message: "Notificacion no encontrada" });
        }

        //VALIDAMOS QUE LA NOTIFICACION SEA DEL USUARIO AUTENTICADO
        if (notificacion.usuario.toString() !== req.usuario._id.toString()) {
            return res.status(403).json({ message: "No tienes permiso para ver esta notificacion" });
        }

        res.status(200).json({ message: "Notificacion obtenida correctamente", notificacion });

    } catch (error) {
        console.error("Error al obtener la notificacion:", error);
        res.status(500).json({ message: "Error al obtener la notificacion", error: error.message });
    }
};

//FUNCION PARA MARCAR UNA NOTIFICACION COMO LEIDA
export const marcarComoLeida = async (req, res) => {
    try {
        const { id } = req.params;

        const notificacion = await Notificacion.findById(id);
        if (!notificacion) {
            return res.status(404).json({ message: "Notificacion no encontrada" });
        }

        //VALIDAMOS QUE LA NOTIFICACION SEA DEL USUARIO AUTENTICADO
        if (notificacion.usuario.toString() !== req.usuario._id.toString()) {
            return res.status(403).json({ message: "No tienes permiso para modificar esta notificacion" });
        }

        notificacion.leida = true;
        await notificacion.save();

        res.status(200).json({ message: "Notificacion marcada como leida", notificacion });

    } catch (error) {
        console.error("Error al marcar la notificacion como leida:", error);
        res.status(500).json({ message: "Error al marcar la notificacion como leida", error: error.message });
    }
};

//FUNCION PARA MARCAR TODAS LAS NOTIFICACIONES DEL USUARIO COMO LEIDAS
export const marcarTodasComoLeidas = async (req, res) => {
    try {
        const usuario = req.usuario._id;

        await Notificacion.updateMany({ usuario, leida: false }, { leida: true });

        res.status(200).json({ message: "Todas las notificaciones fueron marcadas como leidas" });

    } catch (error) {
        console.error("Error al marcar las notificaciones como leidas:", error);
        res.status(500).json({ message: "Error al marcar las notificaciones como leidas", error: error.message });
    }
};

//FUNCION PARA ELIMINAR UNA NOTIFICACION
export const eliminarNotificacion = async (req, res) => {
    try {
        const { id } = req.params;

        const notificacion = await Notificacion.findById(id);
        if (!notificacion) {
            return res.status(404).json({ message: "Notificacion no encontrada" });
        }

        //VALIDAMOS QUE LA NOTIFICACION SEA DEL USUARIO AUTENTICADO
        if (notificacion.usuario.toString() !== req.usuario._id.toString()) {
            return res.status(403).json({ message: "No tienes permiso para eliminar esta notificacion" });
        }

        await Notificacion.findByIdAndDelete(id);
        res.status(200).json({ message: "Notificacion eliminada correctamente" });

    } catch (error) {
        console.error("Error al eliminar la notificacion:", error);
        res.status(500).json({ message: "Error al eliminar la notificacion", error: error.message });
    }
};