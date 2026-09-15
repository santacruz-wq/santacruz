import 'package:flutter/material.dart';

class EstadoVacioDirecciones extends StatelessWidget {
  final VoidCallback onAgregar;

  const EstadoVacioDirecciones({
    super.key,
    required this.onAgregar,
  });

  static const Color cafe = Color(0xFF6D4C41);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color crema = Color(0xFFFFF8E7);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: crema,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: cafe,
                size: 45,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No tienes direcciones guardadas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cafeOscuro,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Agrega una dirección para recibir tus pedidos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAgregar,
              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'AGREGAR DIRECCIÓN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}