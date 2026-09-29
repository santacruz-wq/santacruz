import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    final resultado = await AuthService.registrar(
      _nombreController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (resultado["success"]) {
      //VAMOS A LA PANTALLA DE VERIFICAR CUENTA, PASANDO EL CORREO
      Navigator.pushReplacementNamed(
        context,
        "/verificar-cuenta",
        arguments: _emailController.text.trim(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado["message"] ?? "Error al registrar usuario")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Crea tu cuenta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre completo",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Ingresa tu nombre";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                      if (value == null || value.isEmpty) return "Ingresa una contraseña";
                      if (value.length < 6) return "Debe tener al menos 6 caracteres";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmarController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirmar contraseña",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) return "Las contraseñas no coinciden";
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _cargando
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleRegistro,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text("Registrarme"),
                            ),
                          ),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                    child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}