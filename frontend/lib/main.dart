
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'providers/favorito_provider.dart';

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

import 'services/google_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // GOOGLE SIGN-IN
  // ============================================================

  await GoogleAuthService.inicializar(
    serverClientId:
        '610032994651-dvbn9h7p0o10dj1k6isql0bi76i2vo35.apps.googleusercontent.com',
  );

  // ============================================================
  // PROVIDERS
  // ============================================================

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritoProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ============================================================
// APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santa Cruz de la Plazuela',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      home: const AppStarter(),

      routes: {
        // ======================================================
        // INICIO
        // ======================================================

        '/inicio': (context) => InicioScreen(),

        // ======================================================
        // REGISTRO
        // ======================================================

        '/registro': (context) => const RegistroScreen(),

        // ======================================================
        // SELECCIÓN DE IDIOMA
        // ======================================================

        '/language-selection': (context) =>
            const LanguageSelectionScreen(),

        // ======================================================
        // LOGIN
        // ======================================================

        '/login': (context) => const LoginScreen(),

        // ======================================================
        // USUARIO NORMAL
        // ======================================================

        '/menu': (context) => const MainShell(),

        '/main-shell': (context) => const MainShell(),

        // ======================================================
        // FAVORITOS
        // ======================================================

        '/favoritos': (context) => const FavoritosScreen(),

        // ======================================================
        // VERIFICAR CUENTA
        // ======================================================

        '/verificar-cuenta': (context) {
          final email = ModalRoute.of(context)!
              .settings
              .arguments as String;

          return VerificarCuentaScreen(
            email: email,
          );
        },

        // ======================================================
        // RECUPERAR CONTRASEÑA
        // ======================================================

        '/recuperar': (context) => const RecuperarScreen(),

        // ======================================================
        // ADMIN
        // ======================================================

        '/admin': (context) => const _PlaceholderScreen(
              titulo: 'Panel Admin',
            ),

        // ======================================================
        // MESERO
        // ======================================================

        // Utiliza el MeseroShell de:
        // screens/mesero/mesero_shell.dart
        '/mesero': (context) => const MeseroShell(),

        // ======================================================
        // COCINA
        // ======================================================

        '/cocina': (context) => const CocinaShell(),
      },
    );
  }
}

// ============================================================
// INICIO DE LA APLICACIÓN
// ============================================================

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

    final languageProvider =
        context.read<LanguageProvider>();

    final favoritoProvider =
        context.read<FavoritoProvider>();

    await Future.wait([
      languageProvider.cargarIdiomaGuardado(),
      authProvider.verificarSesion(),
    ]);

    // Si existe una sesión guardada,
    // cargamos los favoritos.
    if (authProvider.usuario != null) {
      await favoritoProvider.cargarFavoritos();
    }

    if (!mounted) return;

    setState(() {
      _listo = true;
    });
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

    return InicioScreen();
  }
}

// ============================================================
// PANTALLAS TEMPORALES
// ============================================================

class _PlaceholderScreen extends StatelessWidget {
  final String titulo;

  const _PlaceholderScreen({
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: Text(
          '$titulo — en construcción',
        ),
      ),
    );
  }
}
