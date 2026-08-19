import product from "../models/product.js";

//OBTENEMOS TODOS LOS PRODUCTOS
export const getProductos = async (req, res) => {
    try {
        //PERMITIMOS FILTRAR SOLO DISPONIBLES 
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
            return res.status(404).json({
                message: "Producto no encontrado"
            });
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
        const {
            productId,
            nombre,
            descripcion,
            precio,
            imagen,
            categoria,
            stock
        } = req.body;

        //VALIDAMOS CAMPOS OBLIGATORIOS
        if (!productId || !nombre || !precio || !categoria) {
            return res.status(400).json({
                message: "Faltan campos obligatorios"
            });
        }

        //VALIDAMOS QUE EL PRECIO SEA UN NUMERO POSITIVO
        if (isNaN(precio) || precio <= 0) {
            return res.status(400).json({
                message: "El precio debe ser un número mayor a 0"
            });
        }

        //VALIDAMOS QUE EL STOCK, SI SE ENVIA, SEA UN NUMERO VALIDO
        if (stock !== undefined && (isNaN(stock) || stock < 0)) {
            return res.status(400).json({
                message: "El stock debe ser un número mayor o igual a 0"
            });
        }

        //VALIDAMOS SI EL PRODUCTO YA EXISTE
        const existeProducto = await product.findOne({ productId });

        if (existeProducto) {
            return res.status(400).json({
                message: "El producto ya existe"
            });
        }

        const nuevoProducto = new product({
            productId,
            nombre: nombre.trim(),
            descripcion: descripcion?.trim(),
            precio,
            imagen,
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
        //EVITAMOS QUE SE ACTUALICE EL PRODUCTID O SE FUERCE DISPONIBLE DESDE AQUI
        const { productId, disponible, ...datosActualizar } = req.body;

        //VALIDAMOS EL PRECIO SI VIENE EN EL BODY
        if (datosActualizar.precio !== undefined && (isNaN(datosActualizar.precio) || datosActualizar.precio <= 0)) {
            return res.status(400).json({
                message: "El precio debe ser un número mayor a 0"
            });
        }

        //VALIDAMOS EL STOCK SI VIENE EN EL BODY
        if (datosActualizar.stock !== undefined && (isNaN(datosActualizar.stock) || datosActualizar.stock < 0)) {
            return res.status(400).json({
                message: "El stock debe ser un número mayor o igual a 0"
            });
        }

        const productoActualizado = await product.findByIdAndUpdate(
            req.params.id,
            datosActualizar,
            { new: true, runValidators: true }
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
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al actualizar el producto",
            error: error.message
        });
    }
};

//ELIMINAMOS PRODUCTO 
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
        if (error.name === "CastError") {
            return res.status(400).json({ message: "ID de producto inválido" });
        }
        res.status(500).json({
            message: "Error al eliminar el producto",
            error: error.message
        });
    }
};