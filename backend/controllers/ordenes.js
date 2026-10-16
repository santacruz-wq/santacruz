import Orden from '../models/ordenes.js';
import OrdenDetalle from '../models/ordenDetalle.js';
import Producto from '../models/product.js';
import Mesa from '../models/mesa.js';


// ============================
// 🔹 CREAR UNA NUEVA ORDEN
// ============================

export const crearOrden = async (req, res) => {

    try {

        const { mesa, productos } = req.body;

        const mesero = req.usuario._id;


        // VALIDAMOS LOS CAMPOS

        if (
            !mesa ||
            !productos ||
            productos.length === 0
        ) {

            return res.status(400).json({
                message:
                    'Por favor, seleccione una mesa y al menos un producto'
            });

        }


        // VERIFICAMOS LA MESA

        const existeMesa =
            await Mesa.findById(mesa);

        if (
            !existeMesa ||
            !existeMesa.activo
        ) {

            return res.status(404).json({
                message: 'Mesa no encontrada'
            });

        }


        // CREAMOS LA ORDEN

        const nuevaOrden = new Orden({
            mesa,
            mesero
        });

        await nuevaOrden.save();


        // CREAMOS LOS DETALLES

        let total = 0;

        const detalles = [];


        for (const item of productos) {

            const producto =
                await Producto.findById(
                    item.producto
                );


            if (
                !producto ||
                !producto.disponible
            ) {

                return res.status(400).json({
                    message:
                        `El producto ${item.producto} no está disponible`
                });

            }


            const subtotal =
                producto.precio *
                item.cantidad;


            total += subtotal;


            const detalle =
                new OrdenDetalle({

                    orden: nuevaOrden._id,

                    producto: producto._id,

                    cantidad: item.cantidad,

                    precioUnitario:
                        producto.precio,

                    subtotal,

                    esAdicion: false,

                    notas: item.notas

                });


            await detalle.save();

            detalles.push(detalle);

        }


        // ACTUALIZAMOS TOTAL

        nuevaOrden.total = total;

        await nuevaOrden.save();


        // MARCAMOS MESA OCUPADA

        existeMesa.estado = 'ocupada';

        await existeMesa.save();


        // ============================
        // 🔹 NOTIFICAR A TODOS LOS MESEROS
        // ============================

        const io = req.app.get('io');

        if (io) {

            const mesaInfo =
                await Mesa.findById(
                    nuevaOrden.mesa
                );


            io.to('meseros').emit(
                'nuevoPedido',
                {

                    ordenId: nuevaOrden._id,

                    mesa: mesaInfo
                        ? {
                            _id: mesaInfo._id,
                            nombre: mesaInfo.nombre
                        }
                        : nuevaOrden.mesa,

                    mesero: nuevaOrden.mesero,

                    total,

                    mensaje:
                        'Nuevo pedido creado'

                }
            );

        }


        res.status(201).json({

            message:
                'Orden creada correctamente',

            orden: nuevaOrden,

            detalles

        });


    } catch (error) {

        res.status(500).json({

            message:
                'Error del servidor',

            error:
                error.message

        });

    }

};


// ============================
// 🔹 OBTENER TODAS LAS ÓRDENES
// ============================

export const getOrdenes = async (req, res) => {

    try {

        const ordenes =
            await Orden.find()

                .populate(
                    'mesa',
                    'nombre'
                )

                .populate(
                    'mesero',
                    'nombre'
                )

                .sort({
                    createdAt: -1
                });


        res.status(200).json({

            message:
                'Órdenes obtenidas correctamente',

            ordenes

        });


    } catch (error) {

        res.status(500).json({

            message:
                'Error del servidor',

            error:
                error.message

        });

    }

};


// ============================
// 🔹 OBTENER ORDEN POR ID
// ============================

export const getOrdenPorId = async (req, res) => {

    try {

        const { id } = req.params;


        const orden =
            await Orden.findById(id)

                .populate(
                    'mesa',
                    'nombre'
                )

                .populate(
                    'mesero',
                    'nombre'
                );


        if (!orden) {

            return res.status(404).json({

                message:
                    'Orden no encontrada'

            });

        }


        const detalles =
            await OrdenDetalle.find({
                orden: id
            })

                .populate(
                    'producto',
                    'nombre precio'
                );


        res.status(200).json({

            message:
                'Orden obtenida correctamente',

            orden,

            detalles

        });


    } catch (error) {

        res.status(500).json({

            message:
                'Error del servidor',

            error:
                error.message

        });

    }

};


