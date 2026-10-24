part of '../../admin_perfil_screen.dart';

mixin _PerfilFoto on State<AdminPerfilScreen>, _PerfilEstado, _PerfilUtils {
  Future<void> _seleccionarFoto() async {
    try {
      final origen = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Seleccionar foto de perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Tomar foto'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Elegir de galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (origen == null || !mounted) return;

      final picker = ImagePicker();
      final imagen = await picker.pickImage(
        source: origen,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (imagen == null || !mounted) return;

      setState(() {
        _imagenSeleccionada = File(imagen.path);
        _guardando = true;
      });

      final data = await PerfilService.actualizarAvatar(
        _imagenSeleccionada!,
      );

      final usuario = data['usuario'];

      if (usuario is Map<String, dynamic> && mounted) {
        setState(() {
          _usuario = usuario;
          _imagenSeleccionada = null;
        });
      }

      if (mounted) {
        _mostrarMensaje(
          data['message']?.toString() ??
              'Foto de perfil actualizada.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _imagenSeleccionada = null);
        _mostrarMensaje(_limpiarError(e), esError: true);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  String _urlAvatar(String avatar) {
    final base = ApiConfig.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return '$base$avatar';
  }

  ImageProvider? _imagenPerfil() {
    if (_imagenSeleccionada != null) {
      return FileImage(_imagenSeleccionada!);
    }

    final avatar = _usuario?['avatar']?.toString() ?? '';

    if (avatar.isEmpty) return null;

    return NetworkImage(_urlAvatar(avatar));
  }
}