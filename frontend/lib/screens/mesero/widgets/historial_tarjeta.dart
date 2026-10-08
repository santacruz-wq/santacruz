import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/orden_model.dart';
import '../helpers/historial_formato.dart';

/// Tarjeta de un pedido del historial.
class HistorialTarjeta extends StatelessWidget {
  final OrdenModel orden;
  final VoidCallback onTap;

  const HistorialTarjeta({
    super.key,
    required this.orden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = colorEstadoHistorial(orden.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cremaClaro,
      elevation: 1.5,
      shadowColor: AppColors.textoCafe.withValues(
        alpha: 0.12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.caramelo.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.table_restaurant_rounded,
                      color: AppColors.caramelo,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          orden.mesaNombre.isNotEmpty
                              ? orden.mesaNombre
                              : 'Mesa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textoCafe,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Mesero: ${orden.meseroNombre.isNotEmpty ? orden.meseroNombre : 'Sin asignar'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.cafeMedio,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorEstado.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          orden.estaPagado
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 16,
                          color: colorEstado,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          textoEstadoHistorial(
                            orden.estado,
                          ),
                          style: TextStyle(
                            color: colorEstado,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Divider(
                height: 1,
                color: AppColors.cremaOscuro,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 17,
                    color: AppColors.cafeMedio,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    horaCorta(orden.createdAt),
                    style: TextStyle(
                      color: AppColors.cafeMedio,
                      fontSize: 13,
                    ),
                  ),
                  if (orden.createdAt != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: AppColors.cafeMedio.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fechaCorta(
                          orden.createdAt!.toLocal(),
                        ),
                        style: TextStyle(
                          color: AppColors.cafeMedio,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ] else
                    const Spacer(),
                  Text(
                    '\$${orden.total.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.caramelo,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.cafeMedio,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}