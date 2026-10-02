import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';

class FavoritoButton extends StatelessWidget {
  final String productoId;
  final double size;

  const FavoritoButton({
    super.key,
    required this.productoId,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final haySesion = context.watch<AuthProvider>().usuario != null;
    final favoritoProvider = context.watch<FavoritoProvider>();
    final esFavorito = haySesion && favoritoProvider.esFavorito(productoId);

    return GestureDetector(
      onTap: () async {
        if (!haySesion) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicia sesión para guardar favoritos')),
          );
          await Navigator.pushNamed(context, '/login');
          return;
        }

        final exito = await context.read<FavoritoProvider>().toggle(productoId);

        if (!exito && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo actualizar el favorito')),
          );
        }
      },
      child: Icon(
        esFavorito ? Icons.favorite : Icons.favorite_border,
        color: esFavorito ? Colors.red : Colors.grey,
        size: size,
      ),
    );
  }
}