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

    // El diálogo pide la confirmación, hace la solicitud al servidor y
    // muestra los errores (ej. contraseña incorrecta) bajo el campo.
    // Solo devuelve true cuando el servidor confirmó la eliminación.
    final eliminada = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DialogoEliminarCuenta(),
    );

    if (eliminada != true) return;

    // Cerrar Google después de confirmar la eliminación.
    try {
      await GoogleAuthService.cerrarSesion();
    } catch (e) {
      debugPrint('Error al cerrar Google después de eliminar: $e');
    }

    // Limpiar la sesión local y los favoritos en memoria.
    await auth.limpiarSesionTrasEliminarCuenta();
    favoritos.limpiar();

    // Ir al menú como invitado y borrar el historial de pantallas,
    // para que no se pueda regresar con el botón "atrás".
    navigator.pushNamedAndRemoveUntil('/menu', (route) => false);
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
// DIÁLOGO DE ELIMINACIÓN DE CUENTA
// Hace la solicitud al servidor y muestra los errores dentro
// del mismo diálogo. Se cierra con true solo si se eliminó.
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

  bool _cargando = false;
  bool _ocultarPassword = true;

  // Error pequeño que aparece debajo del campo de contraseña.
  String? _errorPassword;

  // Error general (por ejemplo, Google cancelado).
  String? _errorGeneral;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _limpiarError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  Future<void> _eliminarConPassword() async {
    if (_cargando) return;

    final password = _passwordController.text;

    if (password.trim().isEmpty) {
      setState(() {
        _errorPassword = 'Ingresa tu contraseña actual.';
        _errorGeneral = null;
      });
      return;
    }

    setState(() {
      _cargando = true;
      _errorPassword = null;
      _errorGeneral = null;
    });

    try {
      await PerfilService.eliminarCuenta(passwordActual: password);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _errorPassword = _limpiarError(e);
      });
    }
  }

  Future<void> _eliminarConGoogle() async {
    if (_cargando) return;

    setState(() {
      _cargando = true;
      _errorPassword = null;
      _errorGeneral = null;
    });

    try {
      final idToken = await GoogleAuthService.iniciarSesion();

      if (idToken == null) {
        if (!mounted) return;

        setState(() {
          _cargando = false;
          _errorGeneral = 'Autenticación de Google cancelada.';
        });
        return;
      }

      await PerfilService.eliminarCuenta(idToken: idToken);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _errorGeneral = _limpiarError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // No permitir cerrar con el botón "atrás" mientras se elimina.
    return PopScope(
      canPop: !_cargando,
      child: AlertDialog(
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
                obscureText: _ocultarPassword,
                enabled: !_cargando,
                onChanged: (_) {
                  if (_errorPassword != null) {
                    setState(() => _errorPassword = null);
                  }
                },
                onSubmitted: (_) => _eliminarConPassword(),
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  border: const OutlineInputBorder(),
                  errorText: _errorPassword,
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _ocultarPassword = !_ocultarPassword,
                    ),
                  ),
                ),
              ),
              if (_errorGeneral != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorGeneral!,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                _cargando ? null : () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: _cargando ? null : _eliminarConGoogle,
            child: const Text('Continuar con Google'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: _cargando ? null : _eliminarConPassword,
            child: _cargando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Eliminar cuenta'),
          ),
        ],
      ),
    );
  }
}