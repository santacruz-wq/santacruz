import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import 'controllers/verificar_cuenta_controller.dart';
import 'widgets/auth_button.dart';

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

class _VerificarCuentaScreenState
    extends State<VerificarCuentaScreen> {
  final controller = VerificarCuentaController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _verificar() async {
    setState(() {});

    await controller.verificarCuenta(
      context,
      widget.email,
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _reenviar() async {
    setState(() {});

    await controller.reenviarCodigo(
      context,
      widget.email,
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,

      appBar: AppBar(
        backgroundColor: AppColors.crema,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.textoCafe,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
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
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.cafeMedio,
                ),
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
                controller: controller.codigo,
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
                    borderRadius:
                        BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: AppColors.caramelo,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              AuthButton(
                texto: controller.cargando
                    ? 'Verificando...'
                    : 'Verificar cuenta',
                cargando: controller.cargando,
                onPressed: _verificar,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: controller.reenviando
                    ? null
                    : _reenviar,
                child: Text(
                  controller.reenviando
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
                style: TextStyle(
                  color: AppColors.cafeMedio,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}