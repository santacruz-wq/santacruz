import Inventario from "../models/inventario.js";
import InventarioMovimiento from "../models/inventarioMovimiento.js";

//FUNCION PARA OBTENER TODO EL INVENTARIO
export const getInventario = async (req, res) => {
    try {
        const inventario = await Inventario.find().populate("producto", "nombre");

        res.status(200).json({ message: "Inventario obtenido correctamente", inventario });

    } catch (error) {
        console.error("Error al obtener el inventario:", error);
        res.status(500).json({ message: "Error al obtener el inventario", error: error.message });
    }
};

//FUNCION PARA OBTENER EL INVENTARIO DE UN PRODUCTO ESPECIFICO
export const getInventarioPorProducto = async (req, res) => {
    try {
        const { productoId } = req.params;

        const inventario = await Inventario.findOne({ producto: productoId }).populate("producto", "nombre");

        if (!inventario) {
            return res.status(404).json({ message: "No existe registro de inventario para este producto" });
        }

        res.status(200).json({ message: "Inventario del producto obtenido correctamente", inventario });

    } catch (error) {
        console.error("Error al obtener el inventario del producto:", error);
        res.status(500).json({ message: "Error al obtener el inventario del producto", error: error.message });
    }
};

//FUNCION PARA CREAR EL REGISTRO DE INVENTARIO DE UN PRODUCTO NUEVO
export const crearInventario = async (req, res) => {
    try {
        const { producto, cantidadDisponible, cantidadMinima } = req.body;

        //VALIDAMOS LOS CAMPOS
        if (!producto) {
            return res.status(400).json({ message: "El producto es requerido" });
        }

        //VALIDAMOS QUE NO EXISTA YA UN REGISTRO DE INVENTARIO PARA ESE PRODUCTO
        const inventarioExistente = await Inventario.findOne({ producto });
        if (inventarioExistente) {
            return res.status(400).json({ message: "Ya existe un registro de inventario para este producto" });
        }

        //CREAMOS EL REGISTRO DE INVENTARIO
        const nuevoInventario = new Inventario({
            producto,
            cantidadDisponible: cantidadDisponible || 0,
            cantidadMinima: cantidadMinima || 5
        });

        await nuevoInventario.save();
        res.status(201).json({ message: "Inventario creado correctamente", inventario: nuevoInventario });

    } catch (error) {
        console.error("Error al crear el inventario:", error);
        res.status(500).json({ message: "Error al crear el inventario", error: error.message });
    }
};

//FUNCION PARA ACTUALIZAR LA CANTIDAD MINIMA DE UN PRODUCTO
export const actualizarCantidadMinima = async (req, res) => {
    try {
        const { productoId } = req.params;
        const { cantidadMinima } = req.body;

        //VALIDAMOS EL CAMPO
        if (cantidadMinima === undefined) {
            return res.status(400).json({ message: "La cantidadMinima es requerida" });
        }

        const inventario = await Inventario.findOneAndUpdate(
            { producto: productoId },
            { cantidadMinima },
            { new: true }
        );

        if (!inventario) {
            return res.status(404).json({ message: "No existe registro de inventario para este producto" });
        }

        res.status(200).json({ message: "Cantidad minima actualizada correctamente", inventario });

    } catch (error) {
        console.error("Error al actualizar la cantidad minima:", error);
        res.status(500).json({ message: "Error al actualizar la cantidad minima", error: error.message });
    }
};

//FUNCION PARA REGISTRAR UN MOVIMIENTO DE INVENTARIO (ENTRADA O SALIDA)
export const registrarMovimiento = async (req, res) => {
    try {
        const { producto, tipo, cantidad, motivo } = req.body;
        const usuario = req.usuario._id;

        //VALIDAMOS LOS CAMPOS
        if (!producto || !tipo || !cantidad) {
            return res.status(400).json({ message: "El producto, tipo y cantidad son requeridos" });
        }

        //VALIDAMOS EL TIPO DE MOVIMIENTO
        if (!["entrada", "salida"].includes(tipo)) {
            return res.status(400).json({ message: "El tipo debe ser entrada o salida" });
        }

        //VALIDAMOS QUE LA CANTIDAD SEA POSITIVA
        if (cantidad <= 0) {
            return res.status(400).json({ message: "La cantidad debe ser mayor a cero" });
        }

        //BUSCAMOS EL INVENTARIO DEL PRODUCTO
        const inventario = await Inventario.findOne({ producto });
        if (!inventario) {
            return res.status(404).json({ message: "No existe registro de inventario para este producto" });
        }

        //VALIDAMOS QUE HAYA STOCK SUFICIENTE SI ES SALIDA
        if (tipo === "salida" && inventario.cantidadDisponible < cantidad) {
            return res.status(400).json({ message: "No hay suficiente stock disponible para esta salida" });
        }

        //ACTUALIZAMOS LA CANTIDAD DISPONIBLE
        if (tipo === "entrada") {
            inventario.cantidadDisponible += cantidad;
        } else {
            inventario.cantidadDisponible -= cantidad;
        }
        await inventario.save();

        //REGISTRAMOS EL MOVIMIENTO
        const nuevoMovimiento = new InventarioMovimiento({
            producto,
            tipo,
            cantidad,
            motivo,
            usuario
        });
        await nuevoMovimiento.save();

        res.status(201).json({
            message: "Movimiento registrado correctamente",
            movimiento: nuevoMovimiento,
            inventario
        });

    } catch (error) {
        console.error("Error al registrar el movimiento:", error);
        res.status(500).json({ message: "Error al registrar el movimiento", error: error.message });
    }
};

//FUNCION PARA OBTENER TODOS LOS MOVIMIENTOS
export const getMovimientos = async (req, res) => {
    try {
        const movimientos = await InventarioMovimiento.find()
            .populate("producto", "nombre")
            .populate("usuario", "nombre")
            .sort({ createdAt: -1 });

        res.status(200).json({ message: "Movimientos obtenidos correctamente", movimientos });

    } catch (error) {
        console.error("Error al obtener los movimientos:", error);
        res.status(500).json({ message: "Error al obtener los movimientos", error: error.message });
    }
};

//FUNCION PARA OBTENER LOS MOVIMIENTOS DE UN PRODUCTO ESPECIFICO
export const getMovimientosPorProducto = async (req, res) => {
    try {
        const { productoId } = req.params;

        const movimientos = await InventarioMovimiento.find({ producto: productoId })
            .populate("usuario", "nombre")
            .sort({ createdAt: -1 });

        res.status(200).json({ message: "Movimientos del producto obtenidos correctamente", movimientos });

    } catch (error) {
        console.error("Error al obtener los movimientos del producto:", error);
        res.status(500).json({ message: "Error al obtener los movimientos del producto", error: error.message });
    }
};