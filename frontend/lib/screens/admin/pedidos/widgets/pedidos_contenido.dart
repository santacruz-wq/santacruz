
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_model.dart';
import 'pedido_card.dart';

class PedidosContenido extends StatelessWidget {
  final bool cargando;
  final String? error;
  final List<OrdenModel> ordenes;
  final Future<void> Function() onActualizar;
  final ValueChanged<OrdenModel> onVerDetalle;

  const PedidosContenido({
    super.key,
    required this.cargando,
    required this.error,
    required this.ordenes,
    required this.onActualizar,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando && ordenes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.caramelo),
      );
    }

    if (error != null && ordenes.isEmpty) {
      return _mensaje(
        icono: Icons.cloud_off_outlined,
        titulo: 'No se pudieron cargar los pedidos',
        mensaje: error!,
        boton: 'Intentar nuevamente',
      );
    }

    if (ordenes.isEmpty) {
      return _mensaje(
        icono: Icons.receipt_long_outlined,
        titulo: 'No hay pedidos para mostrar',
        mensaje: error != null
            ? 'No se pudo actualizar la información. Comprueba tu conexión.'
            : 'Prueba cambiando el filtro de fecha, el estado o la búsqueda.',
        boton: 'Actualizar',
      );
    }

    return RefreshIndicator(
      color: AppColors.caramelo,
      onRefresh: onActualizar,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: ordenes.length,
        itemBuilder: (_, index) {
          final orden = ordenes[index];
          return PedidoCard(
            orden: orden,
            onTap: () => onVerDetalle(orden),
          );
        },
      ),
    );
  }

  Widget _mensaje({
    required IconData icono,
    required String titulo,
    required String mensaje,
    required String boton,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 58, color: AppColors.cafeMedio),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textoCafe,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.cafeMedio),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onActualizar,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cafeMedio,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: Text(boton),
            ),
          ],
        ),
      ),
    );
  }
}
