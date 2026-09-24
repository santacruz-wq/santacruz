import 'package:flutter/material.dart';

class ConfirmarDatos extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController telefonoController;
  final TextEditingController direccionController;
  final TextEditingController observacionesController;

  final String titulo;
  final String nombre;
  final String ejemploNombre;
  final String telefono;
  final String ejemploTelefono;
  final String direccion;
  final String ejemploDireccion;
  final String observaciones;
  final String ejemploObservaciones;

  final Color cafe;
  final Color cafeOscuro;
  final Color dorado;
  final Color textoGris;
  final Color fondoCampo;

  const ConfirmarDatos({
    super.key,
    required this.nombreController,
    required this.telefonoController,
    required this.direccionController,
    required this.observacionesController,
    required this.titulo,
    required this.nombre,
    required this.ejemploNombre,
    required this.telefono,
    required this.ejemploTelefono,
    required this.direccion,
    required this.ejemploDireccion,
    required this.observaciones,
    required this.ejemploObservaciones,
    required this.cafe,
    required this.cafeOscuro,
    required this.dorado,
    required this.textoGris,
    required this.fondoCampo,
  });

  Widget campoTexto({
    required String etiqueta,
    required String hint,
    required IconData icono,
    required TextEditingController controller,
    TextInputType? tipoTeclado,
    int maxLineas = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipoTeclado,
      maxLines: maxLineas,
      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: hint,
        prefixIcon: Icon(
          icono,
          color: cafe,
        ),
        filled: true,
        fillColor: fondoCampo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: dorado.withOpacity(0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: cafe,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: cafeOscuro,
            ),
          ),

          const SizedBox(height: 15),

          campoTexto(
            etiqueta: nombre,
            hint: ejemploNombre,
            icono: Icons.person,
            controller: nombreController,
          ),

          const SizedBox(height: 12),

          campoTexto(
            etiqueta: telefono,
            hint: ejemploTelefono,
            icono: Icons.phone,
            controller: telefonoController,
            tipoTeclado: TextInputType.phone,
          ),

          const SizedBox(height: 12),

          campoTexto(
            etiqueta: direccion,
            hint: ejemploDireccion,
            icono: Icons.location_on,
            controller: direccionController,
          ),

          const SizedBox(height: 12),

          campoTexto(
            etiqueta: observaciones,
            hint: ejemploObservaciones,
            icono: Icons.notes,
            controller: observacionesController,
            maxLineas: 3,
          ),
        ],
      ),
    );
  }
}