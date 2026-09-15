
import 'package:flutter/material.dart';

class PrivacidadOpcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final Widget trailing;
  final VoidCallback? onTap;

  final bool oscuro;
  final Color tarjeta;
  final Color iconoFondo;
  final Color textoPrincipal;
  final Color textoSecundario;
  final Color cafe;
  final Color dorado;

  const PrivacidadOpcion({
    super.key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.trailing,
    required this.oscuro,
    required this.tarjeta,
    required this.iconoFondo,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.cafe,
    required this.dorado,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tarjeta,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconoFondo,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icono,
                  color: oscuro ? dorado : cafe,
                  size: 25,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textoPrincipal,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descripcion,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

