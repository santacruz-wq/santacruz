
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/translation_resenas.dart';
import '../../providers/language_provider.dart';
import 'star_rating.dart';

Future<void> mostrarResenaForm(
  BuildContext context, {
  required String nombreProducto,
  int ratingInicial = 0,
  String comentarioInicial = '',
  required Future<void> Function(int calificacion, String comentario) onEnviar,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cremaClaro,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
      ),
      child: _ResenaForm(
        nombreProducto: nombreProducto,
        ratingInicial: ratingInicial,
        comentarioInicial: comentarioInicial,
        onEnviar: onEnviar,
      ),
    ),
  );
}

class _ResenaForm extends StatefulWidget {
  final String nombreProducto;
  final int ratingInicial;
  final String comentarioInicial;
  final Future<void> Function(int, String) onEnviar;

  const _ResenaForm({
    required this.nombreProducto,
    required this.ratingInicial,
    required this.comentarioInicial,
    required this.onEnviar,
  });

  @override
  State<_ResenaForm> createState() => _ResenaFormState();
}

class _ResenaFormState extends State<_ResenaForm> {
  late int _rating = widget.ratingInicial;

  late final TextEditingController _controller =
      TextEditingController(text: widget.comentarioInicial);

  bool _enviando = false;

  String _t(String clave) {
    final idioma = context.read<LanguageProvider>().idiomaCodigo;

    return TranslationResenas.obtenerTexto(
      clave: clave,
      idioma: idioma,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('seleccionar_puntaje'))),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      await widget.onEnviar(_rating, _controller.text.trim());

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _enviando = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('error_enviar'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.nombreProducto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textoCafe,
            ),
          ),
          const SizedBox(height: 16),
          StarRating(
            rating: _rating.toDouble(),
            size: 40,
            onChanged: (valor) => setState(() => _rating = valor),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLength: 250,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: _t('comentario_opcional'),
              filled: true,
              fillColor: AppColors.tarjeta,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enviando ? null : _enviar,
              child: _enviando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_t('enviar_resena')),
            ),
          ),
        ],
      ),
    );
  }
}
