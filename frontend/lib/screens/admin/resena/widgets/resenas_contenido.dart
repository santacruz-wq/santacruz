import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import 'resena_card.dart';

class ResenasContenido extends StatelessWidget {
  final bool cargando;
  final String? error;
  final String filtro;
  final List<Map<String, dynamic>> resenas;
  final Future<void> Function() onActualizar;
  final Future<void> Function(Map<String, dynamic>) onEliminar;

  const ResenasContenido({
    super.key,
    required this.cargando,
    required this.error,
    required this.filtro,
    required this.resenas,
    required this.onActualizar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onActualizar,
                icon: const Icon(Icons.refresh),
                label: const Text('Intentar de nuevo'),
              ),
            ],
          ),
        ),
      );
    }

    if (resenas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 60,
                color: AppColors.cafeMedio,
              ),
              const SizedBox(height: 12),
              Text(
                filtro.isEmpty
                    ? 'Todavía no hay reseñas.'
                    : 'No se encontraron reseñas.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textoCafe,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onActualizar,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: resenas.length,
        itemBuilder: (context, index) {
          final resena = resenas[index];
          final usuario = _nombre(resena['usuario']);
          final producto = _nombre(resena['producto']);
          final comentario = _texto(resena['comentario']);
          final calificacion =
              int.tryParse(_texto(resena['calificacion'])) ?? 0;

          return ResenaCard(
            producto: producto,
            usuario: usuario,
            comentario: comentario,
            fecha: _fecha(resena['createdAt']),
            calificacion: calificacion,
            onEliminar: () => onEliminar(resena),
          );
        },
      ),
    );
  }

  String _texto(dynamic valor) {
    if (valor == null || valor is Map || valor is List) return '';
    return valor.toString().trim();
  }

  String _nombre(dynamic valor) {
    if (valor is Map) {
      final nombre = _texto(valor['nombre']);
      return nombre.isNotEmpty ? nombre : 'Sin nombre';
    }
    return 'No disponible';
  }

  String _fecha(dynamic valor) {
    if (valor == null) return 'Fecha no disponible';
    final fecha = DateTime.tryParse(valor.toString());
    if (fecha == null) return 'Fecha no disponible';
    final local = fecha.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }
}