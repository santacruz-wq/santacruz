import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorito_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final favoritoProvider = context.read<FavoritoProvider>();

    final exito = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (exito) {
      //CARGAMOS LOS FAVORITOS DEL USUARIO QUE ACABA DE ENTRAR (EL TOKEN YA ESTA GUARDADO)
      await favoritoProvider.cargarFavoritos();

      if (!mounted) return;

      final rol = authProvider.usuario?.rol;
      //REDIRIGIMOS SEGUN EL ROL DEL USUARIO
      switch (rol) {
        case "admin":
          Navigator.pushReplacementNamed(context, "/admin");
          break;
        case "mesero":
          Navigator.pushReplacementNamed(context, "/mesero");
          break;
        case "cocina":
          Navigator.pushReplacementNamed(context, "/cocina");
          break;
        default:
          //LIMPIAMOS LA PILA PARA NO DUPLICAR EL MENU SI VENIAMOS DE TOCAR UN CORAZON
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/menu",
            (route) => false,
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? "Error al iniciar sesión")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Santa Cruz de la Plazuela",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Ingresa tu correo";
                    if (!value.contains("@")) return "Correo inválido";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Ingresa tu contraseña";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                authProvider.cargando
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("Iniciar sesión"),
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/recuperar"),
                  child: const Text("¿Olvidaste tu contraseña?"),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/registro"),
                  child: const Text("¿No tienes cuenta? Regístrate"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}