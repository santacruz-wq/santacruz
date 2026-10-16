
import 'package:flutter/material.dart';

import '../../../../models/categoria_model.dart';

class ListaCategorias extends StatelessWidget {
  final bool cargando;
  final List<Categoria> categorias;
  final bool mostrarInactivas;
  final Future<void> Function() onRefresh;
  final ValueChanged<Categoria> onEditar;
  final Future<void> Function(
    Categoria categoria, {
    required bool activar,
  }) onCambiarEstado;

  const ListaCategorias({
    super.key,
    required this.cargando,
    required this.categorias,
    required this.mostrarInactivas,
    required this.onRefresh,
    required this.onEditar,
    required this.onCambiarEstado,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categorias.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.category_outlined, size: 60),
              const SizedBox(height: 12),
              Text(
                mostrarInactivas
                    ? 'No hay categorías inactivas'
                    : 'Todavía no hay categorías activas',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: categoria.activo
                    ? const Color(0xFFE8DCCB)
                    : Colors.grey.shade200,
                child: Icon(
                  Icons.category,
                  color: categoria.activo
                      ? const Color(0xFF6F4E37)
                      : Colors.grey,
                ),
              ),
              title: Text(
                categoria.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2314),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoria.descripcion.isNotEmpty)
                      Text(categoria.descripcion),
                    const SizedBox(height: 5),
                    Text(
                      categoria.activo ? 'Activa' : 'Inactiva',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: categoria.activo
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (opcion) {
                  if (opcion == 'editar') {
                    onEditar(categoria);
                  } else if (opcion == 'desactivar') {
                    onCambiarEstado(categoria, activar: false);
                  } else if (opcion == 'reactivar') {
                    onCambiarEstado(categoria, activar: true);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar'),
                  ),
                  if (categoria.activo)
                    const PopupMenuItem(
                      value: 'desactivar',
                      child: Text('Desactivar'),
                    ),
                  if (!categoria.activo)
                    const PopupMenuItem(
                      value: 'reactivar',
                      child: Text('Reactivar'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
