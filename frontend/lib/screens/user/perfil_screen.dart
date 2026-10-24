import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../core/navigation/menu_navigation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../providers/language_provider.dart';
import '../../services/perfil_service.dart';
import '../../widgets/global/bottom_menu.dart';
import 'widgets/perfil_cabecera.dart';
import 'widgets/perfil_cerrar_sesion.dart';
import 'widgets/perfil_informacion.dart';
import 'widgets/perfil_preferencias.dart';
import 'widgets/perfil_seccion.dart';
import 'widgets/perfil_seguridad.dart';
import 'widgets/perfil_vista_invitado.dart';

class PerfilScreen extends StatefulWidget {
  final bool showBottomBar;

  const PerfilScreen({super.key, this.showBottomBar = true});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController _nombreController = TextEditingController();
  File? _imagenSeleccionada;
  bool _guardando = false;
  bool _editandoNombre = false;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  String? _urlAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return avatar;
    }
    final base = ApiConfig.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return '$base${avatar.startsWith('/') ? avatar : '/$avatar'}';
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red.shade700 : null,
      ),
    );
  }

  String _limpiarError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  Future<void> _seleccionarFoto() async {
    if (_guardando) return;

    try {
      final origen = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Seleccionar foto de perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Tomar foto'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir de galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (origen == null || !mounted) return;

      final imagen = await ImagePicker().pickImage(
        source: origen,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (imagen == null || !mounted) return;

      setState(() {
        _imagenSeleccionada = File(imagen.path);
        _guardando = true;
      });

      final data = await PerfilService.actualizarAvatar(
        _imagenSeleccionada!,
      );

      final usuarioActualizado = data['usuario'];

      if (usuarioActualizado is Map<String, dynamic> && mounted) {
        context.read<AuthProvider>().actualizarUsuarioDesdePerfil(
              usuarioActualizado,
            );
        setState(() => _imagenSeleccionada = null);
      }

      if (mounted) {
        _mostrarMensaje(
          data['message']?.toString() ?? 'Foto de perfil actualizada.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _imagenSeleccionada = null);
      _mostrarMensaje(_limpiarError(e), esError: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _guardarNombre() async {
    final auth = context.read<AuthProvider>();
    final usuario = auth.usuario;
    final nombre = _nombreController.text.trim();

    if (usuario == null) return;

    if (nombre.isEmpty) {
      _mostrarMensaje('Ingresa tu nombre.', esError: true);
      return;
    }

    if (nombre.length > 100) {
      _mostrarMensaje(
        'El nombre no puede superar 100 caracteres.',
        esError: true,
      );
      return;
    }

    if (_guardando) return;
    setState(() => _guardando = true);

    try {
      final data = await PerfilService.actualizarPerfil(
        nombre: nombre,
        email: usuario.email,
      );

      final usuarioActualizado = data['usuario'];

      if (usuarioActualizado is Map<String, dynamic> && mounted) {
        auth.actualizarUsuarioDesdePerfil(usuarioActualizado);
        setState(() {
          _editandoNombre = false;
          _nombreController.clear();
        });
      }

      if (mounted) {
        _mostrarMensaje(
          data['message']?.toString() ?? 'Nombre actualizado correctamente.',
        );
      }
    } catch (e) {
      if (mounted) _mostrarMensaje(_limpiarError(e), esError: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritos = context.watch<FavoritoProvider>();
    final idioma = context.watch<LanguageProvider>();
    final usuario = auth.usuario;

    if (usuario == null) {
      return PerfilVistaInvitado(showBottomBar: widget.showBottomBar);
    }

    final esPersonal = ['admin', 'mesero', 'cocina'].contains(usuario.rol);

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
            PerfilCabecera(
              usuario: usuario,
              avatarUrl: _urlAvatar(usuario.avatar),
              imagenSeleccionada: _imagenSeleccionada,
              nombreController: _nombreController,
              guardando: _guardando,
              editandoNombre: _editandoNombre,
              onSeleccionarFoto: _seleccionarFoto,
              onGuardarNombre: _guardarNombre,
              onAlternarEdicion: () => setState(() {
                _editandoNombre = !_editandoNombre;
                _nombreController.text = usuario.nombre;
              }),
            ),
            PerfilInformacion(
              nombre: usuario.nombre,
              email: usuario.email,
            ),
            PerfilPreferencias(
              totalFavoritos: favoritos.total,
              idioma: idioma.idiomaNombre,
              rol: usuario.rol,
              esPersonal: esPersonal,
            ),
            PerfilSeguridad(email: usuario.email),
            PerfilBoton(
              texto: 'Cerrar sesión',
              icono: Icons.logout,
              accion: () => cerrarSesionPerfil(context),
              deshabilitado: _guardando,
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomMenu(
              currentIndex: 2,
              onItemSelected: (i) => navegarDesdeMenu(context, i, 2),
            )
          : null,
    );
  }
}