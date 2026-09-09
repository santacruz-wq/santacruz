import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';

import 'screens/inicio/inicio_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/verificar_cuenta_screen.dart';
import 'screens/language_selection/language_selection.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
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
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/verificar-cuenta': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return VerificarCuentaScreen(email: email);
        },
        '/admin': (context) => const _PlaceholderScreen(titulo: "Panel Admin"),
        '/mesero': (context) => const _PlaceholderScreen(titulo: "Panel Mesero"),
        '/cocina': (context) => const _PlaceholderScreen(titulo: "Panel Cocina"),
        '/menu': (context) => const _PlaceholderScreen(titulo: "Menú"),
        '/recuperar': (context) => const _PlaceholderScreen(titulo: "Recuperar Contraseña"),
        '/registro': (context) => const _PlaceholderScreen(titulo: "Registro"),
      },
    );
  }
}

// =====================================================
// APP STARTER: carga sesión/idioma en segundo plano
// y siempre muestra la pantalla de inicio
// =====================================================

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

    // Cargamos idioma y sesión guardados en segundo plano
    // (para que InicioScreen ya sepa si saltar la selección de idioma)
    await Future.wait([
      languageProvider.cargarIdiomaGuardado(),
      authProvider.verificarSesion(),
    ]);

    if (!mounted) return;
    setState(() => _listo = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_listo) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return InicioScreen();
  }
}

// PANTALLA TEMPORAL MIENTRAS ARMAMOS LAS REALES
class _PlaceholderScreen extends StatelessWidget {
  final String titulo;

  const _PlaceholderScreen({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(child: Text("$titulo — en construcción")),
    );
  }
}