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

    final resultado =
        await AuthService.login(
      email,
      password,
    );

    _cargando = false;

    if (resultado["success"]) {
      _usuario = resultado["user"];

      notifyListeners();

      return true;
    } else {
      _error = resultado["message"];

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

    final resultado =
        await AuthService.loginConGoogle();

    _cargando = false;

    if (resultado["success"]) {
      _usuario = resultado["user"];

      notifyListeners();

      return true;
    } else {
      // Si el usuario canceló Google,
      // no mostramos error.
      if (resultado["cancelado"] != true) {
        _error = resultado["message"];
      }

      notifyListeners();

      return false;
    }
  }

  // =========================================================
  // CERRAR SESIÓN
  // =========================================================

  Future<void> logout() async {
    await AuthService.logout();

    await SecureStorage.deleteUser();

    _usuario = null;

    notifyListeners();
  }

  // =========================================================
  // RECUPERAR SESIÓN
  // =========================================================

  Future<void> verificarSesion() async {
    final token =
        await SecureStorage.getToken();

    final userJson =
        await SecureStorage.getUser();

    if (token != null && userJson != null) {
      _usuario = UserModel.fromJson(
        jsonDecode(userJson),
      );

      notifyListeners();
    }
  }
}