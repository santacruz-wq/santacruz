
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/user_model.dart';
import 'perfil_seccion.dart';

class PerfilCabecera extends StatelessWidget {
  final UserModel usuario;
  final String? avatarUrl;
  final File? imagenSeleccionada;
  final TextEditingController nombreController;
  final bool guardando;
  final bool editandoNombre;
  final VoidCallback onSeleccionarFoto;
  final VoidCallback onGuardarNombre;
  final VoidCallback onAlternarEdicion;

  const PerfilCabecera({
    super.key,
    required this.usuario,
    required this.avatarUrl,
    required this.imagenSeleccionada,
    required this.nombreController,
    required this.guardando,
    required this.editandoNombre,
    required this.onSeleccionarFoto,
    required this.onGuardarNombre,
    required this.onAlternarEdicion,
  });

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.cremaClaro,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    key: ValueKey(
                      '${usuario.avatar ?? ''}_${imagenSeleccionada?.path ?? ''}',
                    ),
                    radius: 53,
                    backgroundColor: AppColors.cremaOscuro,
                    backgroundImage: imagenSeleccionada != null
                        ? FileImage(imagenSeleccionada!)
                        : avatarUrl == null
                            ? null
                            : NetworkImage(avatarUrl!) as ImageProvider,
                    child: imagenSeleccionada == null && avatarUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 58,
                            color: AppColors.cafeMedio,
                          )
                        : null,
                  ),
                  Material(
                    color: AppColors.caramelo,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: guardando ? null : onSeleccionarFoto,
                      child: const Padding(
                        padding: EdgeInsets.all(9),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                usuario.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                usuario.email,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.cafeMedio),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.carameloClaro.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  usuario.rol.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              PerfilBoton(
                texto: 'Cambiar foto de perfil',
                icono: Icons.photo_camera_outlined,
                accion: onSeleccionarFoto,
                deshabilitado: guardando,
              ),
              PerfilBoton(
                texto: editandoNombre
                    ? 'Cancelar edición'
                    : 'Editar nombre',
                icono: editandoNombre
                    ? Icons.close
                    : Icons.edit_outlined,
                accion: onAlternarEdicion,
                deshabilitado: guardando,
              ),
              if (editandoNombre) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: nombreController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: guardando ? null : onGuardarNombre,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar nombre'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.caramelo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
              if (guardando) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  color: AppColors.caramelo,
                ),
              ],
            ],
          ),
        ),
      );
}
