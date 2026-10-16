import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../services/usuarios_service.dart';
import 'admin_usuario_dialogos.dart';
import 'widgets/admin_usuarios_contenido.dart';

class AdminUsuariosScreen extends StatefulWidget {
  const AdminUsuariosScreen({super.key});

  @override
  State<AdminUsuariosScreen> createState() =>
      _AdminUsuariosScreenState();
}

class _AdminUsuariosScreenState extends State<AdminUsuariosScreen> {
  final TextEditingController _busquedaController =
      TextEditingController();

  List<Map<String, dynamic>> _usuarios = [];
  bool _cargando = true;
  String? _error;
  String _filtroRol = 'todos';
  String _filtroEstado = 'todos';

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuarios() async {
    if (mounted) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }

    try {
      final resultado = await UsuariosService.listarUsuarios();
      if (!mounted) return;

      if (resultado['success'] == true) {
        setState(() {
          _usuarios = List<Map<String, dynamic>>.from(
            resultado['usuarios'] ?? [],
          );
          _cargando = false;
        });
      } else {
        setState(() {
          _error = resultado['message'] ??
              'No se pudieron cargar los usuarios.';
          _cargando = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error de conexión al cargar los usuarios.';
        _cargando = false;
      });
    }
  }

  List<Map<String, dynamic>> get _usuariosFiltrados {
    final busqueda = _busquedaController.text.trim().toLowerCase();

    return _usuarios.where((usuario) {
      final nombre =
          (usuario['nombre'] ?? '').toString().toLowerCase();
      final email =
          (usuario['email'] ?? '').toString().toLowerCase();
      final rol = (usuario['rol'] ?? 'usuario').toString();
      final activo = usuario['activo'] == true;

      final coincideBusqueda =
          nombre.contains(busqueda) || email.contains(busqueda);
      final coincideRol =
          _filtroRol == 'todos' || rol == _filtroRol;
      final coincideEstado = _filtroEstado == 'todos' ||
          (_filtroEstado == 'activos' && activo) ||
          (_filtroEstado == 'inactivos' && !activo);

      return coincideBusqueda && coincideRol && coincideEstado;
    }).toList();
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _editarUsuario(
    Map<String, dynamic> usuario,
  ) async {
    final id = (usuario['_id'] ?? '').toString();
    final nombre = (usuario['nombre'] ?? 'este usuario').toString();
    final rolAnterior = (usuario['rol'] ?? 'usuario').toString();
    final activoAnterior = usuario['activo'] == true;

    if (id.isEmpty) {
      _mostrarMensaje('No se encontró el ID del usuario.');
      return;
    }
    if (rolAnterior == 'admin') {
      _mostrarMensaje(
        'Los administradores se gestionan desde su sección independiente.',
      );
      return;
    }

    final cambios = await AdminUsuarioDialogos.editar(
      context: context,
      nombre: nombre,
      rolInicial: rolAnterior,
      activoInicial: activoAnterior,
    );

    if (cambios == null || !mounted) return;

    final rolNuevo = cambios['rol'] as String;
    final activoNuevo = cambios['activo'] as bool;

    if (rolNuevo == rolAnterior &&
        activoNuevo == activoAnterior) {
      _mostrarMensaje('No realizaste ningún cambio.');
      return;
    }

    final confirmar = await AdminUsuarioDialogos.confirmar(
      context: context,
      nombre: nombre,
      rolAnterior: rolAnterior,
      rolNuevo: rolNuevo,
      activoAnterior: activoAnterior,
      activoNuevo: activoNuevo,
    );

    if (confirmar != true || !mounted) return;

    await _guardarCambiosUsuario(
      id: id,
      rolAnterior: rolAnterior,
      rolNuevo: rolNuevo,
      activoAnterior: activoAnterior,
      activoNuevo: activoNuevo,
    );
  }

  Future<void> _guardarCambiosUsuario({
    required String id,
    required String rolAnterior,
    required String rolNuevo,
    required bool activoAnterior,
    required bool activoNuevo,
  }) async {
    bool rolActualizado = false;

    try {
      if (rolNuevo != rolAnterior) {
        final resultadoRol = await UsuariosService.cambiarRol(
          id: id,
          rol: rolNuevo,
        );

        if (resultadoRol['success'] != true) {
          throw Exception(
            resultadoRol['message'] ?? 'No se pudo cambiar el rol.',
          );
        }
        rolActualizado = true;
      }

      if (activoNuevo != activoAnterior) {
        final resultadoEstado =
            await UsuariosService.cambiarEstado(
          id: id,
          activo: activoNuevo,
        );

        if (resultadoEstado['success'] != true) {
          if (rolActualizado) await _cargarUsuarios();
          throw Exception(
            resultadoEstado['message'] ??
                'No se pudo cambiar el estado de la cuenta.',
          );
        }
      }

      if (!mounted) return;
      _mostrarMensaje('Usuario actualizado correctamente.');
      await _cargarUsuarios();
    } catch (e) {
      if (!mounted) return;
      if (rolActualizado) await _cargarUsuarios();
      _mostrarMensaje(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
        title: const Text(
          'Usuarios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar usuarios',
            onPressed: _cargando ? null : _cargarUsuarios,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: AdminUsuariosContenido(
        totalUsuarios: _usuarios.length,
        usuarios: _usuariosFiltrados,
        cargando: _cargando,
        error: _error,
        busquedaController: _busquedaController,
        filtroRol: _filtroRol,
        filtroEstado: _filtroEstado,
        cargarUsuarios: _cargarUsuarios,
        cambiarFiltroRol: (valor) {
          if (valor != null) setState(() => _filtroRol = valor);
        },
        cambiarFiltroEstado: (valor) {
          if (valor != null) setState(() => _filtroEstado = valor);
        },
        editarUsuario: _editarUsuario,
      ),
    );
  }
}