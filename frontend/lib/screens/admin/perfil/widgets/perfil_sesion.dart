part of '../../admin_perfil_screen.dart';

mixin _PerfilSesion on State<AdminPerfilScreen>, _PerfilEstado, _PerfilUtils {
  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cremaClaro,
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu cuenta de administrador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.caramelo,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _cerrandoSesion = true);

    try {
      await AuthService.logout();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _cerrandoSesion = false);
        _mostrarMensaje('No se pudo cerrar la sesión: ${_limpiarError(e)}',
            esError: true);
      }
    }
  }
}