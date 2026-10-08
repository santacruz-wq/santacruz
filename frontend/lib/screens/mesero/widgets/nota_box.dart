import 'package:flutter/material.dart';

/// Recuadro que muestra la nota de un producto con botón de editar.
class NotaBox extends StatelessWidget {
  final String nota;
  final VoidCallback onEditar;

  const NotaBox({
    super.key,
    required this.nota,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color: Colors.amber.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.sticky_note_2_outlined,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              nota,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onEditar,
            icon: const Icon(
              Icons.edit,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}