import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

class ApiClient {
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {"Content-Type": "application/json"};
    if (auth) {
      final token = await SecureStorage.getToken();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  static Future<http.Response> get(String url, {bool auth = true}) async {
    return http.get(Uri.parse(url), headers: await _headers(auth: auth));
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body, {bool auth = true}) async {
    return http.post(Uri.parse(url), headers: await _headers(auth: auth), body: jsonEncode(body));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body, {bool auth = true}) async {
    return http.put(Uri.parse(url), headers: await _headers(auth: auth), body: jsonEncode(body));
  }
}