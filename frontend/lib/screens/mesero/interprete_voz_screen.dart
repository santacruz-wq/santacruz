
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';

class InterpreteVozScreen extends StatefulWidget {
  const InterpreteVozScreen({super.key});

  @override
  State<InterpreteVozScreen> createState() => _InterpreteVozScreenState();
}

class _InterpreteVozScreenState extends State<InterpreteVozScreen> {
  final AudioRecorder _grabadora = AudioRecorder();
  final FlutterTts _voz = FlutterTts();

  bool _escuchando = false;
  bool _procesando = false;

  String _idiomaOrigen = 'auto';
  String _idiomaDestino = 'es';

  String? _rutaAudio;
  String _textoOriginal = '';
  String _textoTraducido = '';
  String _mensajeEstado = 'Selecciona los idiomas y pulsa Hablar.';
  String? _error;

  static const Map<String, String> _idiomas = {
    'auto': 'Detectar automáticamente',
    'es': 'Español',
    'en': 'Inglés',
    'pt': 'Portugués',
    'fr': 'Francés',
    'de': 'Alemán',
    'it': 'Italiano',
    'zh': 'Chino simplificado',
    'hi': 'Hindi',
    'ar': 'Árabe',
    'ru': 'Ruso',
    'ja': 'Japonés',
    'ko': 'Coreano',
    'id': 'Indonesio',
    'bn': 'Bengalí',
    'tr': 'Turco',
  };

  static const Map<String, String> _localesVoz = {
    'es': 'es-CO',
    'en': 'en-US',
    'pt': 'pt-BR',
    'fr': 'fr-FR',
    'de': 'de-DE',
    'it': 'it-IT',
    'zh': 'zh-CN',
    'hi': 'hi-IN',
    'ar': 'ar-SA',
    'ru': 'ru-RU',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'id': 'id-ID',
    'bn': 'bn-IN',
    'tr': 'tr-TR',
  };

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

  String _nombreIdioma(String codigo) {
    return _idiomas[codigo] ?? codigo;
  }

