import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/config/api_config.dart';
import '../../../core/config/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../services/usuarios_service.dart';
import 'administradores_dialogos.dart';
import 'widgets/administradores_contenido.dart';

class AdminAdministradoresScreen extends StatefulWidget {
  const AdminAdministradoresScreen({super.key});

  @override
  State<AdminAdministradoresScreen> createState() =>
      _AdminAdministradoresScreenState();
}

class _AdminAdministradoresScreenState
    extends State<AdminAdministradoresScreen> {
  List<Map<String, dynamic>> _usuarios = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    if (!mounted) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resultado = await UsuariosService.listarUsuarios();

      if (resultado['success'] != true) {
        throw Exception(
          resultado['message'] ??
              'No se pudieron cargar los usuarios.',
        );
      }

      final recibidos = resultado['usuarios'];

      if (recibidos is! List) {
        throw Exception(
          'El servidor no devolvió una lista de usuarios.',
        );
      }

      final lista = recibidos.map((usuario) {
        if (usuario is! Map) {
          throw Exception(
            'Se recibió un usuario con formato inválido.',
          );
        }
        return Map<String, dynamic>.from(usuario);
      }).toList();

      if (!mounted) return;

      setState(() {
        _usuarios = lista;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudieron cargar los usuarios: $e';
        _cargando = false;
      });
    }
  }

  List<Map<String, dynamic>> get _administradores =>
      _usuarios.where((u) => u['rol'] == 'admin').toList();

  List<Map<String, dynamic>> get _otrosUsuarios =>
      _usuarios.where((u) => u['rol'] != 'admin').toList();

  void _mensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  String _mensajeRespuesta(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map) {
        return (
          decoded['mensaje'] ??
          decoded['message'] ??
          decoded['error'] ??
          'La operación no se pudo completar.'
        ).toString();
      }
    } catch (_) {
      // La respuesta no contiene JSON válido.
    }

    return 'La operación no se pudo completar. '
        'Verifica la contraseña y los permisos.';
  }

  Future<void> _cambiarRol(
    Map<String, dynamic> usuario,
    String nuevoRol,
  ) async {
    final password =
        await AdministradoresDialogos.pedirPassword(context);

    if (!mounted || password == null || password.isEmpty) {
      return;
    }

    final id = usuario['_id']?.toString();

    if (id == null || id.isEmpty) {
      _mensaje('No se encontró el identificador del usuario.');
      return;
    }

    try {
      final respuesta = await ApiClient.patch(
        '${ApiConfig.baseUrl}/admin/usuarios/administradores/$id/rol',
        {
          'rol': nuevoRol,
          'password': password,
        },
      );

      if (!mounted) return;

      if (respuesta.statusCode >= 200 &&
          respuesta.statusCode < 300) {
        _mensaje(
          nuevoRol == 'admin'
              ? 'Usuario promovido a administrador.'
              : 'Se retiró el rol de administrador.',
        );

        await _cargarUsuarios();
      } else {
        _mensaje(_mensajeRespuesta(respuesta.body));
      }
    } catch (e) {
      _mensaje('No se pudo cambiar el rol: $e');
    }
  }

  Future<void> _cambiarEstado(
    Map<String, dynamic> usuario,
    bool activo,
  ) async {
    final id = usuario['_id']?.toString();

    if (id == null || id.isEmpty) {
      _mensaje('No se encontró el identificador del usuario.');
      return;
    }

    try {
      final respuesta = await ApiClient.patch(
        '${ApiConfig.baseUrl}/admin/usuarios/administradores/$id/estado',
        {'activo': activo},
      );

      if (!mounted) return;

      if (respuesta.statusCode >= 200 &&
          respuesta.statusCode < 300) {
        _mensaje(
          activo
              ? 'Administrador activado.'
              : 'Administrador desactivado.',
        );

        await _cargarUsuarios();
      } else {
        _mensaje(_mensajeRespuesta(respuesta.body));
      }
    } catch (e) {
      _mensaje('No se pudo cambiar el estado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text('Administradores'),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        actions: [
          IconButton(
            onPressed: _cargarUsuarios,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _cargarUsuarios,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : AdministradoresContenido(
                  administradores: _administradores,
                  otrosUsuarios: _otrosUsuarios,
                  cargarUsuarios: _cargarUsuarios,
                  cambiarRol: _cambiarRol,
                  cambiarEstado: _cambiarEstado,
                ),
    );
  }
}