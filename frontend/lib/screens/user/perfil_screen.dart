import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../core/config/translation_perfil.dart';
import '../../core/navigation/menu_navigation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';
import '../../providers/language_provider.dart';
import '../../services/perfil_service.dart';
import '../../services/google_auth_service.dart';
import '../../widgets/global/bottom_menu.dart';
import 'widgets/perfil_cabecera.dart';
import 'widgets/perfil_cerrar_sesion.dart';
import 'widgets/perfil_informacion.dart';
import 'widgets/perfil_preferencias.dart';
import 'widgets/perfil_seguridad.dart';
import 'widgets/perfil_vista_invitado.dart';
import 'widgets/perfil_seccion.dart';
import 'ayuda_soporte/ayuda_soporte.dart';

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

  String _t(String clave, String idioma) {
    return TranslationPerfil.obtenerTexto(
      clave: clave,
      idioma: idioma,
    );
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

  // =========================================================
  // SELECCIONAR FOTO DE PERFIL
  // =========================================================

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

  // =========================================================
  // GUARDAR NOMBRE
  // =========================================================

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
      if (mounted) {
        _mostrarMensaje(_limpiarError(e), esError: true);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  // =========================================================
  // ELIMINAR CUENTA
  // =========================================================

  Future<void> _eliminarCuenta() async {
    if (_guardando) return;

    // Obtener proveedores y navegador ANTES de los await,
    // porque después de eliminar esta pantalla pasa a la vista de invitado.
    final auth = context.read<AuthProvider>();
    final favoritos = context.read<FavoritoProvider>();
    final navigator = Navigator.of(context, rootNavigator: true);

    // El diálogo administra su propio controlador.
    final confirmacion = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _DialogoEliminarCuenta(),
    );

    if (confirmacion == null || !mounted) return;

    setState(() => _guardando = true);

    bool cuentaEliminada = false;

    try {
      final metodo = confirmacion['metodo'];
      final password = confirmacion['password'];

      // Verificar identidad y solicitar la eliminación al servidor.
      if (metodo == 'google') {
        final idToken = await GoogleAuthService.iniciarSesion();

        if (idToken == null) {
          if (mounted) {
            _mostrarMensaje('Autenticación de Google cancelada.');
          }
          return;
        }

        await PerfilService.eliminarCuenta(idToken: idToken);
      } else if (metodo == 'password') {
        await PerfilService.eliminarCuenta(
          passwordActual: password,
        );
      } else {
        return;
      }

      // Solo llegamos aquí si el servidor confirmó la eliminación.
      cuentaEliminada = true;

      // Cerrar Google después de confirmar la eliminación.
      try {
        await GoogleAuthService.cerrarSesion();
      } catch (e) {
        debugPrint('Error al cerrar Google después de eliminar: $e');
      }

      // Limpiar la sesión local y los favoritos en memoria.
      await auth.limpiarSesionTrasEliminarCuenta();
      favoritos.limpiar();

      // Volver al inicio y borrar el historial de pantallas,
      // para que no se pueda regresar con el botón "atrás".
      navigator.pushNamedAndRemoveUntil('/inicio', (route) => false);
    } catch (e) {
      // Si la contraseña es incorrecta, se conserva la sesión.
      if (mounted) {
        _mostrarMensaje(
          _limpiarError(e),
          esError: true,
        );
      }
    } finally {
      if (mounted && !cuentaEliminada) {
        setState(() => _guardando = false);
      }
    }
  }

  // =========================================================
  // INTERFAZ
  // =========================================================

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
        title: Text(
          _t('mi_perfil', idioma.idiomaCodigo),
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            if (!esPersonal)
              PerfilPreferencias(
                totalFavoritos: favoritos.total,
                idioma: idioma.idiomaNombre,
                rol: usuario.rol,
                esPersonal: esPersonal,
              ),
            PerfilSeguridad(email: usuario.email),
            const AyudaSoporte(),
            PerfilBoton(
              texto: 'Eliminar mi cuenta',
              icono: Icons.delete_forever_outlined,
              accion: _eliminarCuenta,
              deshabilitado: _guardando,
            ),
            PerfilBoton(
              texto: _t('cerrar_sesion', idioma.idiomaCodigo),
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

// =========================================================
// DIÁLOGO DE CONFIRMACIÓN DE ELIMINACIÓN
// =========================================================

class _DialogoEliminarCuenta extends StatefulWidget {
  const _DialogoEliminarCuenta();

  @override
  State<_DialogoEliminarCuenta> createState() =>
      _DialogoEliminarCuentaState();
}

class _DialogoEliminarCuentaState
    extends State<_DialogoEliminarCuenta> {
  final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _continuarConPassword() {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu contraseña actual.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop({
      'metodo': 'password',
      'password': _passwordController.text,
    });
  }

  void _continuarConGoogle() {
    Navigator.of(context).pop({
      'metodo': 'google',
      'password': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar mi cuenta'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? '
              'Esta acción es permanente.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Tus datos personales y favoritos serán eliminados. '
              'El historial de pedidos y las reseñas se conservarán '
              'de forma anonimizada.',
            ),
            const SizedBox(height: 18),
            const Text(
              'Confirma tu identidad: si creaste tu cuenta con '
              'correo y contraseña, escribe tu contraseña actual. '
              'Si entras con Google, usa "Continuar con Google".',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _continuarConGoogle,
          child: const Text('Continuar con Google'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _continuarConPassword,
          child: const Text('Eliminar cuenta'),
        ),
      ],
    );
  }
}