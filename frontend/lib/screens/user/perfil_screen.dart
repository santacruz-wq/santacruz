
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../core/navigation/menu_navigation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/global/bottom_menu.dart';

class PerfilScreen extends StatelessWidget {
  final bool showBottomBar;

  const PerfilScreen({
    super.key,
    this.showBottomBar = true,
  });

  String? _urlAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;

    if (avatar.startsWith('http://') ||
        avatar.startsWith('https://')) {
      return avatar;
    }

    final base = ApiConfig.baseUrl.replaceFirst(
      RegExp(r'/api/?$'),
      '',
    );

    return '$base${avatar.startsWith('/') ? avatar : '/$avatar'}';
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cremaClaro,
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(color: AppColors.textoCafe),
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(color: AppColors.textoCafe),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await context.read<AuthProvider>().logout();
      context.read<FavoritoProvider>().limpiar();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/menu',
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo cerrar la sesión: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Widget _seccion({
    required String titulo,
    required IconData icono,
    required Widget contenido,
  }) {
    return Card(
      color: AppColors.cremaClaro,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: AppColors.caramelo, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoCafe,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            contenido,
          ],
        ),
      ),
    );
  }

  Widget _fila({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: AppColors.cafeMedio, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.cafeMedio,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton({
    required String texto,
    required IconData icono,
    required VoidCallback accion,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: accion,
        icon: Icon(icono),
        label: Text(texto),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.cafeMedio,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.cremaOscuro),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _vistaInvitado(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.cremaOscuro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.cafeMedio,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Inicia sesión para ver tu perfil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta tus datos personales y tus favoritos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.cafeMedio),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Iniciar sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.caramelo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
              onItemSelected: (i) {
                navegarDesdeMenu(context, i, 2);
              },
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritos = context.watch<FavoritoProvider>();
    final idioma = context.watch<LanguageProvider>();
    final usuario = auth.usuario;

    if (usuario == null) {
      return _vistaInvitado(context);
    }

    final avatarUrl = _urlAvatar(usuario.avatar);

    final esPersonal = [
      'admin',
      'mesero',
      'cocina',
    ].contains(usuario.rol);

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            // Cabecera inspirada en el perfil administrativo.
            Card(
              color: AppColors.cremaClaro,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 53,
                      backgroundColor: AppColors.cremaOscuro,
                      backgroundImage: avatarUrl == null
                          ? null
                          : NetworkImage(avatarUrl),
                      child: avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 58,
                              color: AppColors.cafeMedio,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      usuario.nombre,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoCafe,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      usuario.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.cafeMedio,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.carameloClaro.withValues(
                          alpha: 0.35,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        usuario.rol.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textoCafe,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Información personal de solo lectura.
            _seccion(
              titulo: 'Información personal',
              icono: Icons.person_outline,
              contenido: Column(
                children: [
                  _fila(
                    icono: Icons.badge_outlined,
                    titulo: 'Nombre completo',
                    valor: usuario.nombre,
                  ),
                  const Divider(color: AppColors.cremaOscuro),
                  _fila(
                    icono: Icons.email_outlined,
                    titulo: 'Correo electrónico',
                    valor: usuario.email,
                  ),
                ],
              ),
            ),

            // Preferencias del usuario.
            _seccion(
              titulo: 'Preferencias',
              icono: Icons.tune,
              contenido: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.favorite_border,
                      color: AppColors.caramelo,
                    ),
                    title: const Text(
                      'Mis favoritos',
                      style: TextStyle(color: AppColors.textoCafe),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${favoritos.total}',
                          style: const TextStyle(
                            color: AppColors.caramelo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.cafeMedio,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/favoritos');
                    },
                  ),
                  const Divider(color: AppColors.cremaOscuro),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.language,
                      color: AppColors.caramelo,
                    ),
                    title: const Text(
                      'Idioma',
                      style: TextStyle(color: AppColors.textoCafe),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          idioma.idiomaNombre,
                          style: const TextStyle(
                            color: AppColors.caramelo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.cafeMedio,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/language-selection',
                      );
                    },
                  ),
                  if (esPersonal) ...[
                    const Divider(color: AppColors.cremaOscuro),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.badge_outlined,
                        color: AppColors.caramelo,
                      ),
                      title: const Text(
                        'Rol',
                        style: TextStyle(color: AppColors.textoCafe),
                      ),
                      trailing: Text(
                        usuario.rol,
                        style: const TextStyle(
                          color: AppColors.caramelo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Cambio de contraseña mediante el flujo de recuperación.
            _seccion(
              titulo: 'Seguridad',
              icono: Icons.lock_outline,
              contenido: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Puedes cambiar tu contraseña verificando tu correo electrónico.',
                    style: TextStyle(
                      color: AppColors.cafeMedio,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/recuperar',
                          arguments: usuario.email,
                        );
                      },
                      icon: const Icon(Icons.lock_reset_outlined),
                      label: const Text('Cambiar contraseña'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.caramelo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _boton(
              texto: 'Cerrar sesión',
              icono: Icons.logout,
              accion: () => _cerrarSesion(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomBar
          ? BottomMenu(
              currentIndex: 2,
              onItemSelected: (i) {
                navegarDesdeMenu(context, i, 2);
              },
            )
          : null,
    );
  }
}
