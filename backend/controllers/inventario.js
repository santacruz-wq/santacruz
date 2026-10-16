import mongoose from "mongoose";
import Inventario from "../models/inventario.js";
import InventarioMovimiento from "../models/inventarioMovimiento.js";

// OBTENER TODO EL INVENTARIO
export const getInventario = async (req, res) => {
  try {
    const inventario = await Inventario.find()
      .populate("producto", "nombre")
      .sort({ tipoInventario: 1, nombreInsumo: 1 });

    res.status(200).json({
      message: "Inventario obtenido correctamente",
      inventario,
    });
  } catch (error) {
    console.error("Error al obtener inventario:", error);
    res.status(500).json({
      message: "Error al obtener el inventario",
      error: error.message,
    });
  }
};

// OBTENER INVENTARIO POR PRODUCTO DEL MENÚ
export const getInventarioPorProducto = async (req, res) => {
  try {
    const { productoId } = req.params;

    if (!mongoose.isValidObjectId(productoId)) {
      return res.status(400).json({ message: "ID de producto inválido" });
    }

    const inventario = await Inventario.findOne({
      producto: productoId,
      tipoInventario: "producto",
    }).populate("producto", "nombre");

    if (!inventario) {
      return res.status(404).json({
        message: "No existe inventario para este producto",
      });
    }

    res.status(200).json({
      message: "Inventario obtenido correctamente",
      inventario,
    });
  } catch (error) {
    console.error("Error al consultar inventario:", error);
    res.status(500).json({
      message: "Error al obtener el inventario",
      error: error.message,
    });
  }
};

// CREAR INVENTARIO PARA UN PRODUCTO DEL MENÚ
export const crearInventario = async (req, res) => {
  try {
    const {
      producto,
      cantidadDisponible = 0,
      cantidadMinima = 5,
      cantidadMaxima = 100,
    } = req.body;

    if (!producto || !mongoose.isValidObjectId(producto)) {
      return res.status(400).json({
        message: "Debes seleccionar un producto válido",
      });
    }

    if (
      !Number.isFinite(Number(cantidadDisponible)) ||
      !Number.isFinite(Number(cantidadMinima)) ||
      !Number.isFinite(Number(cantidadMaxima)) ||
      Number(cantidadDisponible) < 0 ||
      Number(cantidadMinima) < 0 ||
      Number(cantidadMaxima) < Number(cantidadMinima)
    ) {
      return res.status(400).json({
        message: "Revisa las cantidades del inventario",
      });
    }

    const existente = await Inventario.findOne({ producto });

    if (existente) {
      return res.status(409).json({
        message: "Este producto ya tiene un registro de inventario",
      });
    }

    const inventario = await Inventario.create({
      producto,
      tipoInventario: "producto",
      cantidadDisponible: Number(cantidadDisponible),
      cantidadMinima: Number(cantidadMinima),
      cantidadMaxima: Number(cantidadMaxima),
    });

    res.status(201).json({
      message: "Inventario creado correctamente",
      inventario,
    });
  } catch (error) {
    console.error("Error al crear inventario:", error);
    res.status(500).json({
      message: "Error al crear el inventario",
      error: error.message,
    });
  }
};

// CREAR UN INSUMO INDEPENDIENTE
export const crearInsumo = async (req, res) => {
  try {
    const {
      nombreInsumo,
      unidadMedida,
      cantidadDisponible = 0,
      cantidadMinima = 0,
      cantidadMaxima = 100,
    } = req.body;

    if (
      typeof nombreInsumo !== "string" ||
      !nombreInsumo.trim() ||
      typeof unidadMedida !== "string" ||
      !unidadMedida.trim()
    ) {
      return res.status(400).json({
        message: "El nombre del insumo y su unidad de medida son obligatorios",
      });
    }

    const disponible = Number(cantidadDisponible);
    const minima = Number(cantidadMinima);
    const maxima = Number(cantidadMaxima);

    if (
      !Number.isFinite(disponible) ||
      !Number.isFinite(minima) ||
      !Number.isFinite(maxima) ||
      disponible < 0 ||
      minima < 0 ||
      maxima < minima
    ) {
      return res.status(400).json({
        message: "Las cantidades deben ser válidas y el máximo no puede ser menor que el mínimo",
      });
    }

    const nombre = nombreInsumo.trim();

    const existente = await Inventario.findOne({
      tipoInventario: "insumo",
      nombreInsumo: { $regex: `^${nombre.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}$`, $options: "i" },
    });

    if (existente) {
      return res.status(409).json({
        message: "Ya existe un insumo con ese nombre",
      });
    }

    const inventario = await Inventario.create({
      tipoInventario: "insumo",
      nombreInsumo: nombre,
      unidadMedida: unidadMedida.trim(),
      cantidadDisponible: disponible,
      cantidadMinima: minima,
      cantidadMaxima: maxima,
      producto: null,
    });

    res.status(201).json({
      message: "Insumo creado correctamente",
      inventario,
    });
  } catch (error) {
    console.error("Error al crear insumo:", error);

    if (error.code === 11000) {
      return res.status(409).json({
        message: "Ya existe un registro con ese nombre o producto",
      });
    }

    res.status(500).json({
      message: "Error al crear el insumo",
      error: error.message,
    });
  }
};

