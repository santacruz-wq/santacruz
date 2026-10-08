import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';

// ============================================================
// DIÁLOGO PARA AGREGAR / EDITAR NOTA
// ============================================================

class NotaDialog extends StatefulWidget {
  final ProductoModel producto;
  final String notaInicial;

  const NotaDialog({
    super.key,
    required this.producto,
    required this.notaInicial,
  });

  @override
  State<NotaDialog> createState() => _NotaDialogState();
}

class _NotaDialogState extends State<NotaDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.notaInicial,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // CERRAR SIN GUARDAR
  void _cancelar() {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop();
  }

  // GUARDAR NOTA
  void _guardar() {
    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.of(context).pop(
      _controller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nota para ${widget.producto.nombre}',
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: 'Ej: Sin crema, poco dulce...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancelar,
          child: const Text(
            'Cancelar',
          ),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: const Text(
            'Guardar',
          ),
        ),
      ],
    );
  }
}

/// Abre el diálogo y devuelve el texto (o null si se cancela).
Future<String?> mostrarNotaDialog(
  BuildContext context,
  ProductoModel producto,
  String notaInicial,
) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => NotaDialog(
      producto: producto,
      notaInicial: notaInicial,
    ),
  );
}