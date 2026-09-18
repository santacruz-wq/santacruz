import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/global/primary_button.dart';

class VerificarCuentaScreen extends StatefulWidget {
  final String email;

  const VerificarCuentaScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerificarCuentaScreen> createState() =>
      _VerificarCuentaScreenState();
}

class _VerificarCuentaScreenState extends State<VerificarCuentaScreen> {
  final _codigoController = TextEditingController();

  bool _cargando = false;
  bool _reenviando = false;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _verificarCodigo() async {
    if (_cargando) return;

    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty) {
      _mostrarMensaje('Ingresa el código de verificación.');
      return;
    }

    if (codigo.length != 6) {
      _mostrarMensaje('El código debe tener 6 dígitos.');
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final resultado = await AuthService.verificarCuenta(
        widget.email,
        codigo,
      );

      if (!mounted) return;

      if (resultado['success'] == true) {
        _mostrarMensaje(
          resultado['message'] ?? 'Cuenta verificada correctamente.',
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      } else {
        _mostrarMensaje(
          resultado['message'] ?? 'El código no es válido.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo verificar la cuenta. Intenta nuevamente.');
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() {
      _reenviando = true;
    });

    try {
      final resultado = await AuthService.reenviarCodigo(widget.email);

      if (!mounted) return;

      _mostrarMensaje(
        resultado['message'] ?? 'Se ha enviado un nuevo código.',
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo reenviar el código.');
    } finally {
      if (mounted) {
        setState(() {
          _reenviando = false;
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        backgroundColor: AppColors.crema,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textoCafe),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 80,
                color: AppColors.caramelo,
              ),
              const SizedBox(height: 25),
              const Text(
                'Verifica tu cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Hemos enviado un código de 6 dígitos a:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.cafeMedio),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _codigoController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '000000',
                  filled: true,
                  fillColor: AppColors.blanco,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColors.caramelo,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              PrimaryButton(
                text: _cargando ? 'Verificando...' : 'Verificar cuenta',
                onPressed: _cargando ? () {} : _verificarCodigo,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _reenviando ? null : _reenviarCodigo,
                child: Text(
                  _reenviando
                      ? 'Enviando código...'
                      : '¿No recibiste el código? Reenviar',
                  style: const TextStyle(
                    color: AppColors.caramelo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'El código tiene una duración limitada.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.cafeMedio, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}