import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../../../widgets/mesero/estado_orden_button.dart';
import '../helpers/orden_estado.dart';
import 'detalle_orden_card.dart';
import 'orden_info_card.dart';
import 'orden_total_card.dart';

/// Contenido completo de la pantalla de una orden.
class OrdenContenido extends StatelessWidget {
  final OrdenModel orden;
  final List<OrdenDetalleModel> detalles;
  final Future<void> Function() onRefresh;
  final VoidCallback onAgregarProductos;

  const OrdenContenido({
    super.key,
    required this.orden,
    required this.detalles,
    required this.onRefresh,
    required this.onAgregarProductos,
  });

  @override
  Widget build(BuildContext context) {
    final puedeAgregar = puedeAgregarProductos(
      orden.estado,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // INFORMACIÓN DE LA ORDEN
          OrdenInfoCard(orden: orden),

          const SizedBox(height: 16),

          // ============================
          // AGREGAR PRODUCTOS / ADICIÓN
          // ============================

          if (puedeAgregar)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAgregarProductos,
                icon: const Icon(Icons.add),
                label: Text(
                  orden.estaPendiente
                      ? 'Agregar productos'
                      : 'Agregar nueva adición',
                ),
              ),
            ),

          const SizedBox(height: 12),

          // ============================
          // CAMBIAR ESTADO
          // ============================

          EstadoOrdenButton(
            orden: orden,
            onActualizado: onRefresh,
          ),

          const SizedBox(height: 20),

          // ============================
          // PRODUCTOS
          // ============================

          const Text(
            'Productos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (detalles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No hay productos en esta orden',
                ),
              ),
            )
          else
            ...detalles.map(
              (detalle) => DetalleOrdenCard(
                detalle: detalle,
              ),
            ),

          const SizedBox(height: 10),

          // TOTAL
          OrdenTotalCard(orden: orden),
        ],
      ),
    );
  }
}