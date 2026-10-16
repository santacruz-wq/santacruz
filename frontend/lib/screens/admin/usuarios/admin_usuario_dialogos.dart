import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class AdminUsuarioDialogos {
  static String nombreRol(String rol) {
    switch (rol) {
      case 'admin':
        return 'Administrador';
      case 'mesero':
        return 'Mesero';
      case 'cocina':
        return 'Cocina';
      default:
        return 'Usuario';
    }
  }

  static Future<Map<String, dynamic>?> editar({
    required BuildContext context,
    required String nombre,
    required String rolInicial,
    required bool activoInicial,
  }) async {
    String rol = rolInicial;
    bool activo = activoInicial;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cremaClaro,
          title: const Text(
            'Editar usuario',
            style: TextStyle(
              color: AppColors.textoCafe,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rol del usuario',
                  style: TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: rol,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'usuario',
                      child: Text('Usuario'),
                    ),
                    DropdownMenuItem(
                      value: 'mesero',
                      child: Text('Mesero'),
                    ),
                    DropdownMenuItem(
                      value: 'cocina',
                      child: Text('Cocina'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor == null) return;
                    setDialogState(() => rol = valor);
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Cuenta activa',
                    style: TextStyle(
                      color: AppColors.textoCafe,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    activo
                        ? 'Puede iniciar sesión'
                        : 'No puede iniciar sesión',
                  ),
                  value: activo,
                  activeThumbColor: AppColors.caramelo,
                  onChanged: (valor) {
                    setDialogState(() => activo = valor);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, {
                  'rol': rol,
                  'activo': activo,
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.caramelo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> confirmar({
    required BuildContext context,
    required String nombre,
    required String rolAnterior,
    required String rolNuevo,
    required bool activoAnterior,
    required bool activoNuevo,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cremaClaro,
        title: const Text('Confirmar cambios'),
        content: Text(
          '¿Deseas guardar los cambios de $nombre?\n\n'
          'Rol: ${nombreRol(rolAnterior)} → '
          '${nombreRol(rolNuevo)}\n'
          'Estado: ${activoAnterior ? "Activo" : "Inactivo"} → '
          '${activoNuevo ? "Activo" : "Inactivo"}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.caramelo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}