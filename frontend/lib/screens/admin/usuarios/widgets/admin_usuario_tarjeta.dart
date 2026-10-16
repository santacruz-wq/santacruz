import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../admin_usuario_dialogos.dart';

class AdminUsuarioTarjeta extends StatelessWidget {
  final Map<String, dynamic> usuario;
  final VoidCallback onEditar;

  const AdminUsuarioTarjeta({
    super.key,
    required this.usuario,
    required this.onEditar,
  });

  Widget _etiqueta(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = (usuario['nombre'] ?? 'Sin nombre').toString();
    final email = (usuario['email'] ?? '').toString();
    final rol = (usuario['rol'] ?? 'usuario').toString();
    final activo = usuario['activo'] == true;
    final verificado = usuario['isVerified'] == true;
    final esAdministrador = rol == 'admin';

    return Card(
      color: AppColors.cremaClaro,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.carameloClaro,
              child: Text(
                nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.textoCafe,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
                      color: AppColors.textoCafe,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      color: AppColors.cafeMedio,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _etiqueta(
                        AdminUsuarioDialogos.nombreRol(rol),
                        AppColors.carameloClaro,
                      ),
                      _etiqueta(
                        activo ? 'Activo' : 'Inactivo',
                        activo
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                      ),
                      _etiqueta(
                        verificado ? 'Verificado' : 'Sin verificar',
                        verificado
                            ? Colors.blue.shade100
                            : Colors.orange.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: esAdministrador ? null : onEditar,
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                      ),
                      label: Text(
                        esAdministrador
                            ? 'Gestión independiente'
                            : 'Editar',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cafeMedio,
                        side: const BorderSide(
                          color: AppColors.caramelo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}