
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class PerfilSeccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget contenido;

  const PerfilSeccion({
    super.key,
    required this.titulo,
    required this.icono,
    required this.contenido,
  });

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.cremaClaro,
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icono, color: AppColors.caramelo, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoCafe,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              contenido,
            ],
          ),
        ),
      );
}

class PerfilFila extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const PerfilFila({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: AppColors.cafeMedio, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.cafeMedio,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textoCafe,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class PerfilBoton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback accion;
  final bool deshabilitado;

  const PerfilBoton({
    super.key,
    required this.texto,
    required this.icono,
    required this.accion,
    this.deshabilitado = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: deshabilitado ? null : accion,
          icon: Icon(icono),
          label: Text(texto),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cafeMedio,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: AppColors.cremaOscuro),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
}
