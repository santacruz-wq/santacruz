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

  //INTENTAMOS INICIAR SESION
  Future<bool> login(String email, String password) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    final resultado = await AuthService.login(email, password);

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

  //CERRAMOS SESION
  Future<void> logout() async {
    await AuthService.logout();
    _usuario = null;
    notifyListeners();
  }

  //VERIFICAMOS SI YA HAY TOKEN GUARDADO AL ABRIR LA APP (SESION PERSISTENTE)
  Future<void> verificarSesion() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      // Aquí normalmente decodificarías el token o llamarías a un endpoint "/me"
      // Por ahora, si hay token, dejamos que el login se haga de nuevo si el token expiró
    }
  }
}