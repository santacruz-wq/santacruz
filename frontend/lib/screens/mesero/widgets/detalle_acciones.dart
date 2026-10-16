import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../helpers/detalle_colores.dart';

/// Botones de acción según el estado del pedido.
class DetalleAcciones extends StatelessWidget {
  final OrdenModel orden;
  final void Function(String estado) onCambiarEstado;
  final VoidCallback onAgregarProducto;

  const DetalleAcciones({
    super.key,
    required this.orden,
    required this.onCambiarEstado,
    required this.onAgregarProducto,
  });

  @override
  Widget build(BuildContext context) {
    if (orden.estaPagado || orden.estaCancelado) {
      return const SizedBox.shrink();
    }

    if (orden.estaPendiente) {
      return Column(
        children: [
          AccionBoton(
            texto: 'Enviar a cocina',
            icono: Icons.restaurant,
            principal: true,
            onPressed: () {
              onCambiarEstado('en_cocina');
            },
          ),
          const SizedBox(height: 10),
          AccionBoton(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: onAgregarProducto,
          ),
        ],
      );
    }

    if (orden.estaEnCocina) {
      return AccionBoton(
        texto: 'Agregar producto',
        icono: Icons.add_shopping_cart,
        onPressed: onAgregarProducto,
      );
    }

    if (orden.estaListo) {
      return Column(
        children: [
          AccionBoton(
            texto: 'Marcar como entregado',
            icono: Icons.room_service,
            principal: true,
            onPressed: () {
              onCambiarEstado('servido');
            },
          ),
          const SizedBox(height: 10),
          AccionBoton(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: onAgregarProducto,
          ),
        ],
      );
    }

    if (orden.estaServido) {
      return Column(
        children: [
          AccionBoton(
            texto: 'Marcar como pagado',
            icono: Icons.payments,
            principal: true,
            onPressed: () {
              onCambiarEstado('pagado');
            },
          ),
          const SizedBox(height: 10),
          AccionBoton(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: onAgregarProducto,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

/// Botón ancho con ícono (principal = relleno, si no = contorno).
class AccionBoton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback onPressed;
  final bool principal;

  const AccionBoton({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    this.principal = false,
  });

  @override
  Widget build(BuildContext context) {
    const caramelo = DetalleColores.caramelo;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              principal ? caramelo : Colors.white,
          foregroundColor:
              principal ? Colors.white : caramelo,
          elevation: 0,
          side: principal
              ? null
              : const BorderSide(
                  color: caramelo,
                ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}