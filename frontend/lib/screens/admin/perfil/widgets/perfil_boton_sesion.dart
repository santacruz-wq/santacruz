part of '../../admin_perfil_screen.dart';

mixin _PerfilBotonSesion on State<AdminPerfilScreen>, _PerfilEstado, _PerfilSesion {
  Widget _buildBotonCerrarSesion() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _cerrandoSesion ? null : _cerrarSesion,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: _cerrandoSesion
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.logout),
        label: Text(
          _cerrandoSesion ? 'Cerrando sesión...' : 'Cerrar sesión',
        ),
      ),
    );
  }
}