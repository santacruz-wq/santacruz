
import 'package:flutter/material.dart';

class AuthNavigation {
  static void irSegunRol(
    BuildContext context,
    String? rol,
  ) {
    switch (rol) {
      case 'admin':
        Navigator.pushReplacementNamed(
          context,
          '/admin',
        );
        break;

      case 'mesero':
        Navigator.pushReplacementNamed(
          context,
          '/mesero',
        );
        break;

      case 'cocina':
        Navigator.pushReplacementNamed(
          context,
          '/cocina',
        );
        break;

      default:
        Navigator.pushReplacementNamed(
          context,
          '/menu',
        );
    }
  }
}
