import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../services/orden_service.dart';

class EstadoOrdenButton extends StatefulWidget {
  final OrdenModel orden;
  final VoidCallback onActualizado;

  const EstadoOrdenButton({
    super.key,
    required this.orden,
    required this.onActualizado,
  });

  @override
  State<EstadoOrdenButton> createState() =>
      _EstadoOrdenButtonState();
}

class _EstadoOrdenButtonState
    extends State<EstadoOrdenButton> {
  bool _cargando = false;

  Future<void> _cambiarEstado(String estado) async {
    if (_cargando) return;

    setState(() {
      _cargando = true;
    });

    try {
      await OrdenService.cambiarEstado(
        widget.orden.id,
        estado,
      );

      if (!mounted) return;

      String mensaje;

      if (estado == 'en_cocina') {
        mensaje = 'Orden enviada a cocina correctamente.';
      } else if (estado == 'servido') {
        mensaje = 'Orden marcada como servida.';
      } else if (estado == 'pagado') {
        mensaje = 'Pago registrado. Mesa liberada.';
      } else {
        mensaje = 'Estado actualizado correctamente.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );

      widget.onActualizado();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ORDEN PENDIENTE
    if (widget.orden.estaPendiente) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _cargando
              ? null
              : () => _cambiarEstado('en_cocina'),
          icon: _cargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.restaurant,
                ),
          label: Text(
            _cargando
                ? 'Enviando...'
                : 'Enviar a cocina',
          ),
        ),
      );
    }

    // ORDEN LISTA
    if (widget.orden.estaListo) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _cargando
              ? null
              : () => _cambiarEstado('servido'),
          icon: _cargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.room_service,
                ),
          label: Text(
            _cargando
                ? 'Procesando...'
                : 'Marcar como servido',
          ),
        ),
      );
    }

    // ORDEN SERVIDA
    if (widget.orden.estaServido) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: _cargando
              ? null
              : () => _cambiarEstado('pagado'),
          icon: _cargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.payments,
                ),
          label: Text(
            _cargando
                ? 'Procesando...'
                : 'Marcar como pagado',
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}