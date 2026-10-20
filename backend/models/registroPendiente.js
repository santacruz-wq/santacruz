import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const registroPendienteSchema = new mongoose.Schema({
    nombre: {
        type: String,
        required: true,
        trim: true,
        uppercase: true
    },

    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        trim: true,
        index: true
    },

    password: {
        type: String,
        required: true,
        minlength: 6
    },

    codigoVerificacion: {
        type: String,
        required: true
    },

    codigoExpiracion: {
        type: Date,
        required: true
    },

    // El registro temporal se elimina automáticamente después de 24 horas.
    eliminarEn: {
        type: Date,
        required: true,
        default: () => new Date(Date.now() + 24 * 60 * 60 * 1000),
        index: {
            expires: 0
        }
    }
}, {
    timestamps: true,
    collection: 'registrosPendientes'
});

// Cifrar la contraseña antes de guardarla en la colección temporal.
registroPendienteSchema.pre('save', async function () {
    if (!this.isModified('password')) {
        return;
    }

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

const RegistroPendiente =
    mongoose.models.RegistroPendiente ||
    mongoose.model('RegistroPendiente', registroPendienteSchema);

export default RegistroPendiente;