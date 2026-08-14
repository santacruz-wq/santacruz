import user from '../models/user.js';

// REGISTRAR NUEVO USUARIO 

export const registrarUser = async (req, res) => {
    try{
        const { nombre, email, password, rol } = req.body;

// TODOS LOS CAMPOS SON OBLIGATORIOS

        if (!nombre || !email || !password) {
            return res.status(400).json({ mensaje: 'Todos los campos son obligatorios' });
        }

//VALIDAR SI EL USUARIO YA EXISTE 
        const existeUser = await user.findOne({email});

        if(existeUser){
            return res.status(400).json({ mensaje: 'El usuario ya existe' });
        }

// CREAMOS EL USUARIO
        const nuevoUser = new user({
            nombre,
            email,
            password,
            rol :"usuario",
        });



//GUARDAMOS EL USUARIO EN LA BASE DE DATOS

    await nuevoUser.save();
    res.status(201).json({ mensaje: 'Usuario registrado exitosamente' });


    } catch (error) {

    console.log(error);

    res.status(500).json({
        mensaje: 'Error al registrar el usuario',
        error: error.message
    });
}
}