import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilHeader extends StatefulWidget {
  final bool oscuro;
  final bool es;

  const PerfilHeader({
    super.key,
    required this.oscuro,
    required this.es,
  });

  @override
  State<PerfilHeader> createState() => _PerfilHeaderState();
}

class _PerfilHeaderState extends State<PerfilHeader> {
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color doradoClaro = Color(0xFFF3D27A);

  final ImagePicker _picker = ImagePicker();
  Uint8List? _fotoPerfil;

  @override
  void initState() {
    super.initState();
    _cargarFoto();
  }

  Future<void> _cargarFoto() async {
    final prefs = await SharedPreferences.getInstance();
    final foto = prefs.getString('foto_perfil');

    if (foto != null && mounted) {
      setState(() {
        _fotoPerfil = base64Decode(foto);
      });
    }
  }

  Future<void> _seleccionarFoto(ImageSource origen) async {
    try {
      final imagen = await _picker.pickImage(
        source: origen,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (imagen == null) return;

      final bytes = await imagen.readAsBytes();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'foto_perfil',
        base64Encode(bytes),
      );

      if (mounted) {
        setState(() {
          _fotoPerfil = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: cafeOscuro,
          content: Text(
            widget.es
                ? 'No se pudo seleccionar la foto.'
                : 'The photo could not be selected.',
          ),
        ),
      );
    }
  }

  void _mostrarOpcionesFoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          widget.oscuro ? const Color(0xFF2B211D) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: widget.oscuro
                      ? Colors.white24
                      : cafeClaro.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.es
                    ? 'Cambiar foto de perfil'
                    : 'Change profile photo',
                style: TextStyle(
                  color: widget.oscuro
                      ? Colors.white
                      : cafeOscuro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _opcionFoto(
                Icons.camera_alt,
                widget.es
                    ? 'Tomar una foto'
                    : 'Take a photo',
                () {
                  Navigator.pop(context);
                  _seleccionarFoto(ImageSource.camera);
                },
              ),
              _opcionFoto(
                Icons.photo_library_outlined,
                widget.es
                    ? 'Elegir de la galería'
                    : 'Choose from gallery',
                () {
                  Navigator.pop(context);
                  _seleccionarFoto(ImageSource.gallery);
                },
              ),
              if (_fotoPerfil != null)
                _opcionFoto(
                  Icons.delete_outline,
                  widget.es
                      ? 'Eliminar foto'
                      : 'Delete photo',
                  () {
                    Navigator.pop(context);
                    _confirmarEliminarFoto();
                  },
                  rojo: true,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opcionFoto(
    IconData icono,
    String titulo,
    VoidCallback accion, {
    bool rojo = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: rojo
              ? Colors.red.withOpacity(0.12)
              : doradoClaro.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icono,
          color: rojo
              ? Colors.red
              : widget.oscuro
                  ? doradoClaro
                  : cafe,
        ),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          color: rojo
              ? Colors.red
              : widget.oscuro
                  ? Colors.white
                  : cafeOscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: accion,
    );
  }

  void _confirmarEliminarFoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            widget.oscuro ? const Color(0xFF2B211D) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          widget.es ? '¿Eliminar foto?' : 'Delete photo?',
          style: TextStyle(
            color: widget.oscuro ? Colors.white : cafeOscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          widget.es
              ? 'La foto de perfil será eliminada.'
              : 'Your profile photo will be deleted.',
          style: TextStyle(
            color: widget.oscuro ? Colors.white70 : cafeClaro,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(
                color: widget.oscuro ? doradoClaro : cafe,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eliminarFoto();
            },
            child: Text(
              widget.es ? 'Sí, eliminar' : 'Yes, delete',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarFoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('foto_perfil');

    if (!mounted) return;

    setState(() {
      _fotoPerfil = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cafeOscuro,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          widget.es ? 'Foto eliminada.' : 'Photo deleted.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.oscuro
              ? [
                  const Color(0xFF4E342E),
                  const Color(0xFF2B211D),
                ]
              : [
                  cafeOscuro,
                  cafe,
                  cafeClaro,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              widget.oscuro ? 0.25 : 0.12,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _mostrarOpcionesFoto,
            child: Stack(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: doradoClaro.withOpacity(0.65),
                      width: 2,
                    ),
                    image: _fotoPerfil != null
                        ? DecorationImage(
                            image: MemoryImage(_fotoPerfil!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _fotoPerfil == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 38,
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: doradoClaro,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.oscuro
                            ? const Color(0xFF2B211D)
                            : cafeOscuro,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: cafeOscuro,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.es
                      ? 'Bienvenido a Santa Cruz'
                      : 'Welcome to Santa Cruz',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.es
                      ? 'Administra tu cuenta y tus pedidos'
                      : 'Manage your account and orders',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}