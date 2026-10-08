import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

/// Valor que devuelve el sheet cuando se elige "Todas las mesas".
const String kTodasLasMesas = '__TODAS__';

/// Abre el sheet para elegir una mesa. Devuelve el nombre de la mesa,
/// [kTodasLasMesas], o null si se cierra sin elegir.
Future<String?> mostrarFiltroMesa(
  BuildContext context, {
  required List<String> mesas,
  required String? mesaSeleccionada,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    backgroundColor: AppColors.cremaClaro,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.table_restaurant_rounded,
                    color: AppColors.caramelo,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Filtrar por mesa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoCafe,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.cafeMedio,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(
                color: AppColors.cremaOscuro,
              ),
              _MesaOpcion(
                icono: Icons.all_inclusive,
                titulo: 'Todas las mesas',
                seleccionada: mesaSeleccionada == null,
                onTap: () {
                  Navigator.pop(context, kTodasLasMesas);
                },
              ),
              ...mesas.map(
                (mesa) => _MesaOpcion(
                  icono: Icons.table_restaurant,
                  titulo: mesa,
                  seleccionada: mesaSeleccionada == mesa,
                  onTap: () {
                    Navigator.pop(context, mesa);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _MesaOpcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool seleccionada;
  final VoidCallback onTap;

  const _MesaOpcion({
    required this.icono,
    required this.titulo,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.caramelo.withValues(
          alpha: 0.12,
        ),
        child: Icon(
          icono,
          color: AppColors.caramelo,
        ),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          color: AppColors.textoCafe,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: seleccionada
          ? Icon(
              Icons.check_circle,
              color: AppColors.caramelo,
            )
          : null,
      onTap: onTap,
    );
  }
}