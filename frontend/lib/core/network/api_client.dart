
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';
import '../config/api_config.dart';

class ApiClient {
  static Future<bool>? _refreshing;

  static Future<Map<String, String>> _headers({
    bool auth = true,
  }) async {
    final headers = {"Content-Type": "application/json"};

    if (auth) {
      final token = await SecureStorage.getToken();

      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // RENOVAR SESIÓN SIN USAR ApiClient, PARA EVITAR BUCLES
  static Future<bool> _refreshToken() {
    final ongoing = _refreshing;

    if (ongoing != null) {
      return ongoing;
    }

    final future = _performRefresh();
    _refreshing = future;

    return future.whenComplete(() {
      _refreshing = null;
    });
  }

  static Future<bool> _performRefresh() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.renovarSesion),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final nuevoToken = data["token"];
        final nuevoRefreshToken = data["refreshToken"];

        if (nuevoToken is! String ||
            nuevoRefreshToken is! String ||
            nuevoToken.isEmpty ||
            nuevoRefreshToken.isEmpty) {
          await SecureStorage.deleteToken();
          await SecureStorage.deleteRefreshToken();
          return false;
        }

        await SecureStorage.saveToken(nuevoToken);
        await SecureStorage.saveRefreshToken(nuevoRefreshToken);

        return true;
      }

      if (response.statusCode == 401 ||
          response.statusCode == 403) {
        await SecureStorage.deleteToken();
        await SecureStorage.deleteRefreshToken();
        await SecureStorage.deleteUser();
      }

      return false;
    } catch (_) {
      // Si no hay conexión, no borrar las credenciales.
      return false;
    }
  }

  static Future<http.Response> _request(
    Future<http.Response> Function(
      Map<String, String> headers,
    ) send, {
    bool auth = true,
  }) async {
    var headers = await _headers(auth: auth);
    var response = await send(headers);

    if (auth && response.statusCode == 401) {
      final renovado = await _refreshToken();

      if (renovado) {
        headers = await _headers(auth: true);
        response = await send(headers);
      }
    }

    return response;
  }

  static Future<http.Response> get(
    String url, {
    bool auth = true,
  }) {
    return _request(
      (headers) => http.get(
        Uri.parse(url),
        headers: headers,
      ),
      auth: auth,
    );
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    bool auth = true,
  }) {
    return _request(
      (headers) => http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ),
      auth: auth,
    );
  }

  static Future<http.Response> put(
    String url,
    Map<String, dynamic> body, {
    bool auth = true,
  }) {
    return _request(
      (headers) => http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ),
      auth: auth,
    );
  }

  static Future<http.Response> patch(
    String url,
    Map<String, dynamic> body, {
    bool auth = true,
  }) {
    return _request(
      (headers) => http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ),
      auth: auth,
    );
  }

  static Future<http.Response> delete(
    String url, {
    bool auth = true,
  }) {
    return _request(
      (headers) => http.delete(
        Uri.parse(url),
        headers: headers,
      ),
      auth: auth,
    );
  }
}
