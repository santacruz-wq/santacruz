import 'package:flutter/material.dart';

class AuthValidators {
  static String? requerido(
    String? value,
    BuildContext context,
    String mensaje,
  ) {
    if (value == null || value.trim().isEmpty) {
      return mensaje;
    }

    return null;
  }

  static String? correo(
    String? value,
    BuildContext context,
    String requerido,
    String invalido,
  ) {
    if (value == null || value.trim().isEmpty) {
      return requerido;
    }

    if (!value.contains('@')) {
      return invalido;
    }

    return null;
  }

  static String? contrasena(
    String? value,
    String requerido,
    String corta,
  ) {
    if (value == null || value.isEmpty) {
      return requerido;
    }

    if (value.length < 6) {
      return corta;
    }

    return null;
  }

  static String? confirmarContrasena(
    String? value,
    String contrasena,
    String requerido,
    String noCoinciden,
  ) {
    if (value == null || value.isEmpty) {
      return requerido;
    }

    if (value != contrasena) {
      return noCoinciden;
    }

    return null;
  }
}