part of '../../admin_perfil_screen.dart';

mixin _PerfilSeguridad
    on State<AdminPerfilScreen>, _PerfilEstado, _PerfilPassword, _PerfilComponentes {
  Widget _buildSeguridad() {
    return _seccion(
      titulo: 'Seguridad',
      icono: Icons.lock_outline,
      contenido: Column(
        children: [
          if (_mostrarFormularioPassword) ...[
            _campo(
              etiqueta: 'Contraseña actual',
              controller: _passwordActualController,
              icono: Icons.lock_outline,
              password: true,
              ocultarPassword: _ocultarPasswordActual,
              cambiarVisibilidad: () => setState(
                () => _ocultarPasswordActual = !_ocultarPasswordActual,
              ),
            ),
            _campo(
              etiqueta: 'Nueva contraseña',
              controller: _nuevaPasswordController,
              icono: Icons.lock_reset_outlined,
              password: true,
              ocultarPassword: _ocultarNuevaPassword,
              cambiarVisibilidad: () => setState(
                () => _ocultarNuevaPassword = !_ocultarNuevaPassword,
              ),
            ),
            _campo(
              etiqueta: 'Confirmar nueva contraseña',
              controller: _confirmarPasswordController,
              icono: Icons.verified_user_outlined,
              password: true,
              ocultarPassword: _ocultarConfirmacion,
              cambiarVisibilidad: () => setState(
                () => _ocultarConfirmacion = !_ocultarConfirmacion,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _guardando
                        ? null
                        : () {
                            _limpiarCamposPassword();
                            setState(
                              () => _mostrarFormularioPassword = false,
                            );
                          },
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _guardando ? null : _guardarPassword,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.caramelo,
                    ),
                    child: const Text('Actualizar'),
                  ),
                ),
              ],
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() => _mostrarFormularioPassword = true);
                },
                icon: const Icon(Icons.password_outlined),
                label: const Text('Cambiar contraseña'),
              ),
            ),
        ],
      ),
    );
  }
}