import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../core/config/app_colors.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../core/navigation/menu_navigation.dart';

class PerfilScreen extends StatelessWidget {
  final bool showBottomBar;
  const PerfilScreen({super.key, this.showBottomBar = true});

  Future<void> _cerrarSesion(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final favoritoProvider = context.read<FavoritoProvider>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await authProvider.logout();
    favoritoProvider.limpiar();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final usuario = authProvider.usuario;

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Perfil")),
        body: const Center(child: Text("No has iniciado sesión")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cremaClaro,
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.caramelo.withOpacity(0.15),
                backgroundImage: (usuario.avatar != null && usuario.avatar!.isNotEmpty)
                    ? NetworkImage(usuario.avatar!)
                    : null,
                child: (usuario.avatar == null || usuario.avatar!.isEmpty)
                    ? Icon(Icons.person, size: 55, color: AppColors.cafeMedio)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                usuario.nombre,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                usuario.email,
                style: TextStyle(fontSize: 15, color: AppColors.cafeMedio),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.tarjeta,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.badge_outlined, color: AppColors.cafeMedio),
                      title: Text("Rol", style: TextStyle(color: AppColors.textoCafe)),
                      trailing: Text(
                        usuario.rol,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.caramelo,
                        ),
                      ),
                    ),
                    Divider(height: 1, color: AppColors.cremaOscuro),
                    ListTile(
                      leading: Icon(Icons.email_outlined, color: AppColors.cafeMedio),
                      title: Text("Correo", style: TextStyle(color: AppColors.textoCafe)),
                      trailing: Text(
                        usuario.email,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textoCafe,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _cerrarSesion(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomBar
          ? BottomMenu(
              currentIndex: 2,
              onItemSelected: (i) => navegarDesdeMenu(context, i, 2),
            )
          : null,
    );
  }
}