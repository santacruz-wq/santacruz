
import 'package:flutter/material.dart';
import '../../carrito_data.dart';
import '../../idioma_data.dart';

class CarritoCard extends StatelessWidget {
  final Map<String, dynamic> producto;
  final int index;
  final bool es;
  final VoidCallback onActualizar;
  final VoidCallback onEliminar;

  const CarritoCard({
    super.key,
    required this.producto,
    required this.index,
    required this.es,
    required this.onActualizar,
    required this.onEliminar,
  });

  static const cafeOscuro = Color(0xFF4E342E);
  static const cafe = Color(0xFF6F4E37);
  static const cafeClaro = Color(0xFF8D6E63);
  static const crema = Color(0xFFF7F1E8);
  static const cremaClara = Color(0xFFFFFBF5);
  static const dorado = Color(0xFFD4A017);
  static const doradoClaro = Color(0xFFF3D27A);

  double precioNumero(String precio) {
    return double.parse(
      precio.replaceAll('\$', '').replaceAll('.', ''),
    );
  }

  String precioFormato(double precio) {
    final numero = precio.toInt().toString();
    final partes = <String>[];

    while (numero.length > 3) {
      partes.insert(0, numero.substring(numero.length - 3));
      // No modificamos el String original.
      break;
    }

    if (numero.length <= 3) {
      return '\$$numero';
    }

    var texto = numero;
    partes.clear();

    while (texto.length > 3) {
      partes.insert(0, texto.substring(texto.length - 3));
      texto = texto.substring(0, texto.length - 3);
    }

    partes.insert(0, texto);

    return '\$${partes.join('.')}';
  }

  String nombreProducto() {
    switch (producto['index']) {
      case 0:
        return es ? 'Postre de capuchino' : 'Cappuccino dessert';
      case 1:
        return es ? 'Postre de mora' : 'Blackberry dessert';
      case 2:
        return es ? 'Torta de tres leches' : 'Tres leches cake';
      case 3:
        return es ? 'Torta de café' : 'Coffee cake';
      case 4:
        return es ? 'Cheesecake de fresa' : 'Strawberry cheesecake';
      case 5:
        return es ? 'Brownie de chocolate' : 'Chocolate brownie';
      case 6:
        return es ? 'Cupcake de vainilla' : 'Vanilla cupcake';
      case 7:
        return es ? 'Tarta de limón' : 'Lemon pie';
      default:
        return producto['nombre'] as String? ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;

    final fondo = oscuro ? const Color(0xFF2B211D) : cremaClara;
    final fondoIcono = oscuro ? const Color(0xFF3A2C26) : crema;
    final texto = oscuro ? Colors.white : cafeOscuro;
    final textoSecundario = oscuro ? Colors.white70 : cafe;

    final precio = precioNumero(producto['precio'] as String);
    final cantidad = producto['cantidad'] as int;
    final subtotal = precio * cantidad;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: oscuro
              ? cafeClaro.withValues(alpha: 0.25)
              : doradoClaro.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: oscuro ? 0.20 : 0.07,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconoProducto(oscuro, fondoIcono),
              const SizedBox(width: 13),
              Expanded(
                child: _informacion(
                  texto,
                  oscuro,
                  precio,
                  cantidad,
                  subtotal,
                ),
              ),
              _botonEliminar(oscuro),
            ],
          ),
          const SizedBox(height: 12),
          _controlCantidad(oscuro, texto),
        ],
      ),
    );
  }

  Widget _iconoProducto(bool oscuro, Color fondoIcono) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: oscuro
              ? [
                  const Color(0xFF3A2C26),
                  const Color(0xFF2B211D),
                ]
              : [
                  doradoClaro.withValues(alpha: 0.42),
                  crema,
                ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: oscuro
                ? cafe.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.65),
            shape: BoxShape.circle,
          ),
          child: Icon(
            producto['icono'] as IconData,
            size: 32,
            color: oscuro ? doradoClaro : cafe,
          ),
        ),
      ),
    );
  }

  Widget _informacion(
    Color texto,
    bool oscuro,
    double precio,
    int cantidad,
    double subtotal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nombreProducto(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.15,
            color: texto,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: oscuro
                ? dorado.withValues(alpha: 0.16)
                : doradoClaro.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            producto['precio'] as String,
            style: TextStyle(
              color: oscuro ? doradoClaro : dorado,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '${IdiomaData.texto('subtotal')}: ${precioFormato(subtotal)}',
          style: TextStyle(
            color: oscuro ? Colors.white70 : cafe,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _botonEliminar(bool oscuro) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: es ? 'Eliminar' : 'Remove',
        onPressed: onEliminar,
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 22,
        ),
      ),
    );
  }

  Widget _controlCantidad(bool oscuro, Color texto) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: oscuro ? const Color(0xFF382A25) : crema,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            es ? 'Cantidad' : 'Quantity',
            style: TextStyle(
              color: oscuro ? Colors.white70 : cafeClaro,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              _botonCantidad(
                Icons.remove,
                oscuro,
                () {
                  CarritoData.disminuirCantidad(index);
                  onActualizar();
                },
              ),
              const SizedBox(width: 13),
              Text(
                '${producto['cantidad']}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
              const SizedBox(width: 13),
              _botonCantidad(
                Icons.add,
                oscuro,
                () {
                  CarritoData.aumentarCantidad(index);
                  onActualizar();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonCantidad(
    IconData icono,
    bool oscuro,
    VoidCallback accion,
  ) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: doradoClaro.withValues(
          alpha: oscuro ? 0.14 : 0.30,
        ),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: accion,
        icon: Icon(
          icono,
          color: oscuro ? doradoClaro : cafe,
          size: 18,
        ),
      ),
    );
  }
}



