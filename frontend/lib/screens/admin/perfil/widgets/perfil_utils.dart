part of '../../admin_perfil_screen.dart';

mixin _PerfilUtils on State<AdminPerfilScreen> {
  String _limpiarError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor:
              esError ? Colors.red.shade700 : AppColors.cafeMedio,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}