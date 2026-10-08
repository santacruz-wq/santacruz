import 'package:flutter/material.dart';

import '../../../models/mesa_model.dart';
import '../../../widgets/mesero/mesa_card.dart';

/// Cuadrícula de mesas con pull-to-refresh.
class MesasGrid extends StatelessWidget {
  final List<MesaModel> mesas;
  final Future<void> Function() onRefresh;
  final void Function(MesaModel mesa) onMesaTap;

  const MesasGrid({
    super.key,
    required this.mesas,
    required this.onRefresh,
    required this.onMesaTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.95,
        ),
        itemCount: mesas.length,
        itemBuilder: (context, index) {
          final mesa = mesas[index];

          return MesaCard(
            mesa: mesa,
            onTap: () => onMesaTap(mesa),
          );
        },
      ),
    );
  }
}