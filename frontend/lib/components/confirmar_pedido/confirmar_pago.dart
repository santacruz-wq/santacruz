
import 'package:flutter/material.dart';

class ConfirmarPago extends StatelessWidget {
  final String metodoPago;
  final bool es;

  final String titulo;

  final Color cafe;
  final Color cafeOscuro;
  final Color crema;

  final ValueChanged<String?> onChanged;

  const ConfirmarPago({
    super.key,
    required this.metodoPago,
    required this.es,
    required this.titulo,
    required this.cafe,
    required this.cafeOscuro,
    required this.crema,
    required this.onChanged,
  });

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

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: metodoPago,

            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.payment,
                color: cafe,
              ),
              filled: true,
              fillColor: crema,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            items: [
              DropdownMenuItem(
                value: 'Efectivo',
                child: Text(
                  es ? 'Efectivo' : 'Cash',
                ),
              ),

              DropdownMenuItem(
                value: 'Tarjeta',
                child: Text(
                  es ? 'Tarjeta' : 'Card',
                ),
              ),

              const DropdownMenuItem(
                value: 'Nequi',
                child: Text('Nequi'),
              ),

              const DropdownMenuItem(
                value: 'Daviplata',
                child: Text('Daviplata'),
              ),
            ],

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

