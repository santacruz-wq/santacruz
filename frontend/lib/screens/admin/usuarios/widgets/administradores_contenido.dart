import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import 'administrador_tarjeta.dart';

class AdministradoresContenido extends StatelessWidget {
  final List<Map<String, dynamic>> administradores;
  final List<Map<String, dynamic>> otrosUsuarios;
  final Future<void> Function() cargarUsuarios;
  final Future<void> Function(
    Map<String, dynamic>,
    String,
  ) cambiarRol;
  final Future<void> Function(
    Map<String, dynamic>,
    bool,
  ) cambiarEstado;

  const AdministradoresContenido({
    super.key,
    required this.administradores,
    required this.otrosUsuarios,
    required this.cargarUsuarios,
    required this.cambiarRol,
    required this.cambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: cargarUsuarios,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Administradores (${administradores.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textoCafe,
            ),
          ),
          const SizedBox(height: 12),
          if (administradores.isEmpty)
            const Text('No hay administradores registrados.')
          else
            ...administradores.map(
              (usuario) => AdministradorTarjeta(
                usuario: usuario,
                cambiarRol: cambiarRol,
                cambiarEstado: cambiarEstado,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Otros usuarios (${otrosUsuarios.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textoCafe,
            ),
          ),
          const SizedBox(height: 12),
          if (otrosUsuarios.isEmpty)
            const Text('No hay otros usuarios registrados.')
          else
            ...otrosUsuarios.map(
              (usuario) => AdministradorTarjeta(
                usuario: usuario,
                cambiarRol: cambiarRol,
                cambiarEstado: cambiarEstado,
              ),
            ),
        ],
      ),
    );
  }
}