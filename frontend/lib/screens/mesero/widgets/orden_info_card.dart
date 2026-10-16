import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../helpers/orden_estado.dart';

// ============================
// INFORMACIÓN DE LA ORDEN
// ============================

class OrdenInfoCard extends StatelessWidget {
  final OrdenModel orden;

  const OrdenInfoCard({
    super.key,
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mesa: ${orden.mesaNombre}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Text(
                  'Estado: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: estadoColor(
                      orden.estado,
                    ).withAlpha(30),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Text(
                    estadoTexto(
                      orden.estado,
                    ),
                    style: TextStyle(
                      color: estadoColor(
                        orden.estado,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}