import 'dart:convert';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'google_auth_service.dart';

class AuthService {

  // =========================================================
  // INICIAR SESIÓN NORMAL
  // =========================================================

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
      await SecureStorage.saveToken(
        data["token"],
      );

      await SecureStorage.saveUser(
        jsonEncode(data["usuario"]),
      );

      return {
        "success": true,
        "user": UserModel.fromJson(
          data["usuario"],
        ),
      };
    } else {
      return {
        "success": false,
        "message": data["mensaje"] ??
            data["message"] ??
            "Correo o contraseña incorrectos",
      };
    }
  }

  // =========================================================
  // INICIAR SESIÓN / REGISTRARSE CON GOOGLE
  // =========================================================

  static Future<Map<String, dynamic>> loginConGoogle() async {
    try {
      // 1. Abrir Google
      final idToken =
          await GoogleAuthService.iniciarSesion();

      // Usuario canceló
      if (idToken == null) {
        return {
          "success": false,
          "cancelado": true,
          "message": "Inicio de sesión cancelado",
        };
      }

      // 2. Enviar token al backend
      final response = await ApiClient.post(
        ApiConfig.loginGoogle,
        {
          "idToken": idToken,
        },
        auth: false,
      );

      final data = jsonDecode(response.body);

      // 3. Login exitoso
      if (response.statusCode == 200) {
        await SecureStorage.saveToken(
          data["token"],
        );

        await SecureStorage.saveUser(
          jsonEncode(data["usuario"]),
        );

        return {
          "success": true,
          "user": UserModel.fromJson(
            data["usuario"],
          ),
        };
      }

      return {
        "success": false,
        "cancelado": false,
        "message": data["mensaje"] ??
            data["message"] ??
            "No fue posible iniciar sesión con Google",
      };
    } catch (e) {
      return {
        "success": false,
        "cancelado": false,
        "message": e.toString(),
      };
    }
  }

  // =========================================================
  // REGISTRAR NUEVO USUARIO
  // =========================================================

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
        "message": data["mensaje"] ??
            data["message"],
      };
    } else {
      return {
        "success": false,
        "message": data["mensaje"] ??
            data["message"] ??
            "Error al registrar usuario",
      };
    }
  }

  // =========================================================
  // VERIFICAR CUENTA
  // =========================================================

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
          data["mensaje"] ??
          "Error al verificar la cuenta",
    };
  }

  // =========================================================
  // REENVIAR CÓDIGO
  // =========================================================

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
          data["mensaje"] ??
          "Error al reenviar el código",
    };
  }

  // =========================================================
  // RECUPERAR CONTRASEÑA
  // =========================================================

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

  // =========================================================
  // CAMBIAR CONTRASEÑA
  // =========================================================

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

  // =========================================================
  // CERRAR SESIÓN
  // =========================================================

  static Future<void> logout() async {
    await GoogleAuthService.cerrarSesion();

    await SecureStorage.deleteToken();
    await SecureStorage.deleteUser();
  }
}