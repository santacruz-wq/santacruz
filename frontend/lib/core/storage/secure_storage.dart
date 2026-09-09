import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "jwt_token";
  static const _userKey = "user_data";

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  //GUARDAMOS LOS DATOS DEL USUARIO (COMO JSON STRING)
  static Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  static Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

    //IDIOMA SELECCIONADO
  static const _idiomaCodigoKey = "idioma_codigo";
  static const _idiomaNombreKey = "idioma_nombre";

  static Future<void> saveIdioma(String codigo, String nombre) async {
    await _storage.write(key: _idiomaCodigoKey, value: codigo);
    await _storage.write(key: _idiomaNombreKey, value: nombre);
  }

  static Future<Map<String, String>?> getIdioma() async {
    final codigo = await _storage.read(key: _idiomaCodigoKey);
    final nombre = await _storage.read(key: _idiomaNombreKey);
    if (codigo == null || nombre == null) return null;
    return {"codigo": codigo, "nombre": nombre};
  }
}