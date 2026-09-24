
import 'package:flutter/material.dart';

class ConfirmarBotones extends StatelessWidget {
  final VoidCallback onConfirmar;
  final VoidCallback onVolver;

  final String textoConfirmar;
  final String textoVolver;

  final Color cafe;

  const ConfirmarBotones({
    super.key,
    required this.onConfirmar,
    required this.onVolver,
    required this.textoConfirmar,
    required this.textoVolver,
    required this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: onConfirmar,
            icon: const Icon(Icons.check_circle),
            label: Text(
              textoConfirmar,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: cafe,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: onVolver,
            icon: const Icon(Icons.arrow_back),
            label: Text(
              textoVolver,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: cafe,
              side: BorderSide(
                color: cafe,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

