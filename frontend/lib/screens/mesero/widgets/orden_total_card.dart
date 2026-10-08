import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';

// ============================
// TOTAL
// ============================

class OrdenTotalCard extends StatelessWidget {
  final OrdenModel orden;

  const OrdenTotalCard({
    super.key,
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TOTAL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '\$${orden.total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}