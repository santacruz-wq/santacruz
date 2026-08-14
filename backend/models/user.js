import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const userSchema = new mongoose.Schema({
    nombre: { type: String, required: true, uppercase: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true },
    codigoRecuperacion:String,
    codigoexpiracion:Date,
    rol: { type: String, enum: ["admin", "mesero", "cocina", "usuario"], default: "usuario" },
    activo: { type: Boolean, default: true }
},{ timestamps: true });

// encriptar contraseña antes de guardar
userSchema.pre('save', async function () {

    if (!this.isModified('password')) return;

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);

});

userSchema.methods.compararPassword = async function (passwordIngresada) {
    return await bcrypt.compare(passwordIngresada, this.password);
};  

// crear modelo
const User = mongoose.models.users || mongoose.model('users', userSchema);

export default User;