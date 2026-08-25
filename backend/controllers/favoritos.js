import Favoritos from "../models/favoritos.js";

//FUNCION PARA AGREGAR UN PRODUCTO A FAVORITOS
export const agregarFavorito = async (req, res) => {
    try {
        const { producto } = req.body;
        const usuario = req.usuario._id;

        //VALIDAMOS EL CAMPO
        if (!producto) {
            return res.status(400).json({ message: "El producto es requerido" });
        }

        //VALIDAMOS QUE NO EXISTA YA EL FAVORITO
        const favoritoExistente = await Favoritos.findOne({ usuario, producto });
        if (favoritoExistente) {
            return res.status(400).json({ message: "Este producto ya esta en tus favoritos" });
        }

        //CREAMOS EL FAVORITO
        const nuevoFavorito = new Favoritos({
            usuario,
            producto
        });

        await nuevoFavorito.save();
        res.status(201).json({ message: "Producto agregado a favoritos correctamente", favorito: nuevoFavorito });

    } catch (error) {
        console.error("Error al agregar el favorito:", error);
        res.status(500).json({ message: "Error al agregar el favorito", error: error.message });
    }
};

//FUNCION PARA OBTENER LOS FAVORITOS DEL USUARIO AUTENTICADO
export const getFavoritos = async (req, res) => {
    try {
        const usuario = req.usuario._id;

        const favoritos = await Favoritos.find({ usuario }).populate("producto");

        res.status(200).json({ message: "Favoritos obtenidos correctamente", favoritos });

    } catch (error) {
        console.error("Error al obtener los favoritos:", error);
        res.status(500).json({ message: "Error al obtener los favoritos", error: error.message });
    }
};

//FUNCION PARA VERIFICAR SI UN PRODUCTO ES FAVORITO DEL USUARIO
export const verificarFavorito = async (req, res) => {
    try {
        const { productoId } = req.params;
        const usuario = req.usuario._id;

        const favorito = await Favoritos.findOne({ usuario, producto: productoId });

        res.status(200).json({ message: "Verificacion realizada correctamente", esFavorito: !!favorito });

    } catch (error) {
        console.error("Error al verificar el favorito:", error);
        res.status(500).json({ message: "Error al verificar el favorito", error: error.message });
    }
};

//FUNCION PARA ELIMINAR UN PRODUCTO DE FAVORITOS
export const eliminarFavorito = async (req, res) => {
    try {
        const { productoId } = req.params;
        const usuario = req.usuario._id;

        const favorito = await Favoritos.findOneAndDelete({ usuario, producto: productoId });

        if (!favorito) {
            return res.status(404).json({ message: "Este producto no esta en tus favoritos" });
        }

        res.status(200).json({ message: "Producto eliminado de favoritos correctamente" });

    } catch (error) {
        console.error("Error al eliminar el favorito:", error);
        res.status(500).json({ message: "Error al eliminar el favorito", error: error.message });
    }
};