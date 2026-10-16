import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import 'categorias/admin_categorias_screen.dart';
import 'dashboard/admin_dashboard_screen.dart';
import 'inventario/admin_inventario_screen.dart';
import 'pedidos/admin_pedidos_screen.dart';
import 'productos/admin_productos_screen.dart';
import 'resena/admin_resenas_screen.dart';
import 'usuarios/admin_usuarios_screen.dart';
import 'usuarios/admin_administradores_screen.dart';
import 'admin_perfil_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  // 0 Inicio, 1 Stock, 2 Pedidos, 3 Usuarios,
  // 4 Administradores, 5 Perfil, 6 Reseñas.
  int _indiceActual = 0;
  bool _menuAbierto = false;

  void _cambiarPagina(int indice) {
    if (indice < 0 || indice > 6) return;

    setState(() {
      _indiceActual = indice;
      _menuAbierto = false;
    });
  }

  Future<void> _abrirProductos() async {
    setState(() => _menuAbierto = false);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminProductosScreen(),
      ),
    );
  }

  Future<void> _abrirCategorias() async {
    setState(() => _menuAbierto = false);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminCategoriasScreen(),
      ),
    );
  }

  void _abrirPedidos() {
    _cambiarPagina(2);
  }

  void _abrirResenas() {
    _cambiarPagina(6);
  }

  int get _indiceBarraInferior {
    switch (_indiceActual) {
      case 1:
        return 1;
      case 3:
        return 2;
      case 4:
        return 3;
      case 5:
        return 4;
      default:
        return 0;
    }
  }

  Widget _opcionBurbuja({
    required String texto,
    required IconData icono,
    required VoidCallback accion,
    required String heroTag,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: accion,
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
        icon: Icon(icono),
        label: Text(texto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = <Widget>[
      AdminDashboardScreen(onNavigate: _cambiarPagina),
      const AdminInventarioScreen(),
      const AdminPedidosScreen(),
      const AdminUsuariosScreen(),
      const AdminAdministradoresScreen(),
      const AdminPerfilScreen(),
      const AdminResenasScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.crema,

      body: IndexedStack(
        index: _indiceActual,
        children: paginas,
      ),

      // La burbuja solo se muestra en Inicio.
      floatingActionButton: _indiceActual == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_menuAbierto) ...[
                  _opcionBurbuja(
                    texto: 'Reseñas',
                    icono: Icons.rate_review_outlined,
                    accion: _abrirResenas,
                    heroTag: 'admin_burbuja_resenas',
                  ),
                  _opcionBurbuja(
                    texto: 'Pedidos',
                    icono: Icons.shopping_bag_outlined,
                    accion: _abrirPedidos,
                    heroTag: 'admin_burbuja_pedidos',
                  ),
                  _opcionBurbuja(
                    texto: 'Categorías',
                    icono: Icons.category_outlined,
                    accion: _abrirCategorias,
                    heroTag: 'admin_burbuja_categorias',
                  ),
                  _opcionBurbuja(
                    texto: 'Productos',
                    icono: Icons.restaurant_menu,
                    accion: _abrirProductos,
                    heroTag: 'admin_burbuja_productos',
                  ),
                ],
                FloatingActionButton(
                  heroTag: 'admin_burbuja_principal',
                  backgroundColor: AppColors.caramelo,
                  foregroundColor: Colors.white,
                  tooltip: _menuAbierto
                      ? 'Cerrar menú de gestión'
                      : 'Abrir menú de gestión',
                  onPressed: () {
                    setState(() {
                      _menuAbierto = !_menuAbierto;
                    });
                  },
                  child: AnimatedRotation(
                    turns: _menuAbierto ? 0.125 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _menuAbierto
                          ? Icons.close
                          : Icons.widgets_outlined,
                      size: 28,
                    ),
                  ),
                ),
              ],
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceBarraInferior,
        onDestinationSelected: (indice) {
          const destinos = [0, 1, 3, 4, 5];
          _cambiarPagina(destinos[indice]);
        },
        backgroundColor: AppColors.cremaClaro,
        indicatorColor: AppColors.carameloClaro,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Administradores',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