  Future<void> _iniciarGrabacion() async {
    if (_procesando || _escuchando) return;

    setState(() {
      _error = null;
      _textoOriginal = '';
      _textoTraducido = '';
      _mensajeEstado = 'Preparando el micrófono...';
    });

    try {
      final permiso = await Permission.microphone.request();

      if (!permiso.isGranted) {
        throw Exception('Debes permitir el acceso al micrófono.');
      }

      final disponible = await _grabadora.hasPermission();

      if (!disponible) {
        throw Exception('No se pudo acceder al micrófono.');
      }

      final ruta =
          '${Directory.systemTemp.path}'
          '${Platform.pathSeparator}'
          'interprete_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _grabadora.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: ruta,
      );

      if (!mounted) return;

      setState(() {
        _rutaAudio = ruta;
        _escuchando = true;
        _mensajeEstado =
            'Grabando... habla y luego pulsa Detener y traducir.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo iniciar la grabación: $e';
        _mensajeEstado = 'Inténtalo de nuevo.';
      });
    }
  }

  Future<void> _detenerYTraducir() async {
    if (!_escuchando || _procesando) return;

    try {
      final rutaDetenida = await _grabadora.stop();

      if (!mounted) return;

      setState(() {
        _escuchando = false;
        _procesando = true;
        _mensajeEstado = 'Groq está reconociendo y traduciendo el audio...';
        _error = null;
      });

      final ruta = rutaDetenida ?? _rutaAudio;

      if (ruta == null || !await File(ruta).exists()) {
        throw Exception('No se encontró el archivo de audio.');
      }

      await _enviarAudio(ruta);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo procesar el audio: $e';
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

  Future<void> _enviarAudio(String ruta) async {
    try {
      final solicitud = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.interprete),
      );

      solicitud.fields['idiomaOrigen'] = _idiomaOrigen;
      solicitud.fields['idiomaDestino'] = _idiomaDestino;

      solicitud.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          ruta,
          filename: 'interprete.wav',
        ),
      );

      final respuesta = await solicitud.send().timeout(
        const Duration(seconds: 90),
      );

      final cuerpo = await respuesta.stream.bytesToString();

      dynamic datos;
      try {
        datos = jsonDecode(cuerpo);
      } catch (_) {
        throw Exception('El servidor devolvió una respuesta inválida.');
      }

      if (respuesta.statusCode != 200) {
        final mensaje =
            datos is Map ? datos['mensaje']?.toString() : null;

        throw Exception(
          mensaje ?? 'Error del servidor (${respuesta.statusCode}).',
        );
      }

      if (datos is! Map) {
        throw Exception('La respuesta del servidor no es válida.');
      }

      final original = datos['textoOriginal']?.toString().trim() ?? '';
      final traduccion =
          datos['textoTraducido']?.toString().trim() ?? '';

      if (original.isEmpty || traduccion.isEmpty) {
        throw Exception('No se recibió el texto reconocido o traducido.');
      }

      if (!mounted) return;

      setState(() {
        _textoOriginal = original;
        _textoTraducido = traduccion;
        _mensajeEstado = 'Traducción lista.';
      });

      await _reproducirTraduccion(traduccion);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _mensajeEstado = 'Traducción no disponible.';
      });
    } finally {
      try {
        await File(ruta).delete();
      } catch (_) {}
    }
  }

  Future<void> _reproducirTraduccion(String texto) async {
    await _voz.stop();

    final locale = _localesVoz[_idiomaDestino];

    if (locale == null) {
      throw Exception('No se configuró la voz para este idioma.');
    }

    await _voz.setLanguage(locale);
    await _voz.speak(texto);
  }

  Future<void> _reproducirDeNuevo() async {
    if (_textoTraducido.isEmpty || _procesando || _escuchando) return;

    try {
      await _reproducirTraduccion(_textoTraducido);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo reproducir la traducción: $e';
      });
    }
  }

  void _intercambiarIdiomas() {
    if (_escuchando || _procesando) return;

    setState(() {
      final anteriorOrigen = _idiomaOrigen;
      final anteriorDestino = _idiomaDestino;

      _idiomaOrigen = anteriorDestino;
      _idiomaDestino = anteriorOrigen == 'auto' ? 'es' : anteriorOrigen;

      _textoOriginal = '';
      _textoTraducido = '';
      _error = null;
      _mensajeEstado =
          '${_nombreIdioma(_idiomaOrigen)} → '
          '${_nombreIdioma(_idiomaDestino)}';
    });
  }

  @override
  void dispose() {
    _grabadora.dispose();
    _voz.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloqueado = _escuchando || _procesando;

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
              'Graba una frase, tradúcela con IA y escucha el resultado.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.cafeMedio),
            ),
            const SizedBox(height: 24),

            _selectorIdioma(
              titulo: 'Idioma de quien habla',
              valor: _idiomaOrigen,
              permitirAuto: true,
              onChanged: (valor) {
                if (valor == null) return;

                setState(() {
                  _idiomaOrigen = valor;
                  _error = null;
                });
              },
            ),

            const SizedBox(height: 8),

            Center(
              child: IconButton(
                onPressed: bloqueado ? null : _intercambiarIdiomas,
                tooltip: 'Intercambiar idiomas',
                icon: const Icon(Icons.swap_vert_rounded),
                color: AppColors.caramelo,
                iconSize: 30,
              ),
            ),

            _selectorIdioma(
              titulo: 'Traducir al idioma',
              valor: _idiomaDestino,
              permitirAuto: false,
              onChanged: (valor) {
                if (valor == null) return;

                setState(() {
                  _idiomaDestino = valor;
                  _error = null;
                });
              },
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
                    'Original · ${_nombreIdioma(_idiomaOrigen)}',
                    style: const TextStyle(
                      color: AppColors.cafeMedio,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textoOriginal.isEmpty
                        ? 'Aquí aparecerá lo que se reconozca del audio.'
                        : _textoOriginal,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textoCafe,
                    ),
                  ),
                  const Divider(height: 28),
                  Text(
                    'Traducción · ${_nombreIdioma(_idiomaDestino)}',
                    style: const TextStyle(
                      color: AppColors.caramelo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textoTraducido.isEmpty
                        ? 'Aquí aparecerá la traducción de Groq.'
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
                    : (_escuchando
                        ? _detenerYTraducir
                        : _iniciarGrabacion),
                icon: Icon(
                  _escuchando
                      ? Icons.stop_rounded
                      : _procesando
                          ? Icons.hourglass_top_rounded
                          : Icons.mic_rounded,
                ),
                label: Text(
                  _procesando
                      ? 'Traduciendo...'
                      : _escuchando
                          ? 'Detener y traducir'
                          : 'Hablar',
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
              onPressed: _textoTraducido.isEmpty || bloqueado
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
              'El audio se envía al servidor para su procesamiento. '
              'Esta función no registra pedidos.',
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

  Widget _selectorIdioma({
    required String titulo,
    required String valor,
    required ValueChanged<String?> onChanged,
    required bool permitirAuto,
  }) {
    final opciones = _idiomas.entries
        .where((entrada) => permitirAuto || entrada.key != 'auto')
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cremaOscuro),
      ),
      child: DropdownButtonFormField<String>(
        value: valor,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: titulo,
          border: InputBorder.none,
          labelStyle: const TextStyle(color: AppColors.cafeMedio),
        ),
        dropdownColor: AppColors.cremaClaro,
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontSize: 15,
        ),
        items: opciones.map((entrada) {
          return DropdownMenuItem<String>(
            value: entrada.key,
            child: Text(entrada.value),
          );
        }).toList(),
        onChanged: _escuchando || _procesando ? null : onChanged,
      ),
    );
  }
}
