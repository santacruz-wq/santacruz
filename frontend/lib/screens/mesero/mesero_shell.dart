import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/global/bottom_menu.dart';
import 'mesas_screen.dart';
import '../user/perfil_screen.dart';

import '../../providers/auth_provider.dart';
import '../../services/socket_service.dart';

class MeseroShell extends StatefulWidget {
  const MeseroShell({super.key});

  @override
  State<MeseroShell> createState() => _MeseroShellState();
}

class _MeseroShellState extends State<MeseroShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MesasScreen(),
    Center(
      child: Text(
        'Pedidos',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final usuario = auth.usuario;

      if (usuario != null && usuario.id != null) {
        SocketService.conectar(usuario.id!);

        SocketService.escucharPedidoListo(
          (data) {
            _mostrarPedidoListo(data);
          },
        );
      }
    });
  }

  void _mostrarPedidoListo(dynamic data) {
    if (!mounted) return;

    String mesa = '';

    if (data is Map) {
      mesa = data['mesa']?.toString() ?? '';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mesa.isNotEmpty
              ? '🔔 Pedido listo - $mesa'
              : '🔔 Pedido listo para servir',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    SocketService.desconectar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomMenu(
          currentIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}