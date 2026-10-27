
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../core/network/api_client.dart';

class InterpreteVozScreen extends StatefulWidget {
  const InterpreteVozScreen({super.key});

  @override
  State<InterpreteVozScreen> createState() => _InterpreteVozScreenState();
}

class _InterpreteVozScreenState extends State<InterpreteVozScreen> {
  final stt.SpeechToText _reconocimiento = stt.SpeechToText();
  final FlutterTts _voz = FlutterTts();

  bool _inicializado = false;
  bool _escuchando = false;
  bool _procesando = false;
  bool _modoCliente = true;

  String _textoOriginal = '';
  String _textoTraducido = '';
  String _mensajeEstado = 'Selecciona quién va a hablar.';
  String? _error;

  @override
  void initState() {
    super.initState();
    _configurarVoz();
  }

  Future<void> _configurarVoz() async {
    await _voz.setSpeechRate(0.45);
    await _voz.setVolume(1.0);
    await _voz.setPitch(1.0);
  }

  Future<bool> _inicializarReconocimiento() async {
    if (_inicializado) return true;

    final disponible = await _reconocimiento.initialize(
      onStatus: (estado) {
        if (!mounted) return;

        setState(() {
          _escuchando = estado == 'listening';
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _escuchando = false;
          _error = 'No se pudo reconocer la voz: ${error.errorMsg}';
        });
      },
    );

    _inicializado = disponible;
    return disponible;
  }

