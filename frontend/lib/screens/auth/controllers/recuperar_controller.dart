import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class RecuperarController {
  final correo = TextEditingController();
  final codigo = TextEditingController();
  final nuevaContrasena = TextEditingController();
  final confirmarContrasena = TextEditingController();

  bool ocultarContrasena = true;
  bool ocultarConfirmacion = true;
  bool cargando = false;

  void dispose() {
    correo.dispose();
    codigo.dispose();
    nuevaContrasena.dispose();
    confirmarContrasena.dispose();
  }

  void cambiarContrasena() {
    ocultarContrasena = !ocultarContrasena;
  }

  void cambiarConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
  }

  String? validarCorreo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo';
    }

    if (!value.contains('@')) {
      return 'Correo inválido';
    }

    return null;
  }

  String? validarCodigo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa el código';
    }

    if (value.length != 6) {
      return 'El código debe tener 6 dígitos';
    }

    return null;
  }

  String? validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una contraseña';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener mínimo 6 caracteres';
    }

    return null;
  }

  String? validarConfirmacion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != nuevaContrasena.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  Future<Map<String, dynamic>> solicitarCodigo() async {
    return await AuthService.solicitarCodigo(
      correo.text.trim(),
    );
  }

  Future<Map<String, dynamic>> cambiarPassword() async {
    return await AuthService.cambiarPassword(
      correo.text.trim(),
      codigo.text.trim(),
      nuevaContrasena.text,
    );
  }
}

