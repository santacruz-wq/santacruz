
import mongoose from "mongoose";
import product from "../models/product.js";
import Categoria from "../models/categoria.js";
import Inventario from "../models/inventario.js";
import { borrarImagenCloudinary } from "../utils/cloudinary.js";

// OBTENER TODOS LOS PRODUCTOS
export const getProductos = async (req, res) => {
  try {
    const filtro = {};

    if (req.query.disponible !== undefined) {
      filtro.disponible = req.query.disponible === "true";
    }

    const productos = await product
      .find(filtro)
      .populate("categoria");

    return res.status(200).json(productos);
  } catch (error) {
    return res.status(500).json({
      message: "Error al obtener los productos",
      error: error.message,
    });
  }
};

// OBTENER PRODUCTO POR ID
export const getProductoPorId = async (req, res) => {
  try {
    const productoEncontrado = await product
      .findById(req.params.id)
      .populate("categoria");

    if (!productoEncontrado) {
      return res.status(404).json({
        message: "Producto no encontrado",
      });
    }

    return res.status(200).json(productoEncontrado);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).json({
        message: "ID de producto inválido",
      });
    }

    return res.status(500).json({
      message: "Error al obtener el producto",
      error: error.message,
    });
  }
};

// CREAR PRODUCTO
export const crearProducto = async (req, res) => {
  let nuevoProducto = null;
  let imagenSubida = null;

  try {
    const { productId, nombre, descripcion, precio, categoria } = req.body;

    imagenSubida = req.file?.path ?? null;

    if (
      !nombre?.trim() ||
      !descripcion?.trim() ||
      precio === undefined ||
      precio === "" ||
      !categoria
    ) {
      return res.status(400).json({
        message: "Nombre, descripción, precio y categoría son obligatorios",
      });
    }

    if (!mongoose.isValidObjectId(categoria)) {
      return res.status(400).json({
        message: "La categoría seleccionada no es válida",
      });
    }

    const categoriaExiste = await Categoria.findOne({
      _id: categoria,
      activo: true,
    });

    if (!categoriaExiste) {
      return res.status(400).json({
        message: "La categoría no existe o está desactivada",
      });
    }

    const precioNumero = Number(
      String(precio).trim().replace(",", "."),
    );

    if (!Number.isFinite(precioNumero) || precioNumero <= 0) {
      return res.status(400).json({
        message: "El precio debe ser un número mayor que cero",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        message: "Debes subir una imagen del producto",
      });
    }

    const identificador =
      productId?.trim() || `PROD-${Date.now()}`;

    const existeProducto = await product.findOne({
      productId: identificador,
    });

    if (existeProducto) {
      return res.status(409).json({
        message: "Ya existe un producto con ese identificador",
      });
    }

    nuevoProducto = await product.create({
      productId: identificador,
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      precio: precioNumero,
      imagen: imagenSubida,
      categoria: categoriaExiste._id,
      disponible: true,
      visibleMenu: true,
    });

    await Inventario.create({
      producto: nuevoProducto._id,
      tipoInventario: "producto",
      cantidadDisponible: 0,
      cantidadMinima: 5,
      cantidadMaxima: 100,
    });

    const productoCompleto = await product
      .findById(nuevoProducto._id)
      .populate("categoria");

    return res.status(201).json({
      message: "Producto creado con su inventario inicial",
      producto: productoCompleto,
    });
  } catch (error) {
    console.error("Error al crear producto e inventario:", error);

    if (nuevoProducto?._id) {
      try {
        await product.deleteOne({ _id: nuevoProducto._id });
      } catch (errorLimpieza) {
        console.error("Error al limpiar el producto:", errorLimpieza);
      }
    }

    if (imagenSubida) {
      try {
        await borrarImagenCloudinary(imagenSubida);
      } catch (errorImagen) {
        console.error("Error al limpiar la imagen:", errorImagen);
      }
    }

    if (error.code === 11000) {
      return res.status(409).json({
        message: "Ya existe un producto o registro de inventario duplicado",
      });
    }

    return res.status(500).json({
      message: "No se pudo crear el producto y su inventario",
      error: error.message,
    });
  }
};

