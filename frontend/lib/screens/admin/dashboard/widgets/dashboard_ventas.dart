
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import 'titulo_seccion.dart';
import 'tarjeta_estadistica.dart';

class DashboardVentas extends StatelessWidget {
  final String hoy;
  final String semana;
  final String mes;
  final int pedidosPagados;
  final List<double> ventasDiarias;
  final List<String> etiquetas;
  final String Function(num) formatearPesos;

  const DashboardVentas({
    super.key,
    required this.hoy,
    required this.semana,
    required this.mes,
    required this.pedidosPagados,
    required this.ventasDiarias,
    required this.etiquetas,
    required this.formatearPesos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloSeccion(
          titulo: 'Resumen de ventas',
          subtitulo: 'Órdenes pagadas',
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            TarjetaEstadistica(
              titulo: 'Hoy',
              valor: hoy,
              icono: Icons.today,
            ),
            TarjetaEstadistica(
              titulo: 'Últimos 7 días',
              valor: semana,
              icono: Icons.date_range,
            ),
            TarjetaEstadistica(
              titulo: 'Este mes',
              valor: mes,
              icono: Icons.calendar_month,
            ),
            TarjetaEstadistica(
              titulo: 'Pedidos pagados',
              valor: '$pedidosPagados',
              icono: Icons.check_circle_outline,
            ),
          ],
        ),
        const SizedBox(height: 26),
        const TituloSeccion(
          titulo: 'Ventas de la semana',
          subtitulo: 'Valores diarios de órdenes pagadas',
        ),
        const SizedBox(height: 12),
        _GraficaVentas(
          ventas: ventasDiarias,
          etiquetas: etiquetas,
          formatearPesos: formatearPesos,
        ),
      ],
    );
  }
}

class _GraficaVentas extends StatelessWidget {
  final List<double> ventas;
  final List<String> etiquetas;
  final String Function(num) formatearPesos;

  const _GraficaVentas({
    required this.ventas,
    required this.etiquetas,
    required this.formatearPesos,
  });

  @override
  Widget build(BuildContext context) {
    final maximo = ventas.fold<double>(
      0,
      (actual, venta) => venta > actual ? venta : actual,
    );

    return Card(
      color: AppColors.cremaClaro,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ${formatearPesos(ventas.fold<double>(0, (a, b) => a + b))}',
              style: const TextStyle(
                color: AppColors.textoCafe,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(ventas.length, (index) {
                  final proporcion =
                      maximo == 0 ? 0.0 : ventas[index] / maximo;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (ventas[index] > 0)
                            Text(
                              formatearPesos(ventas[index]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.cafeMedio,
                              ),
                            ),
                          const SizedBox(height: 5),
                          Container(
                            height: 105 * proporcion + 3,
                            decoration: BoxDecoration(
                              color: AppColors.caramelo,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            index < etiquetas.length
                                ? etiquetas[index]
                                : '',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.cafeMedio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
