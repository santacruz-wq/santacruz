import Categoria from "../models/categoria.js";

// Obtener categorías.
// GET /api/categorias
// GET /api/categorias?activo=true
// GET /api/categorias?activo=false
export const getCategorias = async (req, res) => {
    try {
        const filtro = {};

        if (req.query.activo !== undefined) {
            if (
                req.query.activo !== "true" &&
                req.query.activo !== "false"
            ) {
                return res.status(400).json({
                    message: "El filtro activo debe ser true o false"
                });
            }

            filtro.activo = req.query.activo === "true";
        }

        const categorias = await Categoria.find(filtro).sort({
            nombre: 1
        });

        return res.status(200).json(categorias);
    } catch (error) {
        return res.status(500).json({
            message: "Error al obtener las categorías",
            error: error.message
        });
    }
};

// Obtener una categoría por ID.
export const getCategoriaPorId = async (req, res) => {
    try {
        const categoria = await Categoria.findById(req.params.id);

        if (!categoria) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        return res.status(200).json(categoria);
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({
                message: "ID de categoría inválido"
            });
        }

        return res.status(500).json({
            message: "Error al obtener la categoría",
            error: error.message
        });
    }
};

// Crear una categoría.
export const crearCategoria = async (req, res) => {
    try {
        const { nombre, descripcion, imagen } = req.body;

        if (typeof nombre !== "string" || !nombre.trim()) {
            return res.status(400).json({
                message: "El nombre de la categoría es requerido"
            });
        }

        const nombreLimpio = nombre.trim();

        const existeCategoria = await Categoria.findOne({
            nombre: nombreLimpio
        });

        if (existeCategoria) {
            return res.status(400).json({
                message: existeCategoria.activo
                    ? "La categoría ya existe"
                    : "Ya existe una categoría inactiva con ese nombre. Reactívala para volver a utilizarla."
            });
        }

        const nuevaCategoria = new Categoria({
            nombre: nombreLimpio,
            descripcion:
                typeof descripcion === "string"
                    ? descripcion.trim()
                    : "",
            imagen:
                typeof imagen === "string" && imagen.trim()
                    ? imagen.trim()
                    : "assets/img/categoria.avif",
            activo: true
        });

        await nuevaCategoria.save();

        return res.status(201).json({
            message: "Categoría creada exitosamente",
            categoria: nuevaCategoria
        });
    } catch (error) {
        if (error.code === 11000) {
            return res.status(400).json({
                message: "La categoría ya existe"
            });
        }

        return res.status(500).json({
            message: "Error al crear la categoría",
            error: error.message
        });
    }
};

// Actualizar nombre, descripción o imagen.
// No permite cambiar activo desde esta ruta.
export const actualizarCategoria = async (req, res) => {
    try {
        const { activo, ...datosActualizar } = req.body;

        if (
            datosActualizar.nombre !== undefined &&
            (
                typeof datosActualizar.nombre !== "string" ||
                !datosActualizar.nombre.trim()
            )
        ) {
            return res.status(400).json({
                message: "El nombre de la categoría no puede estar vacío"
            });
        }

        if (datosActualizar.nombre !== undefined) {
            datosActualizar.nombre = datosActualizar.nombre.trim();
        }

        if (datosActualizar.descripcion !== undefined) {
            datosActualizar.descripcion =
                typeof datosActualizar.descripcion === "string"
                    ? datosActualizar.descripcion.trim()
                    : "";
        }

        if (datosActualizar.imagen !== undefined) {
            datosActualizar.imagen =
                typeof datosActualizar.imagen === "string"
                    ? datosActualizar.imagen.trim()
                    : "";
        }

        const categoriaActualizada =
            await Categoria.findByIdAndUpdate(
                req.params.id,
                datosActualizar,
                {
                    new: true,
                    runValidators: true
                }
            );

        if (!categoriaActualizada) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        return res.status(200).json({
            message: "Categoría actualizada exitosamente",
            categoria: categoriaActualizada
        });
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({
                message: "ID de categoría inválido"
            });
        }

        if (error.code === 11000) {
            return res.status(400).json({
                message: "Ya existe una categoría con ese nombre"
            });
        }

        return res.status(500).json({
            message: "Error al actualizar la categoría",
            error: error.message
        });
    }
};

// Cambiar el estado de una categoría.
// PATCH /api/categorias/:id/estado
export const cambiarEstadoCategoria = async (req, res) => {
    try {
        const { activo } = req.body;

        if (typeof activo !== "boolean") {
            return res.status(400).json({
                message: "El campo activo debe ser verdadero o falso"
            });
        }

        const categoriaActualizada =
            await Categoria.findByIdAndUpdate(
                req.params.id,
                { activo },
                {
                    new: true,
                    runValidators: true
                }
            );

        if (!categoriaActualizada) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        return res.status(200).json({
            message: activo
                ? "Categoría reactivada correctamente"
                : "Categoría desactivada correctamente",
            categoria: categoriaActualizada
        });
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({
                message: "ID de categoría inválido"
            });
        }

        return res.status(500).json({
            message: "Error al cambiar el estado de la categoría",
            error: error.message
        });
    }
};

// Desactivar una categoría mediante DELETE.
// Se conserva para compatibilidad con el servicio Flutter.
export const eliminarCategoria = async (req, res) => {
    try {
        const categoriaEliminada =
            await Categoria.findByIdAndUpdate(
                req.params.id,
                { activo: false },
                {
                    new: true,
                    runValidators: true
                }
            );

        if (!categoriaEliminada) {
            return res.status(404).json({
                message: "Categoría no encontrada"
            });
        }

        return res.status(200).json({
            message: "Categoría desactivada correctamente",
            categoria: categoriaEliminada
        });
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({
                message: "ID de categoría inválido"
            });
        }

        return res.status(500).json({
            message: "Error al desactivar la categoría",
            error: error.message
        });
    }
};
