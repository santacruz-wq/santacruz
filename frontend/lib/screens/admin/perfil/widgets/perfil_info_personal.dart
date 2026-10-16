part of '../../admin_perfil_screen.dart';

mixin _PerfilInfoPersonal
    on State<AdminPerfilScreen>, _PerfilEstado, _PerfilDatos, _PerfilComponentes {
  Widget _buildInfoPersonal() {
    return _seccion(
      titulo: 'Información personal',
      icono: Icons.person_outline,
      contenido: Column(
        children: [
          _campo(
            etiqueta: 'Nombre completo',
            controller: _nombreController,
            icono: Icons.badge_outlined,
            soloLectura: !_mostrarFormularioEdicion,
          ),
          _campo(
            etiqueta: 'Correo electrónico',
            controller: _emailController,
            icono: Icons.email_outlined,
            soloLectura: !_mostrarFormularioEdicion,
            teclado: TextInputType.emailAddress,
          ),
          if (_mostrarFormularioEdicion) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _guardando
                        ? null
                        : () {
                            setState(() {
                              _nombreController.text =
                                  _usuario?['nombre']?.toString() ?? '';
                              _emailController.text =
                                  _usuario?['email']?.toString() ?? '';
                              _mostrarFormularioEdicion = false;
                            });
                          },
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _guardando ? null : _guardarPerfil,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.caramelo,
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() => _mostrarFormularioEdicion = true);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar información'),
              ),
            ),
        ],
      ),
    );
  }
}