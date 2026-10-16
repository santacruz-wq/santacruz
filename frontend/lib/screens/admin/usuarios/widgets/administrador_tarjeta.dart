import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class AdministradorTarjeta extends StatelessWidget {
  final Map<String, dynamic> usuario;
  final Future<void> Function(
    Map<String, dynamic>,
    String,
  ) cambiarRol;
  final Future<void> Function(
    Map<String, dynamic>,
    bool,
  ) cambiarEstado;

  const AdministradorTarjeta({
    super.key,
    required this.usuario,
    required this.cambiarRol,
    required this.cambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final esAdmin = usuario['rol'] == 'admin';
    final activo = usuario['activo'] == true;
    final nombre = (usuario['nombre'] ?? 'Sin nombre').toString();
    final correo = (usuario['correo'] ?? 'Sin correo').toString();

    return Card(
      color: AppColors.cremaClaro,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.carameloClaro,
                  child: Icon(
                    esAdmin
                        ? Icons.admin_panel_settings
                        : Icons.person,
                    color: AppColors.textoCafe,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoCafe,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        correo,
                        style: const TextStyle(
                          color: AppColors.cafeMedio,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rol: ${usuario['rol'] ?? 'Sin rol'}',
                        style: const TextStyle(
                          color: AppColors.cafeMedio,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  activo ? Icons.check_circle : Icons.block,
                  color: activo ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              activo ? 'Estado: Activo' : 'Estado: Inactivo',
            ),
            const SizedBox(height: 10),
            if (esAdmin) ...[
              OutlinedButton.icon(
                onPressed: () => cambiarRol(usuario, 'usuario'),
                icon: const Icon(Icons.remove_moderator),
                label: const Text(
                  'Retirar rol de administrador',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => cambiarEstado(usuario, !activo),
                icon: Icon(
                  activo ? Icons.block : Icons.check_circle,
                ),
                label: Text(
                  activo ? 'Desactivar' : 'Activar',
                ),
              ),
            ] else ...[
              FilledButton.icon(
                onPressed: () => cambiarRol(usuario, 'admin'),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text(
                  'Convertir en administrador',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}