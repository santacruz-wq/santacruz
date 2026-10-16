part of '../../admin_perfil_screen.dart';

mixin _PerfilPassword on State<AdminPerfilScreen>, _PerfilEstado, _PerfilUtils {
  Future<void> _guardarPassword() async {
    if (_passwordActualController.text.isEmpty ||
        _nuevaPasswordController.text.isEmpty ||
        _confirmarPasswordController.text.isEmpty) {
      _mostrarMensaje('Completa todos los campos de contraseña.',
          esError: true);
      return;
    }

    if (_nuevaPasswordController.text.length < 6) {
      _mostrarMensaje('La nueva contraseña debe tener al menos 6 caracteres.',
          esError: true);
      return;
    }

    if (_nuevaPasswordController.text !=
        _confirmarPasswordController.text) {
      _mostrarMensaje('Las contraseñas nuevas no coinciden.',
          esError: true);
      return;
    }

    setState(() => _guardando = true);

    try {
      final data = await PerfilService.cambiarPassword(
        passwordActual: _passwordActualController.text,
        nuevaPassword: _nuevaPasswordController.text,
        confirmarPassword: _confirmarPasswordController.text,
      );

      _limpiarCamposPassword();

      if (mounted) {
        setState(() => _mostrarFormularioPassword = false);
        _mostrarMensaje(data['message']?.toString() ??
            'Contraseña actualizada correctamente.');
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensaje(_limpiarError(e), esError: true);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _limpiarCamposPassword() {
    _passwordActualController.clear();
    _nuevaPasswordController.clear();
    _confirmarPasswordController.clear();
  }
}