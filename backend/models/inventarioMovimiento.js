import mongoose from "mongoose";

const inventarioMovimientoSchema = new mongoose.Schema(
  {
    // Registro de inventario al que pertenece el movimiento
    inventario: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "BDinventario",
      required: true,
    },

    // Se conserva para los productos del menú existentes
    producto: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "BDproduct",
      default: null,
    },

    tipo: {
      type: String,
      enum: ["entrada", "salida"],
      required: true,
    },

    cantidad: {
      type: Number,
      required: true,
      min: 0.001,
    },

    motivo: {
      type: String,
      trim: true,
      default: "",
    },

    usuario: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "BDusurios",
      required: true,
    },
  },
  { timestamps: true }
);

const InventarioMovimiento =
  mongoose.models.BDinventarioMovimiento ||
  mongoose.model(
    "BDinventarioMovimiento",
    inventarioMovimientoSchema,
    "BDinventarioMovimiento"
  );

export default InventarioMovimiento;