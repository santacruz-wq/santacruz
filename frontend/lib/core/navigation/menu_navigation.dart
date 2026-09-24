import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

//NAVEGACION DE LA BARRA INFERIOR: 0 INICIO, 1 FAVORITOS, 2 PERFIL
void navegarDesdeMenu(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;

  final haySesion = context.read<AuthProvider>().usuario != null;

  switch (index) {
    case 0:
      Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
      break;

    case 1:
      if (!haySesion) {
        _pedirLogin(context, 'Inicia sesión para ver tus favoritos');
        return;
      }
      Navigator.pushNamed(context, '/favoritos');
      break;

    case 2:
      //EL PERFIL SOLO SE MUESTRA CON SESION; TODAVIA NO EXISTE LA PANTALLA
      if (!haySesion) {
        _pedirLogin(context, 'Inicia sesión para continuar');
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Próximamente')),
      );
      break;
  }
}

void _pedirLogin(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensaje)),
  );
  Navigator.pushNamed(context, '/login');
}