import Orden from '../models/ordenes.js';
import OrdenDetalle from '../models/ordenDetalle.js';
import Producto from '../models/product.js';
import Mesa from '../models/mesa.js';

//CREAR UNA NUEVA ORDEN CON SUS PRODUCTOS

export const crearOrden = async (req, res) => {
    try {
        const { mesa, productos } = req.body;
        const mesero = req.usuario._id;

        //VALIDAMOS LOS CAMPOS

        if (!mesa || !productos || productos.length === 0) {
            return res.status(400).json({ message: 'Por favor, seleccione una mesa y al menos un producto' });
        }

        //VERIFICAMOS QUE LA MESA EXISTA Y ESTÉ ACTIVA

        const existeMesa = await Mesa.findById(mesa);
        if (!existeMesa || !existeMesa.activo) {
            return res.status(404).json({ message: 'Mesa no encontrada' });
        }

        //CREAMOS LA ORDEN

        const nuevaOrden = new Orden({ mesa, mesero });
        await nuevaOrden.save();

        //CREAMOS CADA DETALLE Y CALCULAMOS EL TOTAL

        let total = 0;
        const detalles = [];

        for (const item of productos) {
            const producto = await Producto.findById(item.producto);

            if (!producto || !producto.disponible) {
                return res.status(400).json({ message: `El producto ${item.producto} no está disponible` });
            }

            const subtotal = producto.precio * item.cantidad;
            total += subtotal;

            const detalle = new OrdenDetalle({
                orden: nuevaOrden._id,
                producto: producto._id,
                cantidad: item.cantidad,
                precioUnitario: producto.precio,
                subtotal,
                notas: item.notas
            });

            await detalle.save();
            detalles.push(detalle);
        }

        //ACTUALIZAMOS EL TOTAL DE LA ORDEN

        nuevaOrden.total = total;
        await nuevaOrden.save();

        //MARCAMOS LA MESA COMO OCUPADA

        existeMesa.estado = 'ocupada';
        await existeMesa.save();

        res.status(201).json({ message: 'Orden creada correctamente', orden: nuevaOrden, detalles });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//OBTENER TODAS LAS ÓRDENES

export const getOrdenes = async (req, res) => {
    try {
        const ordenes = await Orden.find()
            .populate('mesa', 'nombre')
            .populate('mesero', 'nombre')
            .sort({ createdAt: -1 });

        res.status(200).json({ message: 'Órdenes obtenidas correctamente', ordenes });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//OBTENER UNA ORDEN POR ID CON SUS DETALLES

export const getOrdenPorId = async (req, res) => {
    try {
        const { id } = req.params;

        const orden = await Orden.findById(id)
            .populate('mesa', 'nombre')
            .populate('mesero', 'nombre');

        if (!orden) {
            return res.status(404).json({ message: 'Orden no encontrada' });
        }

        const detalles = await OrdenDetalle.find({ orden: id }).populate('producto', 'nombre precio');

        res.status(200).json({ message: 'Orden obtenida correctamente', orden, detalles });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//AGREGAR UN PRODUCTO A UNA ORDEN EXISTENTE (SOLO SI SIGUE PENDIENTE)

export const agregarProducto = async (req, res) => {
    try {
        const { id } = req.params;
        const { producto, cantidad, notas } = req.body;

        const orden = await Orden.findById(id);
        if (!orden) {
            return res.status(404).json({ message: 'Orden no encontrada' });
        }

        if (orden.estado !== 'pendiente') {
            return res.status(400).json({ message: 'No se pueden agregar productos, la orden ya fue enviada a cocina' });
        }

        const productoDB = await Producto.findById(producto);
        if (!productoDB || !productoDB.disponible) {
            return res.status(400).json({ message: 'Producto no disponible' });
        }

        const subtotal = productoDB.precio * cantidad;

        const detalle = new OrdenDetalle({
            orden: orden._id,
            producto: productoDB._id,
            cantidad,
            precioUnitario: productoDB.precio,
            subtotal,
            notas
        });

        await detalle.save();

        //ACTUALIZAMOS EL TOTAL DE LA ORDEN

        orden.total += subtotal;
        await orden.save();

        res.status(201).json({ message: 'Producto agregado correctamente', detalle, orden });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//CAMBIAR EL ESTADO DE LA ORDEN

export const cambiarEstadoOrden = async (req, res) => {
    try {
        const { id } = req.params;
        const { estado } = req.body;

        const estadosValidos = ["pendiente", "en_cocina", "listo", "servido", "pagado", "cancelado"];
        if (!estadosValidos.includes(estado)) {
            return res.status(400).json({ message: 'Estado inválido' });
        }

        const orden = await Orden.findById(id);
        if (!orden) {
            return res.status(404).json({ message: 'Orden no encontrada' });
        }

        orden.estado = estado;
        await orden.save();

        //SI LA ORDEN SE PAGÓ O SE CANCELÓ, LIBERAMOS LA MESA

        if (estado === 'pagado' || estado === 'cancelado') {
            const mesa = await Mesa.findById(orden.mesa);
            if (mesa) {
                mesa.estado = 'libre';
                await mesa.save();
            }
        }

        res.status(200).json({ message: 'Estado de la orden actualizado', orden });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};