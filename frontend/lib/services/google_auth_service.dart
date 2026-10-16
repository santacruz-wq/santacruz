import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn.instance;

  static bool _inicializado = false;

  static Future<void> inicializar({
    required String serverClientId,
  }) async {
    if (_inicializado) return;

    await _googleSignIn.initialize(
      serverClientId: serverClientId,
    );

    _inicializado = true;
  }

  static Future<String?> iniciarSesion() async {
    try {
      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception(
          'Google Sign-In no está disponible en este dispositivo',
        );
      }

      final GoogleSignInAccount cuenta =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication autenticacion =
          cuenta.authentication;

      final idToken = autenticacion.idToken;

      if (idToken == null) {
        throw Exception(
          'Google no proporcionó un ID Token',
        );
      }

      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }

      throw Exception(
        'Error al iniciar sesión con Google: ${e.description ?? e}',
      );
    } catch (e) {
      throw Exception(
        'Error al iniciar sesión con Google: $e',
      );
    }
  }

  static Future<void> cerrarSesion() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
