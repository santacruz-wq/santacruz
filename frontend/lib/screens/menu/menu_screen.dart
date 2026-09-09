import 'package:flutter/material.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../widgets/global/language_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _indiceActual = 0;

  void _cambiarPagina(int index) {
    setState(() {
      _indiceActual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido de cada sección
          _contenido(),

          // Botón para cambiar idioma
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  top: 8,
                ),
                child: LanguageButton(),
              ),
            ),
          ),
        ],
      ),

      // Menú inferior
      bottomNavigationBar: BottomMenu(
        currentIndex: _indiceActual,
        onItemSelected: _cambiarPagina,
      ),
    );
  }

  Widget _contenido() {
    switch (_indiceActual) {
      case 0:
        return const Center(
          child: Text('Inicio'),
        );

      case 1:
        return const Center(
          child: Text('Favoritos'),
        );

      case 2:
        return const Center(
          child: Text('Historial'),
        );

      case 3:
        return const Center(
          child: Text('Perfil'),
        );

      default:
        return const Center(
          child: Text('Inicio'),
        );
    }
  }
}