// ============================
// 🔹 AGREGAR PRODUCTO
// ============================

export const agregarProducto = async (req, res) => {

    try {

        const { id } = req.params;

        const {
            producto,
            cantidad,
            notas
        } = req.body;


        const orden =
            await Orden.findById(id);


        if (!orden) {

            return res.status(404).json({

                message:
                    'Orden no encontrada'

            });

        }


        if (
            orden.estado !== 'pendiente'
        ) {

            return res.status(400).json({

                message:
                    'La orden ya fue enviada a cocina. Debe crearse una nueva adición.'

            });

        }


        const productoDB =
            await Producto.findById(
                producto
            );


        if (
            !productoDB ||
            !productoDB.disponible
        ) {

            return res.status(400).json({

                message:
                    'Producto no disponible'

            });

        }


        const subtotal =
            productoDB.precio *
            cantidad;


        const detalle =
            new OrdenDetalle({

                orden: orden._id,

                producto:
                    productoDB._id,

                cantidad,

                precioUnitario:
                    productoDB.precio,

                subtotal,

                esAdicion: false,

                notas

            });


        await detalle.save();


        orden.total += subtotal;

        await orden.save();


        res.status(201).json({

            message:
                'Producto agregado correctamente',

            detalle,

            orden

        });


    } catch (error) {

        res.status(500).json({

            message:
                'Error del servidor',

            error:
                error.message

        });

    }

};


// ============================
// 🔹 CREAR NUEVA ADICIÓN
// ============================

export const crearAdicion = async (req, res) => {

    try {

        const { id } = req.params;

        const { productos } = req.body;


        if (
            !productos ||
            productos.length === 0
        ) {

            return res.status(400).json({

                message:
                    'Debe agregar al menos un producto a la adición'

            });

        }


        const orden =
            await Orden.findById(id);


        if (!orden) {

            return res.status(404).json({

                message:
                    'Orden no encontrada'

            });

        }


        // NO SE PUEDEN AGREGAR PRODUCTOS
        // A UNA ORDEN FINALIZADA

        if (
            orden.estado === 'pagado' ||
            orden.estado === 'cancelado'
        ) {

            return res.status(400).json({

                message:
                    'No se pueden agregar productos a una orden finalizada'

            });

        }


        let totalAdicion = 0;

        const detalles = [];


        // CREAMOS LOS NUEVOS PRODUCTOS

        for (const item of productos) {

            const productoDB =
                await Producto.findById(
                    item.producto
                );


            if (
                !productoDB ||
                !productoDB.disponible
            ) {

                return res.status(400).json({

                    message:
                        `El producto ${item.producto} no está disponible`

                });

            }


            const cantidad =
                item.cantidad || 1;


            const subtotal =
                productoDB.precio *
                cantidad;


            totalAdicion += subtotal;


            const detalle =
                new OrdenDetalle({

                    orden: orden._id,

                    producto:
                        productoDB._id,

                    cantidad,

                    precioUnitario:
                        productoDB.precio,

                    subtotal,

                    esAdicion: true,

                    notas:
                        item.notas

                });


            await detalle.save();

            detalles.push(detalle);

        }


        // ACTUALIZAMOS TOTAL

        orden.total += totalAdicion;

        await orden.save();


        const io = req.app.get('io');


        // ============================
        // 🔹 NOTIFICAR A COCINA
        // ============================

        if (io) {

            const mesa =
                await Mesa.findById(
                    orden.mesa
                );


            const datosAdicion = {

                ordenId:
                    orden._id,

                mesa: mesa
                    ? {
                        _id: mesa._id,
                        nombre: mesa.nombre
                    }
                    : orden.mesa,

                productos:
                    detalles.map(
                        (detalle, index) => ({

                            producto:
                                productos[index].producto,

                            cantidad:
                                detalle.cantidad,

                            notas:
                                detalle.notas,

                            precioUnitario:
                                detalle.precioUnitario,

                            subtotal:
                                detalle.subtotal

                        })
                    ),

                totalAdicion,

                mensaje:
                    'Nueva adición para la mesa'

            };


            // COCINA

            io.to('cocina').emit(
                'nuevaAdicion',
                datosAdicion
            );


            // TODOS LOS MESEROS

            io.to('meseros').emit(
                'nuevaAdicion',
                datosAdicion
            );

        }


        res.status(201).json({

            message:
                'Adición creada correctamente',

            orden,

            detalles,

            totalAdicion

        });


    } catch (error) {

        res.status(500).json({

            message:
                'Error del servidor',

            error:
                error.message

        });

    }

};

