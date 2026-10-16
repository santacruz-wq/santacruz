import 'package:flutter/material.dart';

class AuthNavigation {
  static void irSegunRol(
    BuildContext context,
    String? rol,
  ) {
    switch (rol) {
      case 'admin':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/admin',
          (route) => false,
        );
        break;

      case 'mesero':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/mesero',
          (route) => false,
        );
        break;

      case 'cocina':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/cocina',
          (route) => false,
        );
        break;

      default:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/menu',
          (route) => false,
        );
        break;
    }
  }
}