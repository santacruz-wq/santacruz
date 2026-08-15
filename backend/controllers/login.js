import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import user from '../models/user.js';


//CONTROLADOR DE LOGIN 

export const loginUsers = async (req, res) => {

    try{
    const { email, password } = req.body;

    //VALIDAMOS LOS CAMPOS 

    if (!email || !password) {
        return res.status(400).json({ message: 'Por favor, ingrese su correo electrónico y contraseña' });
    }

    //BUSCAMOS EL USUARIO EN LA BASE DE DATOS

    const existeUser = await user.findOne({ email });

    if (!existeUser) {
        return res.status(400).json({ message: 'Usuario no encontrado' });
    }

    //VALIDAMOS LA CONTRASEÑA

    const esvalida = await bcrypt.compare(password, existeUser.password);
    if (!esvalida) {
        return res.status(400).json({ message: 'Contraseña incorrecta' });
    }

    //token de autenticación

    const token = jwt.sign({
        id: existeUser._id, email: existeUser.email, rol: existeUser.rol }, process.env.JWT_SECRET, { expiresIn: '1h' });

    //RESPONDEMOS TOKEN DE AUTENTICACIÓN

    res.status(200).json({ 
        message: 'inicio de sesion exitoso',
        token: token, 
        usuario:{
            _id: existeUser._id,
            nombre: existeUser.nombre,
            email: existeUser.email,
            rol: existeUser.rol,
            activo: existeUser.activo
        }});

        } catch (error) {
        res.status(500).json({ message: 'Error del servidor', error: error.message });}

}