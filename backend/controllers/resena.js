import Resena from "../models/resena.js";

//FUNCION PARA CREAR UNA RESEÑA
export const crearResena = async (req, res) => {
    try {
        const { producto, calificacion, comentario } = req.body;
        const usuario = req.usuario._id;

        //VALIDAMOS LOS CAMPOS
        if (!producto || !calificacion) {
            return res.status(400).json({ message: "El producto y la calificacion son requeridos" });
        }

        //VALIDAMOS QUE LA CALIFICACION ESTE EN EL RANGO PERMITIDO
        if (calificacion < 1 || calificacion > 5) {
            return res.status(400).json({ message: "La calificacion debe estar entre 1 y 5" });
        }

        //VALIDAMOS QUE EL USUARIO NO HAYA RESEÑADO YA ESE PRODUCTO
        const resenaExistente = await Resena.findOne({ usuario, producto });
        if (resenaExistente) {
            return res.status(400).json({ message: "Ya has dejado una reseña para este producto" });
        }

        //CREAMOS LA RESEÑA
        const nuevaResena = new Resena({
            usuario,
            producto,
            calificacion,
            comentario
        });

        await nuevaResena.save();
        res.status(201).json({ message: "Reseña creada correctamente", resena: nuevaResena });

    } catch (error) {
        console.error("Error al crear la reseña:", error);
        res.status(500).json({ message: "Error al crear la reseña", error: error.message });
    }
};

//FUNCION PARA OBTENER TODAS LAS RESEÑAS
export const getResenas = async (req, res) => {
    try {
        const resenas = await Resena.find()
            .populate("usuario", "nombre")
            .populate("producto", "nombre");

        res.status(200).json({ message: "Reseñas obtenidas correctamente", resenas });

    } catch (error) {
        console.error("Error al obtener las reseñas:", error);
        res.status(500).json({ message: "Error al obtener las reseñas", error: error.message });
    }
};

//FUNCION PARA OBTENER LAS RESEÑAS DE UN PRODUCTO ESPECIFICO
export const getResenasPorProducto = async (req, res) => {
    try {
        const { productoId } = req.params;

        const resenas = await Resena.find({ producto: productoId })
            .populate("usuario", "nombre");

        res.status(200).json({ message: "Reseñas del producto obtenidas correctamente", resenas });

    } catch (error) {
        console.error("Error al obtener las reseñas del producto:", error);
        res.status(500).json({ message: "Error al obtener las reseñas del producto", error: error.message });
    }
};

//FUNCION PARA OBTENER UNA RESEÑA POR ID
export const getResenaPorId = async (req, res) => {
    try {
        const { id } = req.params;

        const resena = await Resena.findById(id)
            .populate("usuario", "nombre")
            .populate("producto", "nombre");

        if (!resena) {
            return res.status(404).json({ message: "Reseña no encontrada" });
        }

        res.status(200).json({ message: "Reseña obtenida correctamente", resena });

    } catch (error) {
        console.error("Error al obtener la reseña:", error);
        res.status(500).json({ message: "Error al obtener la reseña", error: error.message });
    }
};

//FUNCION PARA ACTUALIZAR UNA RESEÑA
export const actualizarResena = async (req, res) => {
    try {
        const { id } = req.params;
        const { calificacion, comentario } = req.body;

        const resena = await Resena.findById(id);
        if (!resena) {
            return res.status(404).json({ message: "Reseña no encontrada" });
        }

        //VALIDAMOS QUE SOLO EL DUEÑO DE LA RESEÑA PUEDA EDITARLA
        if (resena.usuario.toString() !== req.usuario._id.toString()) {
            return res.status(403).json({ message: "No tienes permiso para editar esta reseña" });
        }

        //VALIDAMOS LA CALIFICACION SI FUE ENVIADA
        if (calificacion !== undefined) {
            if (calificacion < 1 || calificacion > 5) {
                return res.status(400).json({ message: "La calificacion debe estar entre 1 y 5" });
            }
            resena.calificacion = calificacion;
        }

        if (comentario !== undefined) {
            resena.comentario = comentario;
        }

        await resena.save();
        res.status(200).json({ message: "Reseña actualizada correctamente", resena });

    } catch (error) {
        console.error("Error al actualizar la reseña:", error);
        res.status(500).json({ message: "Error al actualizar la reseña", error: error.message });
    }
};

//FUNCION PARA ELIMINAR UNA RESEÑA
export const eliminarResena = async (req, res) => {
    try {
        const { id } = req.params;

        const resena = await Resena.findById(id);
        if (!resena) {
            return res.status(404).json({ message: "Reseña no encontrada" });
        }

        //VALIDAMOS QUE SOLO EL DUEÑO O UN ADMIN PUEDA ELIMINARLA
        const esDueno = resena.usuario.toString() === req.usuario._id.toString();
        const esAdmin = req.usuario.rol === "admin";

        if (!esDueno && !esAdmin) {
            return res.status(403).json({ message: "No tienes permiso para eliminar esta reseña" });
        }

        await Resena.findByIdAndDelete(id);
        res.status(200).json({ message: "Reseña eliminada correctamente" });

    } catch (error) {
        console.error("Error al eliminar la reseña:", error);
        res.status(500).json({ message: "Error al eliminar la reseña", error: error.message });
    }
};