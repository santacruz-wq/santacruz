import 'dart:convert';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  //INICIAR SESION
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiClient.post(
      ApiConfig.login,
      {"email": email, "password": password},
      auth: false,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      //GUARDAMOS EL TOKEN RECIBIDO
      await SecureStorage.saveToken(data["token"]);
      return {"success": true, "user": UserModel.fromJson(data["usuario"])};
    } else {
      return {"success": false, "message": data["message"] ?? "Error al iniciar sesión"};
    }
  }

  //REGISTRAR NUEVO USUARIO
  static Future<Map<String, dynamic>> registrar(String nombre, String email, String password) async {
    final response = await ApiClient.post(
      ApiConfig.registrar,
      {"nombre": nombre, "email": email, "password": password},
      auth: false,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {"success": true, "message": data["message"]};
    } else {
      return {"success": false, "message": data["message"] ?? "Error al registrar usuario"};
    }
  }

  //SOLICITAR CODIGO DE RECUPERACION
  static Future<Map<String, dynamic>> solicitarCodigo(String email) async {
    final response = await ApiClient.post(
      "${ApiConfig.recuperar}/solicitar",
      {"email": email},
      auth: false,
    );

    final data = jsonDecode(response.body);
    return {"success": response.statusCode == 200, "message": data["message"]};
  }

  //CAMBIAR CONTRASEÑA CON CODIGO
  static Future<Map<String, dynamic>> cambiarPassword(String email, String codigo, String nuevaPassword) async {
    final response = await ApiClient.post(
      "${ApiConfig.recuperar}/cambiar",
      {"email": email, "codigo": codigo, "nuevaPassword": nuevaPassword},
      auth: false,
    );

    final data = jsonDecode(response.body);
    return {"success": response.statusCode == 200, "message": data["message"]};
  }

  //CERRAR SESION
  static Future<void> logout() async {
    await SecureStorage.deleteToken();
  }
}
