part of '../../admin_perfil_screen.dart';

mixin _PerfilCabecera on State<AdminPerfilScreen>, _PerfilEstado, _PerfilFoto {
  Widget _buildCabecera({
    required String nombre,
    required String email,
    required String rol,
    required ImageProvider? avatar,
  }) {
    return Card(
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
                  radius: 53,
                  backgroundColor: AppColors.cremaOscuro,
                  backgroundImage: avatar,
                  child: avatar == null
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
                  child: IconButton(
                    tooltip: 'Cambiar foto',
                    onPressed: _guardando ? null : _seleccionarFoto,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.textoCafe,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
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
                rol.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textoCafe,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}