// ============================
// 🔹 CAMBIAR ESTADO DE ORDEN
// ============================

export const cambiarEstadoOrden = async (req, res) => {

    try {

        const { id } = req.params;
        const { estado } = req.body;


        // ============================
        // 🔹 ESTADOS VÁLIDOS
        // ============================

        const estadosValidos = [
            "pendiente",
            "en_cocina",
            "listo",
            "servido",
            "pagado",
            "cancelado"
        ];


        if (!estadosValidos.includes(estado)) {

            return res.status(400).json({

                message: "Estado inválido"

            });

        }


        // ============================
        // 🔹 BUSCAR ORDEN
        // ============================

        const orden = await Orden.findById(id);


        if (!orden) {

            return res.status(404).json({

                message: "Orden no encontrada"

            });

        }


        // ============================
        // 🔹 CAMBIAR ESTADO
        // ============================

        orden.estado = estado;

        await orden.save();


        // ============================
        // 🔹 SOCKET.IO
        // ============================

        const io = req.app.get("io");


        // ============================
        // 🔹 PEDIDO ENVIADO A COCINA
        // ============================

        if (estado === "en_cocina") {

            if (io) {

                io.to("cocina").emit(
                    "pedidoEnCocina",
                    {
                        ordenId: orden._id,

                        mesa: orden.mesa,

                        mensaje:
                            "Nuevo pedido enviado a cocina"
                    }
                );

            }

        }


        // ============================
        // 🔹 ORDEN LISTA
        // ============================

        if (estado === "listo") {

            if (io) {

                io.to("meseros").emit(
                    "pedidoListo",
                    {
                        ordenId: orden._id,

                        mesa: orden.mesa,

                        mensaje:
                            "El pedido está listo"
                    }
                );

            }

        }


        // ============================
        // 🔹 ORDEN SERVIDA
        // ============================

        if (estado === "servido") {

            if (io) {

                io.to("meseros").emit(
                    "pedidoServido",
                    {
                        ordenId: orden._id,

                        mesa: orden.mesa,

                        mensaje:
                            "El pedido fue servido"
                    }
                );

            }

        }


        // ============================
        // 🔹 ORDEN PAGADA
        // ============================

        if (estado === "pagado") {

            if (io) {

                io.to("meseros").emit(
                    "pedidoPagado",
                    {
                        ordenId: orden._id,

                        mesa: orden.mesa,

                        mensaje:
                            "El pedido fue pagado"
                    }
                );

            }

        }


        // ============================
        // 🔹 ORDEN CANCELADA
        // ============================

        if (estado === "cancelado") {

            if (io) {

                io.to("meseros").emit(
                    "pedidoCancelado",
                    {
                        ordenId: orden._id,

                        mesa: orden.mesa,

                        mensaje:
                            "El pedido fue cancelado"
                    }
                );

            }

        }


        // ============================
        // 🔹 LIBERAR MESA
        // ============================

        if (
            estado === "pagado" ||
            estado === "cancelado"
        ) {

            const mesa =
                await Mesa.findById(orden.mesa);


            if (mesa) {

                mesa.estado = "libre";

                await mesa.save();


                // ============================
                // 🔹 AVISAR QUE LA MESA QUEDÓ LIBRE
                // ============================

                if (io) {

                    io.to("meseros").emit(
                        "mesaLiberada",
                        {
                            mesaId: mesa._id,

                            mensaje:
                                "La mesa quedó libre"
                        }
                    );

                }

            }

        }


        // ============================
        // 🔹 RESPUESTA
        // ============================

        return res.status(200).json({

            message:
                "Estado de la orden actualizado",

            orden

        });


    } catch (error) {

        console.error(
            "Error al cambiar estado de orden:",
            error
        );

        return res.status(500).json({

            message:
                "Error del servidor",

            error:
                error.message

        });

    }

};