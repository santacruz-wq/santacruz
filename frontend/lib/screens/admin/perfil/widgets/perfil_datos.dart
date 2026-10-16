part of '../../admin_perfil_screen.dart';

mixin _PerfilDatos on State<AdminPerfilScreen>, _PerfilEstado, _PerfilUtils {
  Future<void> _cargarPerfil() async {
    if (mounted) {
      setState(() => _cargando = true);
    }

    try {
      final data = await PerfilService.obtenerPerfil();
      final usuario = data['usuario'];

      if (usuario is! Map<String, dynamic>) {
        throw Exception('El servidor no devolvió los datos del perfil.');
      }

      if (!mounted) return;

      setState(() {
        _usuario = usuario;
        _nombreController.text = usuario['nombre']?.toString() ?? '';
        _emailController.text = usuario['email']?.toString() ?? '';
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _cargando = false);
      _mostrarMensaje(_limpiarError(e), esError: true);
    }
  }

  Future<void> _guardarPerfil() async {
    if (_nombreController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      _mostrarMensaje('Ingresa tu nombre y correo electrónico.',
          esError: true);
      return;
    }

    setState(() => _guardando = true);

    try {
      final data = await PerfilService.actualizarPerfil(
        nombre: _nombreController.text,
        email: _emailController.text,
      );

      final usuario = data['usuario'];

      if (usuario is Map<String, dynamic> && mounted) {
        setState(() {
          _usuario = usuario;
          _nombreController.text = usuario['nombre']?.toString() ?? '';
          _emailController.text = usuario['email']?.toString() ?? '';
          _mostrarFormularioEdicion = false;
        });
      }

      if (mounted) {
        _mostrarMensaje(data['message']?.toString() ??
            'Perfil actualizado correctamente.');
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensaje(_limpiarError(e), esError: true);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }
}