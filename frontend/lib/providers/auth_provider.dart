
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/storage/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _usuario;

  bool _cargando = false;

  String? _error;

  UserModel? get usuario => _usuario;

  bool get cargando => _cargando;

  String? get error => _error;

  bool get estaLogueado => _usuario != null;

  // =========================================================
  // LOGIN NORMAL
  // =========================================================

  Future<bool> login(
    String email,
    String password,
  ) async {
    _cargando = true;
    _error = null;

    notifyListeners();

    try {
      final resultado = await AuthService.login(
        email,
        password,
      );

      _cargando = false;

      if (resultado['success'] == true) {
        _usuario = resultado['user'] as UserModel?;

        notifyListeners();

        return _usuario != null;
      } else {
        _error = resultado['message']?.toString();

        notifyListeners();

        return false;
      }
    } catch (e) {
      _cargando = false;
      _error = e.toString().replaceFirst('Exception: ', '');

      notifyListeners();

      return false;
    }
  }

  // =========================================================
  // LOGIN CON GOOGLE
  // =========================================================

  Future<bool> loginConGoogle() async {
    _cargando = true;
    _error = null;

    notifyListeners();

    try {
      final resultado = await AuthService.loginConGoogle();

      _cargando = false;

      if (resultado['success'] == true) {
        _usuario = resultado['user'] as UserModel?;

        notifyListeners();

        return _usuario != null;
      } else {
        // Si el usuario cancela Google, no mostramos error.
        if (resultado['cancelado'] != true) {
          _error = resultado['message']?.toString();
        }

        notifyListeners();

        return false;
      }
    } catch (e) {
      _cargando = false;
      _error = e.toString().replaceFirst('Exception: ', '');

      notifyListeners();

      return false;
    }
  }

  // =========================================================
  // ACTUALIZAR USUARIO DESDE EL PERFIL
  // =========================================================

  void actualizarUsuarioDesdePerfil(
    Map<String, dynamic> datos,
  ) {
    final usuarioActual = _usuario;

    if (usuarioActual == null) return;

    final usuarioActualizado = <String, dynamic>{
      ...usuarioActual.toJson(),
      '_id': usuarioActual.id,
      'nombre': datos['nombre'] ?? usuarioActual.nombre,
      'email': datos['email'] ?? usuarioActual.email,
      'rol': datos['rol'] ?? usuarioActual.rol,
      'activo': datos['activo'] ?? usuarioActual.activo,
      'isVerified': datos['isVerified'] ?? usuarioActual.isVerified,
      'avatar': datos.containsKey('avatar')
          ? datos['avatar']
          : usuarioActual.avatar,
      'createdAt':
          datos['createdAt'] ?? usuarioActual.createdAt?.toIso8601String(),
    };

    _usuario = UserModel.fromJson(usuarioActualizado);

    notifyListeners();
  }

  // =========================================================
  // CERRAR SESIÓN
  // =========================================================

  Future<void> logout() async {
    await AuthService.logout();

    await SecureStorage.deleteUser();

    _usuario = null;

    _error = null;

    notifyListeners();
  }

  // =========================================================
  // RECUPERAR SESIÓN
  // =========================================================

  
  Future<void> verificarSesion() async {
    try {
      final token = await SecureStorage.getToken();
      final userJson = await SecureStorage.getUser();

      if (token == null ||
          token.trim().isEmpty ||
          userJson == null ||
          userJson.trim().isEmpty) {
        _usuario = null;
        notifyListeners();
        return;
      }

      final decoded = jsonDecode(userJson);

      if (decoded is! Map<String, dynamic>) {
        _usuario = null;
        notifyListeners();
        return;
      }

      final usuario = UserModel.fromJson(decoded);

      if (usuario.id == null || usuario.rol.trim().isEmpty) {
        _usuario = null;
        notifyListeners();
        return;
      }

      _usuario = usuario;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al recuperar la sesión: $e');
      _usuario = null;
      notifyListeners();
    }
  }

}
