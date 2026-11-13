
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ManualUsuario extends StatefulWidget {
  const ManualUsuario({super.key});

  @override
  State<ManualUsuario> createState() => _ManualUsuarioState();
}

class _ManualUsuarioState extends State<ManualUsuario> {
  late final WebViewController _controller;

  bool _cargando = true;
  bool _error = false;

  static const String _url =
      'https://rainbow-horse-dcbbc5.netlify.app/';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _cargando = true;
                _error = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                _cargando = false;
              });
            }
          },
          onWebResourceError: (error) {
            if (mounted && error.isForMainFrame == true) {
              setState(() {
                _cargando = false;
                _error = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _recargar() {
    setState(() {
      _error = false;
      _cargando = true;
    });

    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E6),
      appBar: AppBar(
        title: const Text(
          'Manual de usuario',
          style: TextStyle(
            color: Color(0xFF3D2314),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFAF0E6),
        foregroundColor: const Color(0xFF3D2314),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (!_error)
            WebViewWidget(controller: _controller),

          if (_cargando && !_error)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC87D32),
              ),
            ),

          if (_error)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 55,
                      color: Color(0xFF6F4E37),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudo cargar el manual.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2314),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Verifica tu conexión a Internet e inténtalo nuevamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6F4E37),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Volver a intentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC87D32),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
