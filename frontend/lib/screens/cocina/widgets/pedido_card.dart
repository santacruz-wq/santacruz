import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import 'detalle_item.dart';

class PedidoCard extends StatelessWidget {
  final OrdenModel orden;
  final List<OrdenDetalleModel> detalles;
  final VoidCallback onMarcarListo;

  const PedidoCard({
    super.key,
    required this.orden,
    required this.detalles,
    required this.onMarcarListo,
  });

  @override
  Widget build(BuildContext context) {
    final detallesOriginales = detalles
        .where((detalle) => !detalle.esAdicion)
        .toList();

    final detallesAdicion = detalles
        .where((detalle) => detalle.esAdicion)
        .toList();

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ENCABEZADO
            Row(
              children: [
                const Icon(
                  Icons.table_restaurant,
                  size: 28,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    orden.mesaNombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'En cocina',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            // MESERO
            Text(
              'Mesero: ${orden.meseroNombre}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const Divider(
              height: 24,
            ),

            // PRODUCTOS ORIGINALES
            if (detallesOriginales.isNotEmpty) ...[
              const Text(
                'Productos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ...detallesOriginales.map(
                (detalle) => DetalleItem(
                  detalle: detalle,
                ),
              ),
            ],

            // NUEVAS ADICIONES
            if (detallesAdicion.isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withAlpha(120),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notification_important,
                      color: Colors.orange,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'NUEVA ADICIÓN',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ...detallesAdicion.map(
                (detalle) => DetalleItem(
                  detalle: detalle,
                ),
              ),
            ],

            const SizedBox(
              height: 8,
            ),

            // BOTÓN MARCAR COMO LISTO
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onMarcarListo,
                icon: const Icon(
                  Icons.check_circle,
                ),
                label: const Text(
                  'Marcar como listo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}