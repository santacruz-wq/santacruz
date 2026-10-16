import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class AdministradoresDialogos {
  static Future<String?> pedirPassword(
    BuildContext context,
  ) async {
    if (!context.mounted) return null;

    final controlador = TextEditingController();
    bool ocultar = true;

    try {
      final password = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (contextDialogo, actualizarDialogo) {
              return AlertDialog(
                backgroundColor: AppColors.cremaClaro,
                title: const Text('Confirmar identidad'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ingresa tu contraseña para confirmar '
                      'el cambio de rol.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controlador,
                      obscureText: ocultar,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Tu contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            actualizarDialogo(() {
                              ocultar = !ocultar;
                            });
                          },
                          icon: Icon(
                            ocultar
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onSubmitted: (valor) {
                        if (valor.trim().isNotEmpty) {
                          Navigator.of(dialogContext).pop(
                            valor.trim(),
                          );
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final valor = controlador.text.trim();
                      if (valor.isEmpty) return;
                      Navigator.of(dialogContext).pop(valor);
                    },
                    child: const Text('Confirmar'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (!context.mounted ||
          password == null ||
          password.trim().isEmpty) {
        return null;
      }

      return password.trim();
    } finally {
      await WidgetsBinding.instance.endOfFrame;
      controlador.dispose();
    }
  }
}