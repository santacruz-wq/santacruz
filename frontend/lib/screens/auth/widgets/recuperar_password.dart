import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import 'auth_button.dart';
import 'auth_text_field.dart';

class RecuperarPassword extends StatelessWidget {
  final TextEditingController codigo;
  final TextEditingController nuevaContrasena;
  final TextEditingController confirmarContrasena;

  final bool ocultarContrasena;
  final bool ocultarConfirmacion;
  final bool cargando;

  final VoidCallback cambiarContrasena;
  final VoidCallback cambiarConfirmacion;
  final VoidCallback onCambiar;
  final VoidCallback onReenviar;

  const RecuperarPassword({
    super.key,
    required this.codigo,
    required this.nuevaContrasena,
    required this.confirmarContrasena,
    required this.ocultarContrasena,
    required this.ocultarConfirmacion,
    required this.cargando,
    required this.cambiarContrasena,
    required this.cambiarConfirmacion,
    required this.onCambiar,
    required this.onReenviar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: codigo,
          hintText: 'Código de 6 dígitos',
          icon: Icons.verified_outlined,
          keyboardType: TextInputType.number,
          validator: (_) => null,
        ),

        const SizedBox(height: 18),

        AuthTextField(
          controller: nuevaContrasena,
          hintText: 'Nueva contraseña',
          icon: Icons.lock_outline,
          obscureText: ocultarContrasena,
          suffixIcon: IconButton(
            onPressed: cambiarContrasena,
            icon: Icon(
              ocultarContrasena
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.cafeMedio,
            ),
          ),
          validator: (_) => null,
        ),

        const SizedBox(height: 18),

        AuthTextField(
          controller: confirmarContrasena,
          hintText: 'Confirmar contraseña',
          icon: Icons.lock_outline,
          obscureText: ocultarConfirmacion,
          suffixIcon: IconButton(
            onPressed: cambiarConfirmacion,
            icon: Icon(
              ocultarConfirmacion
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.cafeMedio,
            ),
          ),
          validator: (_) => null,
        ),

        const SizedBox(height: 25),

        AuthButton(
          texto: 'Cambiar contraseña',
          cargando: cargando,
          onPressed: onCambiar,
        ),

        const SizedBox(height: 10),

        TextButton(
          onPressed: cargando ? null : onReenviar,
          child: const Text(
            'Reenviar código',
            style: TextStyle(
              color: AppColors.caramelo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}