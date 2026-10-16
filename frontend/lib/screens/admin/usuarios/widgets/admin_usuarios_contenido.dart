import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import 'admin_usuario_tarjeta.dart';

class AdminUsuariosContenido extends StatelessWidget {
  final int totalUsuarios;
  final List<Map<String, dynamic>> usuarios;
  final bool cargando;
  final String? error;
  final TextEditingController busquedaController;
  final String filtroRol;
  final String filtroEstado;
  final Future<void> Function() cargarUsuarios;
  final ValueChanged<String?> cambiarFiltroRol;
  final ValueChanged<String?> cambiarFiltroEstado;
  final ValueChanged<Map<String, dynamic>> editarUsuario;

  const AdminUsuariosContenido({
    super.key,
    required this.totalUsuarios,
    required this.usuarios,
    required this.cargando,
    required this.error,
    required this.busquedaController,
    required this.filtroRol,
    required this.filtroEstado,
    required this.cargarUsuarios,
    required this.cambiarFiltroRol,
    required this.cambiarFiltroEstado,
    required this.editarUsuario,
  });

  Widget _selector({
    required String valor,
    required List<DropdownMenuItem<String>> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        initialValue: valor,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cremaClaro,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: opciones,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: cargarUsuarios,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cafeMedio,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                  size: 38,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuarios registrados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalUsuarios',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: busquedaController,
            onChanged: (_) => (context as Element).markNeedsBuild(),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o correo...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.cremaClaro,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _selector(
                valor: filtroRol,
                opciones: const [
                  DropdownMenuItem(
                    value: 'todos',
                    child: Text('Todos los roles'),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Administrador'),
                  ),
                  DropdownMenuItem(
                    value: 'mesero',
                    child: Text('Mesero'),
                  ),
                  DropdownMenuItem(
                    value: 'cocina',
                    child: Text('Cocina'),
                  ),
                  DropdownMenuItem(
                    value: 'usuario',
                    child: Text('Usuario'),
                  ),
                ],
                onChanged: cambiarFiltroRol,
              ),
              const SizedBox(width: 10),
              _selector(
                valor: filtroEstado,
                opciones: const [
                  DropdownMenuItem(
                    value: 'todos',
                    child: Text('Todos los estados'),
                  ),
                  DropdownMenuItem(
                    value: 'activos',
                    child: Text('Activos'),
                  ),
                  DropdownMenuItem(
                    value: 'inactivos',
                    child: Text('Inactivos'),
                  ),
                ],
                onChanged: cambiarFiltroEstado,
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (cargando)
            const Padding(
              padding: EdgeInsets.all(36),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 42,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  Text(error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: cargarUsuarios,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          else if (usuarios.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    size: 48,
                    color: AppColors.cafeMedio,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No se encontraron usuarios',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textoCafe,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              '${usuarios.length} resultado(s)',
              style: const TextStyle(
                color: AppColors.cafeMedio,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...usuarios.map(
              (usuario) => AdminUsuarioTarjeta(
                usuario: usuario,
                onEditar: () => editarUsuario(usuario),
              ),
            ),
          ],
        ],
      ),
    );
  }
}