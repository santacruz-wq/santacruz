
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/translation_resenas.dart';
import '../../models/resena.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/resena_provider.dart';
import 'star_rating.dart';

Future<void> mostrarResenasProducto(
  BuildContext context, {
  required String productoId,
  required String nombre,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cremaClaro,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) => ResenasSection(
        productoId: productoId,
        nombreProducto: nombre,
        scrollController: scrollController,
      ),
    ),
  );
}

class ResenasSection extends StatefulWidget {
  final String productoId;
  final String nombreProducto;
  final ScrollController? scrollController;

  const ResenasSection({
    super.key,
    required this.productoId,
    required this.nombreProducto,
    this.scrollController,
  });

  @override
  State<ResenasSection> createState() => _ResenasSectionState();
}

class _ResenasSectionState extends State<ResenasSection> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _enviando = false;
  bool _sincronizado = false;
  String? _mensaje;
  bool _mensajeError = false;

  String _t(String clave) {
    final idioma = context.read<LanguageProvider>().idiomaCodigo;
    return TranslationResenas.obtenerTexto(
      clave: clave,
      idioma: idioma,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ResenaProvider>().cargar(widget.productoId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sincronizar(Resena? mia) {
    if (mia != null && !_sincronizado) {
      _rating = mia.calificacion;
      _controller.text = mia.comentario;
      _sincronizado = true;
    }
  }

  Future<void> _enviar(String? usuarioId) async {
    if (_rating == 0) {
      setState(() {
        _mensaje = _t('seleccionar_estrellas');
        _mensajeError = true;
      });
      return;
    }

    final provider = context.read<ResenaProvider>();

    setState(() {
      _enviando = true;
      _mensaje = null;
    });

    final exito = await provider.enviar(
      productoId: widget.productoId,
      calificacion: _rating,
      comentario: _controller.text.trim(),
      usuarioId: usuarioId,
    );

    if (!mounted) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _enviando = false;
      _mensajeError = !exito;
      _mensaje = exito
          ? _t('gracias_resena')
          : _t('error_enviar_reintentar');
    });
  }

  Future<void> _eliminar(Resena resena) async {
    final provider = context.read<ResenaProvider>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('eliminar_resena')),
        content: Text(_t('confirmar_eliminar')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('cancelar')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('eliminar')),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final exito = await provider.eliminar(resena.id);
    if (!mounted) return;

    setState(() {
      if (exito) {
        _rating = 0;
        _controller.clear();
        _sincronizado = false;
      }

      _mensajeError = !exito;
      _mensaje = exito
          ? _t('resena_eliminada')
          : _t('error_eliminar');
    });
  }

  String _formatearFecha(DateTime f) {
    final dia = f.day.toString().padLeft(2, '0');
    final mes = f.month.toString().padLeft(2, '0');
    return '$dia/$mes/${f.year}';
  }

  @override
  Widget build(BuildContext context) {
    final resenaProvider = context.watch<ResenaProvider>();
    final usuario = context.watch<AuthProvider>().usuario;

    final usuarioId = usuario?.id;
    final miResena = resenaProvider.miResena(usuarioId);
    final puedeResenar = usuario != null &&
        (usuario.rol == 'user' || usuario.rol == 'usuario');

    _sincronizar(miResena);

    final teclado = MediaQuery.of(context).viewInsets.bottom;

    return ListView(
      controller: widget.scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + teclado),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resenaProvider.total == 0
                  ? '-'
                  : resenaProvider.promedio.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.textoCafe,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRating(rating: resenaProvider.promedio, size: 22),
                const SizedBox(height: 4),
                Text(
                  '${resenaProvider.total} ${resenaProvider.total == 1 ? _t('resena') : _t('resenas')}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.cafeMedio,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (usuario == null)
          Column(
            children: [
              Text(
                _t('iniciar_sesion_dejar'),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text(_t('iniciar_sesion')),
              ),
            ],
          )
        else if (puedeResenar)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tarjeta,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  miResena == null
                      ? _t('tu_calificacion')
                      : _t('tu_resena'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textoCafe,
                  ),
                ),
                const SizedBox(height: 10),
                StarRating(
                  rating: _rating.toDouble(),
                  size: 38,
                  onChanged: (valor) => setState(() {
                    _rating = valor;
                    _mensaje = null;
                  }),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  maxLength: 250,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: _t('comentario_opcional'),
                    filled: true,
                    fillColor: AppColors.cremaClaro,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _enviando ? null : () => _enviar(usuarioId),
                        child: _enviando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                miResena == null
                                    ? _t('enviar_resena')
                                    : _t('guardar_cambios'),
                              ),
                      ),
                    ),
                    if (miResena != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _eliminar(miResena),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                if (_mensaje != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _mensaje!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: _mensajeError
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          Center(
            child: Text(
              '${_t('solo_clientes')} (tu rol: ${usuario.rol})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.cafeMedio,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Divider(color: AppColors.cremaOscuro),
        const SizedBox(height: 8),
        if (resenaProvider.cargando && resenaProvider.resenas.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (resenaProvider.resenas.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                _t('sin_resenas'),
                style: const TextStyle(color: AppColors.cafeMedio),
              ),
            ),
          )
        else
          ...resenaProvider.resenas.map(
            (resena) => _ResenaCard(
              resena: resena,
              esMia: resena.usuarioId == usuarioId,
              fecha: _formatearFecha(resena.fecha),
            ),
          ),
      ],
    );
  }
}

class _ResenaCard extends StatelessWidget {
  final Resena resena;
  final bool esMia;
  final String fecha;

  const _ResenaCard({
    required this.resena,
    required this.esMia,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    final idioma = context.watch<LanguageProvider>().idiomaCodigo;

    String t(String clave) => TranslationResenas.obtenerTexto(
          clave: clave,
          idioma: idioma,
        );

    final inicial = resena.usuarioNombre.isNotEmpty
        ? resena.usuarioNombre[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tarjeta,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.caramelo.withValues(alpha: 0.2),
                child: Text(
                  inicial,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  esMia
                      ? '${resena.usuarioNombre} (${t('tu')})'
                      : resena.usuarioNombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textoCafe,
                  ),
                ),
              ),
              Text(
                fecha,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.cafeMedio,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StarRating(rating: resena.calificacion.toDouble(), size: 16),
          if (resena.comentario.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              resena.comentario,
              style: const TextStyle(color: AppColors.textoCafe),
            ),
          ],
        ],
      ),
    );
  }
}
