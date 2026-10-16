import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/perfil_service.dart';

part 'perfil/widgets/perfil_estado.dart';
part 'perfil/widgets/perfil_utils.dart';
part 'perfil/widgets/perfil_datos.dart';
part 'perfil/widgets/perfil_password.dart';
part 'perfil/widgets/perfil_foto.dart';
part 'perfil/widgets/perfil_sesion.dart';
part 'perfil/widgets/perfil_componentes.dart';
part 'perfil/widgets/perfil_cabecera.dart';
part 'perfil/widgets/perfil_info_personal.dart';
part 'perfil/widgets/perfil_seguridad.dart';
part 'perfil/widgets/perfil_boton_sesion.dart';

class AdminPerfilScreen extends StatefulWidget {
  const AdminPerfilScreen({super.key});

  @override
  State<AdminPerfilScreen> createState() => _AdminPerfilScreenState();
}

class _AdminPerfilScreenState extends State<AdminPerfilScreen>
    with
        _PerfilEstado,
        _PerfilUtils,
        _PerfilDatos,
        _PerfilPassword,
        _PerfilFoto,
        _PerfilSesion,
        _PerfilComponentes,
        _PerfilCabecera,
        _PerfilInfoPersonal,
        _PerfilSeguridad,
        _PerfilBotonSesion {
  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordActualController.dispose();
    _nuevaPasswordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.caramelo,
        ),
      );
    }

    final nombre = _usuario?['nombre']?.toString() ?? 'Administrador';
    final email = _usuario?['email']?.toString() ?? '';
    final rol = _usuario?['rol']?.toString() ?? 'admin';
    final avatar = _imagenPerfil();

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar datos',
            onPressed: _guardando ? null : _cargarPerfil,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.caramelo,
        onRefresh: _cargarPerfil,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            _buildCabecera(
              nombre: nombre,
              email: email,
              rol: rol,
              avatar: avatar,
            ),
            _buildInfoPersonal(),
            _buildSeguridad(),
            _buildBotonCerrarSesion(),
            if (_guardando) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(color: AppColors.caramelo),
            ],
          ],
        ),
      ),
    );
  }
}