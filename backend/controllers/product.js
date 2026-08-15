import product from "../models/product.js";

// Obtener todos los productos
export const getProductos = async (req, res) => {
    try {
        const productos = await product.find().populate("categoria");
        res.status(200).json(productos);
    } catch (error) {
        res.status(500).json({
            message: "Error al obtener los productos",
            error: error.message
        });
    }
};

// Obtener producto por ID
export const getProductoPorId = async (req, res) => {
    try {
        const producto = await product.findById(req.params.id).populate("categoria");

        if (!producto) {
            return res.status(404).json({
                message: "Producto no encontrado"
            });
        }

        res.status(200).json(producto);
    } catch (error) {
        res.status(500).json({
            message: "Error al obtener el producto",
            error: error.message
        });
    }
};

// Crear producto
export const crearProducto = async (req, res) => {
    try {
        const {
            productId,
            nombre,
            descripcion,
            precio,
            imagen,
            categoria,
            stock
        } = req.body;

        // Validar campos obligatorios (usando minúsculas y productId)
        if (!productId || !nombre || !precio || !categoria) {
            return res.status(400).json({
                message: "Faltan campos obligatorios"
            });
        }

        // Validar si el producto ya existe
        const existeProducto = await product.findOne({ productId });

        if (existeProducto) {
            return res.status(400).json({
                message: "El producto ya existe"
            });
        }

        const nuevoProducto = new product({
            productId,
            nombre,
            descripcion,
            precio,
            imagen,
            categoria,
            stock
        });

        await nuevoProducto.save();

        res.status(201).json({
            message: "Producto creado exitosamente",
            producto: nuevoProducto
        });

    } catch (error) {
        res.status(500).json({
            message: "Error al crear el producto",
            error: error.message
        });
    }
};

// Actualizar producto
export const actualizarProducto = async (req, res) => {
    try {
        const productoActualizado = await product.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );

        if (!productoActualizado) {
            return res.status(404).json({
                message: "Producto no encontrado"
            });
        }

        res.status(200).json({
            message: "Producto actualizado exitosamente",
            producto: productoActualizado
        });

    } catch (error) {
        res.status(500).json({
            message: "Error al actualizar el producto",
            error: error.message
        });
    }
};

// Eliminar producto 
export const eliminarProducto = async (req, res) => {
    try {
        const productoEliminado = await product.findByIdAndUpdate(
            req.params.id,
            { disponible: false },
            { new: true }
        );

        if (!productoEliminado) {
            return res.status(404).json({
                message: "Producto no encontrado"
            });
        }

        res.status(200).json({
            message: "Producto marcado como no disponible",
            producto: productoEliminado
        });

    } catch (error) {
        res.status(500).json({
            message: "Error al eliminar el producto",
            error: error.message
        });
    }
};