// ACTUALIZAR PRODUCTO
export const actualizarProducto = async (req, res) => {
  let imagenNueva = null;
  let actualizarImagen = false;

  try {
    const { nombre, descripcion, precio, categoria } = req.body;

    const productoEncontrado = await product.findById(req.params.id);

    if (!productoEncontrado) {
      return res.status(404).json({
        message: "Producto no encontrado",
      });
    }

    const datosActualizar = {};

    if (nombre !== undefined) {
      if (!nombre.trim()) {
        return res.status(400).json({
          message: "El nombre no puede estar vacío",
        });
      }

      datosActualizar.nombre = nombre.trim();
    }

    if (descripcion !== undefined) {
      if (!descripcion.trim()) {
        return res.status(400).json({
          message: "La descripción no puede estar vacía",
        });
      }

      datosActualizar.descripcion = descripcion.trim();
    }

    if (precio !== undefined) {
      const precioNumero = Number(
        String(precio).trim().replace(",", "."),
      );

      if (!Number.isFinite(precioNumero) || precioNumero <= 0) {
        return res.status(400).json({
          message: "El precio debe ser un número mayor que cero",
        });
      }

      datosActualizar.precio = precioNumero;
    }

    if (categoria !== undefined) {
      if (!mongoose.isValidObjectId(categoria)) {
        return res.status(400).json({
          message: "La categoría seleccionada no es válida",
        });
      }

      const categoriaExiste = await Categoria.findOne({
        _id: categoria,
        activo: true,
      });

      if (!categoriaExiste) {
        return res.status(400).json({
          message: "La categoría no existe o está desactivada",
        });
      }

      datosActualizar.categoria = categoriaExiste._id;
    }

    if (req.file) {
      imagenNueva = req.file.path;
      actualizarImagen = true;
      datosActualizar.imagen = imagenNueva;
    }

    const productoActualizado = await product.findByIdAndUpdate(
      req.params.id,
      datosActualizar,
      {
        new: true,
        runValidators: true,
      },
    ).populate("categoria");

    // Borrar la imagen anterior solo después de actualizar correctamente.
    if (actualizarImagen && productoEncontrado.imagen) {
      try {
        await borrarImagenCloudinary(productoEncontrado.imagen);
      } catch (errorImagen) {
        console.error(
          "El producto se actualizó, pero no se pudo borrar la imagen anterior:",
          errorImagen,
        );
      }
    }

    return res.status(200).json({
      message: "Producto actualizado exitosamente",
      producto: productoActualizado,
    });
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).json({
        message: "ID de producto inválido",
      });
    }

    return res.status(500).json({
      message: "Error al actualizar el producto",
      error: error.message,
    });
  }
};

// ELIMINAR PRODUCTO (DESACTIVAR)
export const eliminarProducto = async (req, res) => {
  try {
    const productoEliminado = await product.findByIdAndUpdate(
      req.params.id,
      { disponible: false },
      { new: true },
    );

    if (!productoEliminado) {
      return res.status(404).json({
        message: "Producto no encontrado",
      });
    }

    return res.status(200).json({
      message: "Producto marcado como no disponible",
      producto: productoEliminado,
    });
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).json({
        message: "ID de producto inválido",
      });
    }

    return res.status(500).json({
      message: "Error al eliminar el producto",
      error: error.message,
    });
  }
};

// CAMBIAR DISPONIBILIDAD (ADMIN O COCINA)
// Esta función conserva la visibilidad del producto en el menú.
export const cambiarDisponibilidad = async (req, res) => {
  try {
    const { disponible } = req.body;

    if (typeof disponible !== "boolean") {
      return res.status(400).json({
        message: "El campo disponible debe ser verdadero o falso",
      });
    }

    const productoActualizado = await product.findByIdAndUpdate(
      req.params.id,
      { disponible },
      { new: true, runValidators: true },
    ).populate("categoria");

    if (!productoActualizado) {
      return res.status(404).json({
        message: "Producto no encontrado",
      });
    }

    return res.status(200).json({
      message: "Disponibilidad actualizada correctamente",
      producto: productoActualizado,
    });
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).json({
        message: "ID de producto inválido",
      });
    }

    return res.status(500).json({
      message: "Error al cambiar la disponibilidad",
      error: error.message,
    });
  }
};

// CAMBIAR ESTADO DEL MENÚ (SOLO ADMINISTRADOR)
// disponible: visible y se puede pedir.
// agotado: visible, pero no se puede pedir.
// oculto: no aparece en el menú y no se puede pedir.
export const cambiarEstadoMenu = async (req, res) => {
  try {
    const { estado } = req.body;

    const estadosValidos = ["disponible", "agotado", "oculto"];

    if (!estadosValidos.includes(estado)) {
      return res.status(400).json({
        message: "Estado inválido. Usa disponible, agotado u oculto.",
      });
    }

    const datosActualizar = {
      disponible: estado === "disponible",
      visibleMenu: estado !== "oculto",
    };

    const productoActualizado = await product.findByIdAndUpdate(
      req.params.id,
      datosActualizar,
      {
        new: true,
        runValidators: true,
      },
    ).populate("categoria");

    if (!productoActualizado) {
      return res.status(404).json({
        message: "Producto no encontrado",
      });
    }

    return res.status(200).json({
      message: "Estado del producto actualizado correctamente",
      producto: productoActualizado,
    });
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(400).json({
        message: "ID de producto inválido",
      });
    }

    return res.status(500).json({
      message: "Error al cambiar el estado del producto",
      error: error.message,
    });
  }
};
