import 'package:flutter/material.dart';

class ConfiguracionSwitch extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool valor;
  final bool modoOscuro;
  final ValueChanged<bool> onChanged;

  const ConfiguracionSwitch({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.modoOscuro,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color fondo = modoOscuro
        ? const Color(0xFF2A211E)
        : const Color(0xFFFFFBF5);

    final Color textoPrincipal = modoOscuro
        ? Colors.white
        : const Color(0xFF4E342E);

    final Color textoSecundario = modoOscuro
        ? const Color(0xFFD7CCC8)
        : const Color(0xFF8D6E63);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFDDB447).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icono, color: const Color(0xFFDDB447)),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            color: textoPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitulo,
            style: TextStyle(color: textoSecundario, fontSize: 13),
          ),
        ),
        trailing: Switch(
          value: valor,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFDDB447),
          activeTrackColor: const Color(0xFF6F4E37),
        ),
      ),
    );
  }
}
