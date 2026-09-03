import product from "../models/product.js";
import { borrarImagenCloudinary } from "../utils/cloudinary.js";

//OBTENEMOS TODOS LOS PRODUCTOS
export const getProductos = async (req, res) => {
    try {
        const filtro = {};
        if (req.query.disponible !== undefined) {
            filtro.disponible = req.query.disponible === "true";
        }

        const productos = await product.find(filtro).populate("categoria");
        res.status(200).json(productos);
    } catch (error) {
        res.status(500).json({
            message: "Error al obtener los productos",
            error: error.message
        });
    }
};

//OBTENEMOS PRODUCTO POR ID
export const getProductoPorId = async (req, res) => {
    try {
        const producto = await product.findById(req.params.id).populate("categoria");

        if (!producto) {
            return res.status(404).json({ message: "Producto no encontrado" });
        }

        res.status(200).json(producto);
    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al obtener el producto",
            error: error.message
        });
    }
};

//CREAMOS PRODUCTO
export const crearProducto = async (req, res) => {
    try {
      console.log("BODY RECIBIDO:", req.body);
        console.log("ARCHIVO RECIBIDO:", req.file);

        let { productId, nombre, descripcion, precio, categoria, stock } = req.body;

        if (!productId) {
            productId = `PROD-${Date.now()}`;
        }

        if (!nombre || !precio || !categoria) {
            return res.status(400).json({ message: "Faltan campos obligatorios" });
        }

        if (isNaN(precio) || precio <= 0) {
            return res.status(400).json({ message: "El precio debe ser un número mayor a 0" });
        }

        if (stock !== undefined && (isNaN(stock) || stock < 0)) {
            return res.status(400).json({ message: "El stock debe ser un número mayor o igual a 0" });
        }

        const existeProducto = await product.findOne({ productId });
        if (existeProducto) {
            return res.status(400).json({ message: "El producto ya existe" });
        }

        //VALIDAMOS QUE SE HAYA SUBIDO UNA IMAGEN
        if (!req.file) {
            return res.status(400).json({ message: "Debes subir una imagen del producto" });
        }

        const nuevoProducto = new product({
            productId,
            nombre: nombre.trim(),
            descripcion: descripcion?.trim(),
            precio,
            imagen: req.file.path, // URL provista por Cloudinary
            categoria,
            stock: stock ?? 0
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

//ACTUALIZAMOS PRODUCTO
export const actualizarProducto = async (req, res) => {
    try {
        const { productId, disponible, imagen, ...datosActualizar } = req.body;

        if (datosActualizar.precio !== undefined && (isNaN(datosActualizar.precio) || datosActualizar.precio <= 0)) {
            return res.status(400).json({ message: "El precio debe ser un número mayor a 0" });
        }

        if (datosActualizar.stock !== undefined && (isNaN(datosActualizar.stock) || datosActualizar.stock < 0)) {
            return res.status(400).json({ message: "El stock debe ser un número mayor o igual a 0" });
        }

        const producto = await product.findById(req.params.id);
        if (!producto) {
            return res.status(404).json({ message: "Producto no encontrado" });
        }

        //SI SE ENVIA UNA IMAGEN NUEVA, BORRAMOS LA ANTERIOR EN CLOUDINARY
        if (req.file) {
            await borrarImagenCloudinary(producto.imagen);
            datosActualizar.imagen = req.file.path;
        }

        const productoActualizado = await product.findByIdAndUpdate(
            req.params.id,
            datosActualizar,
            { new: true, runValidators: true }
        );

        res.status(200).json({
            message: "Producto actualizado exitosamente",
            producto: productoActualizado
        });

    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al actualizar el producto",
            error: error.message
        });
    }
};

//ELIMINAMOS PRODUCTO (SOFT DELETE)
export const eliminarProducto = async (req, res) => {
    try {
        const productoEliminado = await product.findByIdAndUpdate(
            req.params.id,
            { disponible: false },
            { new: true }
        );

        if (!productoEliminado) {
            return res.status(404).json({ message: "Producto no encontrado" });
        }

        res.status(200).json({
            message: "Producto marcado como no disponible",
            producto: productoEliminado
        });

    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al eliminar el producto",
            error: error.message
        });
    }
};

//CAMBIAMOS SOLO LA DISPONIBILIDAD (ADMIN O COCINA)
export const cambiarDisponibilidad = async (req, res) => {
    try {
        const { disponible } = req.body;

        if (disponible === undefined) {
            return res.status(400).json({ message: "El campo disponible es requerido" });
        }

        const productoActualizado = await product.findByIdAndUpdate(
            req.params.id,
            { disponible },
            { new: true }
        );

        if (!productoActualizado) {
            return res.status(404).json({ message: "Producto no encontrado" });
        }

        res.status(200).json({
            message: "Disponibilidad actualizada correctamente",
            producto: productoActualizado
        });

    } catch (error) {
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al cambiar la disponibilidad",
            error: error.message
        });
    }
};