import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const userSchema = new mongoose.Schema({
    nombre: {
        type: String,
        required: true,
        uppercase: true,
        trim: true
    },

    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        trim: true
    },

    password: {
        type: String,
        required: function () {
            return !this.googleId;
        },
        minlength: 6
    },

    // RECUPERACIÓN DE CONTRASEÑA
    codigoRecuperacion: {
        type: String,
        default: null
    },

    codigoExpiracion: {
        type: Date,
        default: null
    },

    // VERIFICACIÓN DE CUENTA
    isVerified: {
        type: Boolean,
        default: false
    },

    codigoVerificacion: {
        type: String,
        default: null
    },

    codigoVerificacionExpiracion: {
        type: Date,
        default: null
    },

    // ROLES Y ESTADO
    rol: {
        type: String,
        enum: ['admin', 'mesero', 'cocina', 'usuario'],
        default: 'usuario'
    },

    activo: {
        type: Boolean,
        default: true
    },

    // INICIO DE SESIÓN CON GOOGLE
    googleId: {
        type: String,
        unique: true,
        sparse: true
    },

    avatar: {
        type: String,
        default: ''
    }
}, {
    timestamps: true,
    collection: 'BDusurios'
});

// CIFRAR CONTRASEÑA ANTES DE GUARDAR
userSchema.pre('save', async function () {
    if (!this.isModified('password') || !this.password) {
        return;
    }

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

// COMPARAR CONTRASEÑA DURANTE EL LOGIN
userSchema.methods.compararPassword = async function (passwordIngresada) {
    if (!this.password || typeof passwordIngresada !== 'string') {
        return false;
    }

    return bcrypt.compare(passwordIngresada, this.password);
};

// CREAR MODELO
const User =
    mongoose.models.BDusurios ||
    mongoose.model('BDusurios', userSchema, 'BDusurios');

export default User;