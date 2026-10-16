import mongoose from "mongoose";

const inventarioSchema = new mongoose.Schema(
  {
    // Producto del menú (opcional si es un insumo)
    producto: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "BDproduct",
      default: null,
    },

    // Nombre para los insumos escritos manualmente
    nombreInsumo: {
      type: String,
      trim: true,
      default: null,
    },

    // Diferencia productos del menú e insumos
    tipoInventario: {
      type: String,
      enum: ["producto", "insumo"],
      default: "producto",
      required: true,
    },

    // Ejemplos: kg, g, litro, ml, unidad
    unidadMedida: {
      type: String,
      trim: true,
      default: "unidad",
    },

    cantidadDisponible: {
      type: Number,
      required: true,
      default: 0,
      min: 0,
    },

    cantidadMinima: {
      type: Number,
      default: 5,
      min: 0,
    },

    cantidadMaxima: {
      type: Number,
      default: 100,
      min: 0,
    },
  },
  { timestamps: true }
);

// Cada producto del menú solo puede tener un registro de inventario.
inventarioSchema.index(
  { producto: 1 },
  {
    unique: true,
    partialFilterExpression: {
      tipoInventario: "producto",
      producto: { $type: "objectId" },
    },
  }
);

// Cada insumo puede tener un registro propio por nombre.
inventarioSchema.index(
  { nombreInsumo: 1 },
  {
    unique: true,
    partialFilterExpression: {
      tipoInventario: "insumo",
      nombreInsumo: { $type: "string" },
    },
  }
);

const Inventario =
  mongoose.models.BDinventario ||
  mongoose.model("BDinventario", inventarioSchema, "BDinventario");

export default Inventario;