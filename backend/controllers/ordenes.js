import Orden from '../models/ordenes.js';
import OrdenDetalle from '../models/ordenDetalle.js';
import Producto from '../models/product.js';
import Mesa from '../models/mesa.js';

// ============================
// CREAR UNA NUEVA ORDEN
// ============================

export const crearOrden = async (req, res) => {
    try {
        const { mesa, productos } = req.body;
        const mesero = req.usuario._id;

        if (!mesa || !Array.isArray(productos) || productos.length === 0) {
            return res.status(400).json({
                message: 'Por favor, seleccione una mesa y al menos un producto'
            });
        }

        const existeMesa = await Mesa.findById(mesa);

        if (!existeMesa || !existeMesa.activo) {
            return res.status(404).json({
                message: 'Mesa no encontrada'
            });
        }

        const nuevaOrden = new Orden({ mesa, mesero });
        await nuevaOrden.save();

        let total = 0;
        const detalles = [];

        for (const item of productos) {
            const producto = await Producto.findById(item.producto);

            if (!producto || !producto.disponible) {
                return res.status(400).json({
                    message: `El producto ${item.producto} no está disponible`
                });
            }

            const cantidad = Number(item.cantidad);

            if (!Number.isFinite(cantidad) || cantidad <= 0) {
                return res.status(400).json({
                    message: 'La cantidad de cada producto debe ser mayor que cero'
                });
            }

            const subtotal = producto.precio * cantidad;
            total += subtotal;

            const detalle = new OrdenDetalle({
                orden: nuevaOrden._id,
                producto: producto._id,
                cantidad,
                precioUnitario: producto.precio,
                subtotal,
                esAdicion: false,
                notas: item.notas
            });

            await detalle.save();
            detalles.push(detalle);
        }

        nuevaOrden.total = total;
        await nuevaOrden.save();

        existeMesa.estado = 'ocupada';
        await existeMesa.save();

        const io = req.app.get('io');

        if (io) {
            const mesaInfo = await Mesa.findById(nuevaOrden.mesa);

            io.to('meseros').emit('nuevoPedido', {
                ordenId: nuevaOrden._id,
                mesa: mesaInfo
                    ? {
                        _id: mesaInfo._id,
                        nombre: mesaInfo.nombre
                    }
                    : nuevaOrden.mesa,
                mesero: nuevaOrden.mesero,
                total,
                mensaje: 'Nuevo pedido creado'
            });
        }

        return res.status(201).json({
            message: 'Orden creada correctamente',
            orden: nuevaOrden,
            detalles
        });
    } catch (error) {
        console.error('Error al crear orden:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// OBTENER TODAS LAS ÓRDENES
// ============================

export const getOrdenes = async (req, res) => {
    try {
        const ordenes = await Orden.find()
            .populate('mesa', 'nombre')
            .populate('mesero', 'nombre')
            .sort({ createdAt: -1 });

        return res.status(200).json({
            message: 'Órdenes obtenidas correctamente',
            ordenes
        });
    } catch (error) {
        console.error('Error al obtener órdenes:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// OBTENER ORDEN POR ID
// ============================

export const getOrdenPorId = async (req, res) => {
    try {
        const { id } = req.params;

        const orden = await Orden.findById(id)
            .populate('mesa', 'nombre')
            .populate('mesero', 'nombre');

        if (!orden) {
            return res.status(404).json({
                message: 'Orden no encontrada'
            });
        }

        const detalles = await OrdenDetalle.find({ orden: id })
            .populate('producto', 'nombre precio');

        return res.status(200).json({
            message: 'Orden obtenida correctamente',
            orden,
            detalles
        });
    } catch (error) {
        console.error('Error al obtener orden:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// AGREGAR PRODUCTO A ORDEN
// ============================

export const agregarProducto = async (req, res) => {
    try {
        const { id } = req.params;
        const { producto, cantidad, notas } = req.body;

        const orden = await Orden.findById(id);

        if (!orden) {
            return res.status(404).json({
                message: 'Orden no encontrada'
            });
        }

        if (orden.estado !== 'pendiente') {
            return res.status(400).json({
                message: 'La orden ya fue enviada a cocina. Debe crearse una nueva adición.'
            });
        }

        const productoDB = await Producto.findById(producto);

        if (!productoDB || !productoDB.disponible) {
            return res.status(400).json({
                message: 'Producto no disponible'
            });
        }

        const cantidadNumerica = Number(cantidad);

        if (!Number.isFinite(cantidadNumerica) || cantidadNumerica <= 0) {
            return res.status(400).json({
                message: 'La cantidad debe ser mayor que cero'
            });
        }

        const subtotal = productoDB.precio * cantidadNumerica;

        const detalle = new OrdenDetalle({
            orden: orden._id,
            producto: productoDB._id,
            cantidad: cantidadNumerica,
            precioUnitario: productoDB.precio,
            subtotal,
            esAdicion: false,
            notas
        });

        await detalle.save();

        orden.total += subtotal;
        await orden.save();

        return res.status(201).json({
            message: 'Producto agregado correctamente',
            detalle,
            orden
        });
    } catch (error) {
        console.error('Error al agregar producto:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// CREAR NUEVA ADICIÓN
// ============================

export const crearAdicion = async (req, res) => {
    try {
        const { id } = req.params;
        const { productos } = req.body;

        if (!Array.isArray(productos) || productos.length === 0) {
            return res.status(400).json({
                message: 'Debe agregar al menos un producto a la adición'
            });
        }

        const orden = await Orden.findById(id);

        if (!orden) {
            return res.status(404).json({
                message: 'Orden no encontrada'
            });
        }

        if (orden.estado === 'pagado' || orden.estado === 'cancelado') {
            return res.status(400).json({
                message: 'No se pueden agregar productos a una orden finalizada'
            });
        }

        let totalAdicion = 0;
        const detalles = [];

        for (const item of productos) {
            const productoDB = await Producto.findById(item.producto);

            if (!productoDB || !productoDB.disponible) {
                return res.status(400).json({
                    message: `El producto ${item.producto} no está disponible`
                });
            }

            const cantidad = Number(item.cantidad ?? 1);

            if (!Number.isFinite(cantidad) || cantidad <= 0) {
                return res.status(400).json({
                    message: 'La cantidad debe ser mayor que cero'
                });
            }

            const subtotal = productoDB.precio * cantidad;
            totalAdicion += subtotal;

            const detalle = new OrdenDetalle({
                orden: orden._id,
                producto: productoDB._id,
                cantidad,
                precioUnitario: productoDB.precio,
                subtotal,
                esAdicion: true,
                notas: item.notas
            });

            await detalle.save();
            detalles.push(detalle);
        }

        orden.total += totalAdicion;
        await orden.save();

        const io = req.app.get('io');

        if (io) {
            const mesa = await Mesa.findById(orden.mesa);

            const datosAdicion = {
                ordenId: orden._id,
                mesa: mesa
                    ? {
                        _id: mesa._id,
                        nombre: mesa.nombre
                    }
                    : orden.mesa,
                productos: detalles.map((detalle) => ({
                    producto: detalle.producto,
                    cantidad: detalle.cantidad,
                    notas: detalle.notas,
                    precioUnitario: detalle.precioUnitario,
                    subtotal: detalle.subtotal
                })),
                totalAdicion,
                mensaje: 'Nueva adición para la mesa'
            };

            io.to('cocina').emit('nuevaAdicion', datosAdicion);
            io.to('meseros').emit('nuevaAdicion', datosAdicion);
        }

        return res.status(201).json({
            message: 'Adición creada correctamente',
            orden,
            detalles,
            totalAdicion
        });
    } catch (error) {
        console.error('Error al crear adición:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// CAMBIAR ESTADO DE ORDEN
// ============================

export const cambiarEstadoOrden = async (req, res) => {
    try {
        const { id } = req.params;
        const { estado } = req.body;

        const estadosValidos = [
            'pendiente',
            'en_cocina',
            'listo',
            'servido',
            'pagado',
            'cancelado'
        ];

        if (!estadosValidos.includes(estado)) {
            return res.status(400).json({
                message: 'Estado inválido'
            });
        }

        const orden = await Orden.findById(id);

        if (!orden) {
            return res.status(404).json({
                message: 'Orden no encontrada'
            });
        }

        orden.estado = estado;
        await orden.save();

        const io = req.app.get('io');

        if (estado === 'en_cocina' && io) {
            io.to('cocina').emit('pedidoEnCocina', {
                ordenId: orden._id,
                mesa: orden.mesa,
                mensaje: 'Nuevo pedido enviado a cocina'
            });
        }

        if (estado === 'listo' && io) {
            io.to('meseros').emit('pedidoListo', {
                ordenId: orden._id,
                mesa: orden.mesa,
                mensaje: 'El pedido está listo'
            });
        }

        if (estado === 'servido' && io) {
            io.to('meseros').emit('pedidoServido', {
                ordenId: orden._id,
                mesa: orden.mesa,
                mensaje: 'El pedido fue servido'
            });
        }

        if (estado === 'pagado' && io) {
            io.to('meseros').emit('pedidoPagado', {
                ordenId: orden._id,
                mesa: orden.mesa,
                mensaje: 'El pedido fue pagado'
            });
        }

        if (estado === 'cancelado' && io) {
            io.to('meseros').emit('pedidoCancelado', {
                ordenId: orden._id,
                mesa: orden.mesa,
                mensaje: 'El pedido fue cancelado'
            });
        }

        if (estado === 'pagado' || estado === 'cancelado') {
            const mesa = await Mesa.findById(orden.mesa);

            if (mesa) {
                mesa.estado = 'libre';
                await mesa.save();

                if (io) {
                    io.to('meseros').emit('mesaLiberada', {
                        mesaId: mesa._id,
                        mensaje: 'La mesa quedó libre'
                    });
                }
            }
        }

        return res.status(200).json({
            message: 'Estado de la orden actualizado',
            orden
        });
    } catch (error) {
        console.error('Error al cambiar estado de orden:', error);

        return res.status(500).json({
            message: 'Error del servidor',
            error: error.message
        });
    }
};

// ============================
// PRODUCTOS MÁS VENDIDOS
// Solo órdenes pagadas.
// Incluye productos de adiciones.
// ============================

export const getProductosMasVendidos = async (req, res) => {
    try {
        const productos = await OrdenDetalle.aggregate([
            {
                $lookup: {
                    from: Orden.collection.name,
                    localField: 'orden',
                    foreignField: '_id',
                    as: 'ordenInfo'
                }
            },
            { $unwind: '$ordenInfo' },
            {
                $match: {
                    'ordenInfo.estado': 'pagado'
                }
            },
            {
                $group: {
                    _id: '$producto',
                    cantidadVendida: { $sum: '$cantidad' },
                    totalVendido: { $sum: '$subtotal' }
                }
            },
            { $sort: { cantidadVendida: -1, totalVendido: -1 } },
            { $limit: 5 },
            {
                $lookup: {
                    from: Producto.collection.name,
                    localField: '_id',
                    foreignField: '_id',
                    as: 'productoInfo'
                }
            },
            {
                $unwind: {
                    path: '$productoInfo',
                    preserveNullAndEmptyArrays: true
                }
            },
            {
                $project: {
                    _id: 0,
                    productoId: '$_id',
                    nombre: '$productoInfo.nombre',
                    cantidadVendida: 1,
                    totalVendido: 1
                }
            }
        ]);

        return res.status(200).json({ productos });
    } catch (error) {
        console.error('Error al consultar productos más vendidos:', error);

        return res.status(500).json({
            message: 'No se pudieron obtener los productos más vendidos',
            error: error.message
        });
    }
};