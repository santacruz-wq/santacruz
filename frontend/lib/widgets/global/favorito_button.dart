import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/favorito_service.dart';

class FavoritoButton extends StatefulWidget {
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
  bool _esFavorito = false;
  bool _cargando = true;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();
    _verificarEstado();
  }

  //INDICA SI HAY UN USUARIO CON SESION ACTIVA
  bool get _haySesion => context.read<AuthProvider>().usuario != null;

  Future<void> _verificarEstado() async {
    //SIN SESION NO CONSULTAMOS AL BACKEND (LA RUTA EXIGE TOKEN)
    if (!_haySesion) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    final resultado = await FavoritoService.esFavorito(widget.productoId);
    if (mounted) {
      setState(() {
        _esFavorito = resultado;
        _cargando = false;
      });
    }
  }

  Future<void> _toggleFavorito() async {
    if (_procesando) return;

    //SI NO ESTA REGISTRADO LO MANDAMOS AL LOGIN
    if (!_haySesion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para guardar favoritos')),
      );
      await Navigator.pushNamed(context, '/login');

      //AL VOLVER DEL LOGIN, SI YA INICIO SESION, ACTUALIZAMOS EL CORAZON
      if (mounted && _haySesion) {
        setState(() => _cargando = true);
        await _verificarEstado();
      }
      return;
    }

    setState(() => _procesando = true);

    //ACTUALIZAMOS LA UI DE INMEDIATO (OPTIMISTA) Y REVERTIMOS SI FALLA
    final estadoAnterior = _esFavorito;
    setState(() => _esFavorito = !_esFavorito);

    final exito = _esFavorito
        ? await FavoritoService.agregarFavorito(widget.productoId)
        : await FavoritoService.quitarFavorito(widget.productoId);

    if (!exito && mounted) {
      setState(() => _esFavorito = estadoAnterior);
    }

    if (mounted) setState(() => _procesando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return GestureDetector(
      onTap: _toggleFavorito,
      child: Icon(
        _esFavorito ? Icons.favorite : Icons.favorite_border,
        color: _esFavorito ? Colors.red : Colors.grey,
        size: widget.size,
      ),
    );
  }
}