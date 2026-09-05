import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'screens/inicio/inicio_screen.dart';
import 'screens/auth/login_screen.dart';
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
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => InicioScreen(),
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/login': (context) => const LoginScreen(),
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

//PANTALLA TEMPORAL MIENTRAS ARMAMOS LAS REALES
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