  Future<void> _iniciarEscucha() async {
    if (_procesando) return;

    setState(() {
      _error = null;
      _textoOriginal = '';
      _textoTraducido = '';
      _mensajeEstado = 'Preparando el micrófono...';
    });

    final permiso = await Permission.microphone.request();

    if (!permiso.isGranted) {
      if (!mounted) return;

      setState(() {
        _error = 'Debes permitir el acceso al micrófono.';
        _mensajeEstado = 'No se puede iniciar la escucha.';
      });
      return;
    }

    try {
      final disponible = await _inicializarReconocimiento();

      if (!disponible) {
        if (!mounted) return;

        setState(() {
          _error = 'El reconocimiento de voz no está disponible.';
          _mensajeEstado = 'Comprueba el micrófono y el idioma del dispositivo.';
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        _mensajeEstado = _modoCliente
            ? 'Habla en inglés cuando el micrófono esté activo.'
            : 'Habla en español cuando el micrófono esté activo.';
      });

      await _reconocimiento.listen(
        localeId: _modoCliente ? 'en_US' : 'es_CO',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        onResult: (resultado) {
          if (!mounted) return;

          setState(() {
            _textoOriginal = resultado.recognizedWords;
          });

          if (resultado.finalResult &&
              resultado.recognizedWords.trim().isNotEmpty) {
            _procesarMensaje(resultado.recognizedWords);
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo iniciar el micrófono: $e';
        _mensajeEstado = 'Inténtalo de nuevo.';
      });
    }
  }

  Future<void> _detenerEscucha() async {
    await _reconocimiento.stop();

    if (!mounted) return;

    setState(() {
      _escuchando = false;
      _mensajeEstado = 'Escucha detenida.';
    });
  }

  Future<void> _procesarMensaje(String texto) async {
    if (_procesando) return;

    setState(() {
      _procesando = true;
      _escuchando = false;
      _mensajeEstado = 'Traduciendo mensaje...';
      _error = null;
    });

    try {
      final idiomaOrigen = _modoCliente ? 'en' : 'es';
      final idiomaDestino = _modoCliente ? 'es' : 'en';

      final respuesta = await ApiClient.post(
        ApiConfig.traducir,
        {
          'texto': texto.trim(),
          'idiomaOrigen': idiomaOrigen,
          'idiomaDestino': idiomaDestino,
        },
        auth: false,
      ).timeout(const Duration(seconds: 20));

      if (respuesta.statusCode != 200) {
        throw Exception('El servicio respondió con error ${respuesta.statusCode}.');
      }

      final datos = jsonDecode(respuesta.body);
      final traduccion = datos['textoTraducido'] as String?;

      if (traduccion == null || traduccion.trim().isEmpty) {
        throw Exception('El servicio no devolvió una traducción.');
      }

      if (!mounted) return;

      setState(() {
        _textoTraducido = traduccion.trim();
        _mensajeEstado = 'Traducción lista.';
      });

      await _reproducirTraduccion(traduccion.trim());
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo traducir el mensaje. Comprueba tu conexión e inténtalo otra vez.';
        _mensajeEstado = 'Traducción no disponible.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _procesando = false;
        });
      }
    }
  }

  Future<void> _reproducirTraduccion(String texto) async {
    await _voz.stop();

    // La traducción siempre se reproduce en el idioma de destino.
    await _voz.setLanguage(_modoCliente ? 'es-CO' : 'en-US');
    await _voz.speak(texto);
  }

  Future<void> _reproducirDeNuevo() async {
    if (_textoTraducido.isEmpty || _procesando) return;

    try {
      await _reproducirTraduccion(_textoTraducido);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo reproducir el audio.';
      });
    }
  }

  void _cambiarModo(bool modoCliente) {
    if (_escuchando || _procesando) return;

    setState(() {
      _modoCliente = modoCliente;
      _textoOriginal = '';
      _textoTraducido = '';
      _error = null;
      _mensajeEstado = modoCliente
          ? 'Cliente: inglés → Mesero: español'
          : 'Mesero: español → Cliente: inglés';
    });
  }

  @override
  void dispose() {
    _reconocimiento.stop();
    _voz.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text(
          'Intérprete de voz',
          style: TextStyle(
            color: AppColors.textoCafe,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cremaClaro,
        iconTheme: const IconThemeData(color: AppColors.textoCafe),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.record_voice_over_rounded,
              size: 64,
              color: AppColors.caramelo,
            ),
            const SizedBox(height: 12),
            const Text(
              'Comunícate con tus clientes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textoCafe,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escucha, traduce y reproduce la conversación en ambos idiomas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.cafeMedio),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _botonModo(
                    texto: 'Cliente habla inglés',
                    icono: Icons.headphones_rounded,
                    seleccionado: _modoCliente,
                    onTap: () => _cambiarModo(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _botonModo(
                    texto: 'Mesero habla español',
                    icono: Icons.record_voice_over_rounded,
                    seleccionado: !_modoCliente,
                    onTap: () => _cambiarModo(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tarjeta,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cremaOscuro),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _modoCliente
                        ? 'Cliente · Inglés'
                        : 'Mesero · Español',
                    style: const TextStyle(
                      color: AppColors.cafeMedio,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textoOriginal.isEmpty
                        ? 'Aquí aparecerá lo que diga la persona.'
                        : _textoOriginal,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textoCafe,
                    ),
                  ),
                  const Divider(height: 28),
                  Text(
                    _modoCliente
                        ? 'Mesero · Español'
                        : 'Cliente · Inglés',
                    style: const TextStyle(
                      color: AppColors.caramelo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textoTraducido.isEmpty
                        ? 'Aquí aparecerá la traducción.'
                        : _textoTraducido,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textoCafe,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            Text(
              _mensajeEstado,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.cafeMedio),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 58,
              child: ElevatedButton.icon(
                onPressed: _procesando
                    ? null
                    : (_escuchando ? _detenerEscucha : _iniciarEscucha),
                icon: Icon(
                  _escuchando ? Icons.stop_rounded : Icons.mic_rounded,
                ),
                label: Text(
                  _procesando
                      ? 'Traduciendo...'
                      : (_escuchando ? 'Detener escucha' : 'Hablar'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.caramelo,
                  foregroundColor: AppColors.blanco,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _textoTraducido.isEmpty || _procesando
                  ? null
                  : _reproducirDeNuevo,
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text('Reproducir traducción otra vez'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textoCafe,
                side: const BorderSide(color: AppColors.cremaOscuro),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Revisa lo que se reconoció antes de usar la información para atender al cliente. Esta función no registra pedidos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.cafeMedio,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonModo({
    required String texto,
    required IconData icono,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return Material(
      color: seleccionado ? AppColors.caramelo : AppColors.cremaClaro,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          child: Column(
            children: [
              Icon(
                icono,
                color: seleccionado ? AppColors.blanco : AppColors.cafeMedio,
              ),
              const SizedBox(height: 8),
              Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: seleccionado
                      ? AppColors.blanco
                      : AppColors.textoCafe,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
