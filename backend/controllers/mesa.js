import Mesa from '../models/mesa.js';

//OBTENER TODAS LAS MESAS ACTIVAS

export const getMesas = async (req, res) => {
    try {
        const mesas = await Mesa.find({ activo: true });
        res.status(200).json({ message: 'Mesas obtenidas correctamente', mesas });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//OBTENER UNA MESA POR ID

export const getMesaPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const mesa = await Mesa.findById(id);

        if (!mesa || !mesa.activo) {
            return res.status(404).json({ message: 'Mesa no encontrada' });
        }

        res.status(200).json({ message: 'Mesa obtenida correctamente', mesa });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//CREAR UNA NUEVA MESA

export const crearMesa = async (req, res) => {
    try {
        const { nombre, capacidad } = req.body;

        //VALIDAMOS LOS CAMPOS

        if (!nombre || !capacidad) {
            return res.status(400).json({ message: 'Por favor, ingrese el nombre y la capacidad de la mesa' });
        }

        //VERIFICAMOS QUE NO EXISTA UNA MESA CON EL MISMO NOMBRE

        const existeMesa = await Mesa.findOne({ nombre });
        if (existeMesa) {
            return res.status(400).json({ message: 'Ya existe una mesa con ese nombre' });
        }

        const nuevaMesa = new Mesa({ nombre, capacidad });
        await nuevaMesa.save();

        res.status(201).json({ message: 'Mesa creada correctamente', mesa: nuevaMesa });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//ACTUALIZAR UNA MESA

export const actualizarMesa = async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, capacidad, estado } = req.body;

        const mesa = await Mesa.findById(id);
        if (!mesa || !mesa.activo) {
            return res.status(404).json({ message: 'Mesa no encontrada' });
        }

        //ACTUALIZAMOS SOLO LOS CAMPOS ENVIADOS

        if (nombre) mesa.nombre = nombre;
        if (capacidad) mesa.capacidad = capacidad;
        if (estado) mesa.estado = estado;

        await mesa.save();

        res.status(200).json({ message: 'Mesa actualizada correctamente', mesa });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//CAMBIAR EL ESTADO DE LA MESA (LIBRE / OCUPADA / RESERVADA)

export const cambiarEstadoMesa = async (req, res) => {
    try {
        const { id } = req.params;
        const { estado } = req.body;

        if (!["libre", "ocupada", "reservada"].includes(estado)) {
            return res.status(400).json({ message: 'Estado inválido' });
        }

        const mesa = await Mesa.findById(id);
        if (!mesa || !mesa.activo) {
            return res.status(404).json({ message: 'Mesa no encontrada' });
        }

        mesa.estado = estado;
        await mesa.save();

        res.status(200).json({ message: 'Estado de la mesa actualizado', mesa });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};

//ELIMINAR UNA MESA (SOFT DELETE)

export const eliminarMesa = async (req, res) => {
    try {
        const { id } = req.params;

        const mesa = await Mesa.findById(id);
        if (!mesa || !mesa.activo) {
            return res.status(404).json({ message: 'Mesa no encontrada' });
        }

        mesa.activo = false;
        await mesa.save();

        res.status(200).json({ message: 'Mesa eliminada correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });
    }
};