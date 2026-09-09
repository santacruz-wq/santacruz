import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  // INICIAR SESIÓN
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.login,
      {
        "email": email,
        "password": password,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // GUARDAMOS EL TOKEN Y LOS DATOS DEL USUARIO
      await SecureStorage.saveToken(data["token"]);
      await SecureStorage.saveUser(
        jsonEncode(data["usuario"]),
      );

      return {
        "success": true,
        "user": UserModel.fromJson(data["usuario"]),
      };
    } else {
      return {
        "success": false,
        "message": data["message"] ??
            "Error al iniciar sesión",
      };
    }
  }

  // REGISTRAR NUEVO USUARIO
  static Future<Map<String, dynamic>> registrar(
    String nombre,
    String email,
    String password,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.registrar,
      {
        "nombre": nombre,
        "email": email,
        "password": password,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        "success": true,
        "message": data["message"],
      };
    } else {
      return {
        "success": false,
        "message": data["message"] ??
            "Error al registrar usuario",
      };
    }
  }

  // VERIFICAR CUENTA
  static Future<Map<String, dynamic>> verificarCuenta(
    String email,
    String codigo,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.verificarCodigo,
      {
        "email": email,
        "codigo": codigo,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data["message"] ??
          "Error al verificar la cuenta",
    };
  }

  // REENVIAR CÓDIGO DE VERIFICACIÓN
  static Future<Map<String, dynamic>> reenviarCodigo(
    String email,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.reenviarCodigo,
      {
        "email": email,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data["message"] ??
          "Error al reenviar el código",
    };
  }

  // SOLICITAR CÓDIGO DE RECUPERACIÓN
  static Future<Map<String, dynamic>> solicitarCodigo(
    String email,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.recuperarSolicitar,
      {
        "email": email,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data["message"],
    };
  }

  // CAMBIAR CONTRASEÑA CON CÓDIGO
  static Future<Map<String, dynamic>> cambiarPassword(
    String email,
    String codigo,
    String nuevaPassword,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.recuperarCambiar,
      {
        "email": email,
        "codigo": codigo,
        "nuevaPassword": nuevaPassword,
      },
      auth: false,
    );

    final data = jsonDecode(response.body);

    return {
      "success": response.statusCode == 200,
      "message": data["message"],
    };
  }

  // CERRAR SESIÓN
  static Future<void> logout() async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteUser();
  }
}