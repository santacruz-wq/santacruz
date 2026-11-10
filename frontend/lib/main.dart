
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/favorito_provider.dart';
import 'providers/resena_provider.dart';

import 'screens/inicio/inicio_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/verificar_cuenta_screen.dart';
import 'screens/auth/registro_screen.dart';
import 'screens/auth/recuperar_screen.dart';
import 'screens/language_selection/language_selection.dart';
import 'screens/user/favoritos_screen.dart';
import 'screens/main_shell.dart';
import 'screens/mesero/mesero_shell.dart';
import 'screens/cocina/cocina_shell.dart';
import 'screens/admin/admin_shell.dart';

import 'core/config/app_theme.dart';
import 'services/google_auth_service.dart';
import 'services/notificaciones_locales_service.dart';

// =========================================================
// MANEJADOR DE NOTIFICACIONES EN SEGUNDO PLANO
// =========================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('FCM: Notificación recibida en segundo plano.');
  debugPrint('Datos: ${message.data}');
}

// =========================================================
// CONFIGURACIÓN PRINCIPAL
// =========================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar notificaciones locales
  await NotificacionesLocalesService.inicializar();

  // Registrar el manejador de notificaciones en segundo plano
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Recibir notificaciones cuando la aplicación está abierta
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('FCM: Notificación recibida con la aplicación abierta.');
    debugPrint('Datos: ${message.data}');

    final titulo = message.notification?.title ??
        message.data['titulo']?.toString() ??
        'Santa Cruz de la Plazuela';

    final mensaje = message.notification?.body ??
        message.data['mensaje']?.toString() ??
        'Tienes una nueva notificación.';

    await NotificacionesLocalesService.mostrar(
      titulo: titulo,
      mensaje: mensaje,
    );
  });

  // Inicializar autenticación de Google
  await GoogleAuthService.inicializar(
    serverClientId:
        '610032994651-dvbn9h7p0o10dj1k6isql0bi76i2vo35.apps.googleusercontent.com',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FavoritoProvider()),
        ChangeNotifierProvider(create: (_) => ResenaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// =========================================================
// APLICACIÓN
// =========================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santa Cruz de la Plazuela',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppStarter(),
      routes: {
        '/inicio': (context) => InicioScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/language-selection': (context) =>
            const LanguageSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/menu': (context) => const MainShell(),
        '/main-shell': (context) => const MainShell(),
        '/favoritos': (context) => const FavoritosScreen(),

        '/verificar-cuenta': (context) {
          final email =
              ModalRoute.of(context)!.settings.arguments as String;

          return VerificarCuentaScreen(email: email);
        },

        '/recuperar': (context) => const RecuperarScreen(),
        '/admin': (context) => const AdminShell(),
        '/mesero': (context) => const MeseroShell(),
        '/cocina': (context) => const CocinaShell(),
      },
    );
  }
}

// =========================================================
// INICIO Y RECUPERACIÓN DE SESIÓN
// =========================================================

class AppStarter extends StatefulWidget {
  const AppStarter({super.key});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> {
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final authProvider = context.read<AuthProvider>();
    final languageProvider = context.read<LanguageProvider>();
    final favoritoProvider = context.read<FavoritoProvider>();

    try {
      await Future.wait([
        languageProvider.cargarIdiomaGuardado(),
        authProvider.verificarSesion(),
      ]);

      if (authProvider.usuario != null) {
        await favoritoProvider.cargarFavoritos();
      }
    } catch (e) {
      debugPrint(
        'Error al recuperar los datos iniciales: $e',
      );
    }

    if (!mounted) return;

    setState(() {
      _listo = true;
    });
  }

  Widget _pantallaSegunRol(String rol) {
    switch (rol.trim().toLowerCase()) {
      case 'admin':
      case 'administrador':
        return const AdminShell();

      case 'mesero':
        return const MeseroShell();

      case 'cocina':
        return const CocinaShell();

      case 'user':
      case 'usuario':
        return const MainShell();

      default:
        debugPrint(
          'Rol no reconocido al restaurar sesión: $rol',
        );

        return InicioScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final usuario = context.watch<AuthProvider>().usuario;

    if (usuario != null) {
      return _pantallaSegunRol(usuario.rol);
    }

    return InicioScreen();
  }
}
