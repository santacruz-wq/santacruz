import Categoria from "../models/categoria.js";

//OBTENEMOS TODAS LAS CATEGORIAS
export const getCategorias = async (req, res) => {
    try {
        //PERMITIMOS FILTRAR SOLO ACTIVAS CON ?activo=true
        const filtro = {};
        if (req.query.activo !== undefined) {
            filtro.activo = req.query.activo === "true";
        }

        const categorias = await Categoria.find(filtro);
        res.status(200).json(categorias);
    } catch (error) {
        res.status(500).json({
            message: "Error al obtener las categorías",
            error: error.message
        });
    }
};

//OBTENEMOS CATEGORIA POR ID
export const getCategoriaPorId = async (req, res) => {
    try {
        const categoria = await Categoria.findById(req.params.id);

        if (!categoria) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        res.status(200).json(categoria);
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de categoría inválido" });
        }
        res.status(500).json({
            message: "Error al obtener la categoría",
            error: error.message
        });
    }
};

//CREAMOS CATEGORIA
export const crearCategoria = async (req, res) => {
    try {
        const { nombre, descripcion, imagen } = req.body;

        //VALIDAMOS CAMPO OBLIGATORIO
        if (!nombre) {
            return res.status(400).json({
                message: "El nombre de la categoría es requerido"
            });
        }

        //VALIDAMOS SI LA CATEGORIA YA EXISTE
        const existeCategoria = await Categoria.findOne({ nombre: nombre.trim() });

        if (existeCategoria) {
            return res.status(400).json({
                message: "La categoría ya existe"
            });
        }

        const nuevaCategoria = new Categoria({
            nombre: nombre.trim(),
            descripcion: descripcion?.trim(),
            imagen
        });

        await nuevaCategoria.save();

        res.status(201).json({
            message: "Categoría creada exitosamente",
            categoria: nuevaCategoria
        });

    } catch (error) {
        //MANEJAMOS ERROR DE CAMPO UNICO DUPLICADO
        if (error.code === 11000) {
            return res.status(400).json({ message: "La categoría ya existe" });
        }
        res.status(500).json({
            message: "Error al crear la categoría",
            error: error.message
        });
    }
};

//ACTUALIZAMOS CATEGORIA
export const actualizarCategoria = async (req, res) => {
    try {
        //EVITAMOS QUE SE FUERCE ACTIVO DESDE ESTE ENDPOINT
        const { activo, ...datosActualizar } = req.body;

        //VALIDAMOS QUE EL NOMBRE NO VENGA VACIO SI SE ENVIA
        if (datosActualizar.nombre !== undefined && !datosActualizar.nombre.trim()) {
            return res.status(400).json({
                message: "El nombre de la categoría no puede estar vacío"
            });
        }

        const categoriaActualizada = await Categoria.findByIdAndUpdate(
            req.params.id,
            datosActualizar,
            { new: true, runValidators: true }
        );

        if (!categoriaActualizada) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        res.status(200).json({
            message: "Categoría actualizada exitosamente",
            categoria: categoriaActualizada
        });

    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de categoría inválido" });
        }
        if (error.code === 11000) {
            return res.status(400).json({ message: "Ya existe una categoría con ese nombre" });
        }
        res.status(500).json({
            message: "Error al actualizar la categoría",
            error: error.message
        });
    }
};

//ELIMINAMOS CATEGORIA (SOFT DELETE)
export const eliminarCategoria = async (req, res) => {
    try {
        const categoriaEliminada = await Categoria.findByIdAndUpdate(
            req.params.id,
            { activo: false },
            { new: true }
        );

        if (!categoriaEliminada) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        res.status(200).json({
            message: "Categoría marcada como no disponible",
            categoria: categoriaEliminada
        });

    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de categoría inválido" });
        }
        res.status(500).json({
            message: "Error al eliminar la categoría",
            error: error.message
        });
    }
};