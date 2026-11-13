
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import 'manual_usuario.dart';
import 'preguntas_frecuentes.dart';
import 'politica_privacidad.dart';

class AyudaSoporte extends StatefulWidget {
  const AyudaSoporte({super.key});

  @override
  State<AyudaSoporte> createState() => _AyudaSoporteState();
}

class _AyudaSoporteState extends State<AyudaSoporte> {
  bool _expandido = false;

  void _abrirPagina(Widget pagina) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pagina),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cremaClaro,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cremaOscuro,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: AppColors.cafeMedio,
              size: 26,
            ),
            title: const Text(
              'Ayuda y soporte',
              style: TextStyle(
                color: AppColors.textoCafe,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Consulta información y resuelve tus dudas',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Icon(
              _expandido
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.cafeMedio,
            ),
            onTap: () {
              setState(() {
                _expandido = !_expandido;
              });
            },
          ),
          if (_expandido) ...[
            const Divider(height: 1),
            _opcion(
              icono: Icons.menu_book_outlined,
              titulo: 'Manual de usuario',
              accion: () => _abrirPagina(
                const ManualUsuario(),
              ),
            ),
            _opcion(
              icono: Icons.quiz_outlined,
              titulo: 'Preguntas frecuentes',
              accion: () => _abrirPagina(
                const PreguntasFrecuentesScreen(),
              ),
            ),
            _opcion(
              icono: Icons.privacy_tip_outlined,
              titulo: 'Política de privacidad',
              accion: () => _abrirPagina(
                const PoliticaPrivacidadScreen(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required VoidCallback accion,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 55,
        right: 16,
      ),
      leading: Icon(
        icono,
        color: AppColors.cafeMedio,
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.cafeMedio,
        size: 20,
      ),
      onTap: accion,
    );
  }
}