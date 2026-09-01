import mongoose from 'mongoose';
import dotenv from 'dotenv';
import user from '../models/user.js';

dotenv.config();

const run = async () => {
    await mongoose.connect(process.env.MONGO_URI);
    const resultado = await user.updateMany({}, { $set: { isVerified: true } });
    console.log(`Usuarios actualizados: ${resultado.modifiedCount}`);
    await mongoose.disconnect();
};

run();