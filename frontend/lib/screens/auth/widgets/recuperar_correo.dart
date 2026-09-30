import 'package:flutter/material.dart';
import 'auth_button.dart';
import 'auth_text_field.dart';

class RecuperarCorreo extends StatelessWidget {
  final TextEditingController controller;
  final bool cargando;
  final VoidCallback onEnviar;

  const RecuperarCorreo({
    super.key,
    required this.controller,
    required this.cargando,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: controller,
          hintText: 'Correo electrónico',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (_) => null,
        ),

        const SizedBox(height: 25),

        AuthButton(
          texto: 'Enviar código',
          cargando: cargando,
          onPressed: onEnviar,
        ),
      ],
    );
  }
}