// ACTUALIZAR MÍNIMO Y MÁXIMO DE UN PRODUCTO O INSUMO
export const actualizarCantidadMinMax = async (req, res) => {
  try {
    const { inventarioId } = req.params;
    const { cantidadMinima, cantidadMaxima } = req.body;

    if (!mongoose.isValidObjectId(inventarioId)) {
      return res.status(400).json({
        message: "ID de inventario inválido",
      });
    }

    if (
      cantidadMinima === undefined &&
      cantidadMaxima === undefined
    ) {
      return res.status(400).json({
        message: "Debes enviar la cantidad mínima o máxima",
      });
    }

    const inventario = await Inventario.findById(inventarioId);

    if (!inventario) {
      return res.status(404).json({
        message: "No se encontró el registro de inventario",
      });
    }

    const minima =
      cantidadMinima === undefined
        ? inventario.cantidadMinima
        : Number(cantidadMinima);

    const maxima =
      cantidadMaxima === undefined
        ? inventario.cantidadMaxima
        : Number(cantidadMaxima);

    if (
      !Number.isFinite(minima) ||
      !Number.isFinite(maxima) ||
      minima < 0 ||
      maxima < minima
    ) {
      return res.status(400).json({
        message:
          "Las cantidades deben ser válidas y el máximo no puede ser menor que el mínimo",
      });
    }

    inventario.cantidadMinima = minima;
    inventario.cantidadMaxima = maxima;

    await inventario.save();

    res.status(200).json({
      message: "Límites actualizados correctamente",
      inventario,
    });
  } catch (error) {
    console.error("Error al actualizar límites:", error);

    res.status(500).json({
      message: "Error al actualizar los límites",
      error: error.message,
    });
  }
};

// REGISTRAR ENTRADA O SALIDA PARA PRODUCTO O INSUMO
export const registrarMovimiento = async (req, res) => {
  try {
    const { producto, inventarioId, tipo, cantidad, motivo } = req.body;
    const usuario = req.usuario?._id;

    if (!usuario) {
      return res.status(401).json({ message: "Debes iniciar sesión" });
    }

    if (!tipo || cantidad === undefined || cantidad === null || cantidad === "") {
      return res.status(400).json({
        message: "El tipo y la cantidad son obligatorios",
      });
    }

    if (!["entrada", "salida"].includes(tipo)) {
      return res.status(400).json({
        message: "El tipo debe ser entrada o salida",
      });
    }

    const cantidadNumero = Number(cantidad);

    if (!Number.isFinite(cantidadNumero) || cantidadNumero <= 0) {
      return res.status(400).json({
        message: "La cantidad debe ser mayor que cero",
      });
    }

    let filtro = null;

    if (inventarioId && mongoose.isValidObjectId(inventarioId)) {
      filtro = { _id: inventarioId };
    } else if (producto && mongoose.isValidObjectId(producto)) {
      filtro = { producto, tipoInventario: "producto" };
    } else {
      return res.status(400).json({
        message: "Debes seleccionar un registro de inventario válido",
      });
    }

    const inventario = await Inventario.findOne(filtro);

    if (!inventario) {
      return res.status(404).json({
        message: "No se encontró el registro de inventario",
      });
    }

    if (
      tipo === "salida" &&
      inventario.cantidadDisponible < cantidadNumero
    ) {
      return res.status(400).json({
        message: "No hay suficiente cantidad disponible",
      });
    }

    inventario.cantidadDisponible =
      tipo === "entrada"
        ? inventario.cantidadDisponible + cantidadNumero
        : inventario.cantidadDisponible - cantidadNumero;

    await inventario.save();

    const nuevoMovimiento = await InventarioMovimiento.create({
      inventario: inventario._id,
      producto: inventario.producto || undefined,
      tipo,
      cantidad: cantidadNumero,
      motivo: motivo?.trim() || "",
      usuario,
    });

    res.status(201).json({
      message: "Movimiento registrado correctamente",
      movimiento: nuevoMovimiento,
      inventario,
    });
  } catch (error) {
    console.error("Error al registrar movimiento:", error);
    res.status(500).json({
      message: "Error al registrar el movimiento",
      error: error.message,
    });
  }
};

// OBTENER TODOS LOS MOVIMIENTOS
export const getMovimientos = async (req, res) => {
  try {
    const movimientos = await InventarioMovimiento.find()
      .populate("producto", "nombre")
      .populate("inventario")
      .populate("usuario", "nombre")
      .sort({ createdAt: -1 });

    res.status(200).json({
      message: "Movimientos obtenidos correctamente",
      movimientos,
    });
  } catch (error) {
    console.error("Error al obtener movimientos:", error);
    res.status(500).json({
      message: "Error al obtener los movimientos",
      error: error.message,
    });
  }
};

// OBTENER MOVIMIENTOS POR PRODUCTO DEL MENÚ
export const getMovimientosPorProducto = async (req, res) => {
  try {
    const { productoId } = req.params;

    if (!mongoose.isValidObjectId(productoId)) {
      return res.status(400).json({ message: "ID de producto inválido" });
    }

    const movimientos = await InventarioMovimiento.find({
      producto: productoId,
    })
      .populate("producto", "nombre")
      .populate("inventario")
      .populate("usuario", "nombre")
      .sort({ createdAt: -1 });

    res.status(200).json({
      message: "Movimientos obtenidos correctamente",
      movimientos,
    });
  } catch (error) {
    console.error("Error al obtener movimientos por producto:", error);
    res.status(500).json({
      message: "Error al obtener los movimientos",
      error: error.message,
    });
  }
};