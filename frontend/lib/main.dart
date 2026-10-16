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
import 'screens/admin/admin_shell.dart';
import 'providers/resena_provider.dart';

import 'services/google_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

    await Future.wait([
      languageProvider.cargarIdiomaGuardado(),
      authProvider.verificarSesion(),
    ]);

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