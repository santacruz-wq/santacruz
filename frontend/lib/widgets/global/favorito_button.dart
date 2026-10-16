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
  State<FavoritoButton> createState() => _FavoritoButtonState();
}

class _FavoritoButtonState extends State<FavoritoButton> {
  bool _procesando = false;

  // VERIFICAMOS SI HAY SESIÓN
  bool get _haySesion {
    return context.read<AuthProvider>().usuario != null;
  }

  Future<void> _toggleFavorito() async {
    if (_procesando) return;

    // SI NO HAY SESIÓN
    if (!_haySesion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicia sesión para guardar favoritos'),
        ),
      );

      await Navigator.pushNamed(context, '/login');

      return;
    }

    setState(() {
      _procesando = true;
    });

    try {
      final provider = context.read<FavoritoProvider>();

      final exito = await provider.toggle(widget.productoId);

      if (!exito && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo actualizar el favorito'),
          ),
        );
      }
    } catch (error) {
      debugPrint('Error al cambiar favorito: $error');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error al actualizar el favorito'),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _procesando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<FavoritoProvider>();

    final esFavorito = favoritos.esFavorito(widget.productoId);

    return GestureDetector(
      onTap: _toggleFavorito,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: _procesando
            ? SizedBox(
                width: widget.size,
                height: widget.size,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Icon(
                esFavorito
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: esFavorito
                    ? Colors.red
                    : Colors.grey,
                size: widget.size,
              ),
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