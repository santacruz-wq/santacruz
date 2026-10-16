part of '../../admin_perfil_screen.dart';

mixin _PerfilComponentes on State<AdminPerfilScreen> {
  Widget _campo({
    required String etiqueta,
    required TextEditingController controller,
    required IconData icono,
    bool soloLectura = false,
    bool password = false,
    bool ocultarPassword = false,
    VoidCallback? cambiarVisibilidad,
    TextInputType? teclado,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: soloLectura,
        obscureText: password && ocultarPassword,
        keyboardType: teclado,
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: Icon(icono, color: AppColors.cafeMedio),
          suffixIcon: password
              ? IconButton(
                  onPressed: cambiarVisibilidad,
                  icon: Icon(
                    ocultarPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.cremaOscuro),
          ),
        ),
      ),
    );
  }

  Widget _seccion({
    required String titulo,
    required IconData icono,
    required Widget contenido,
  }) {
    return Card(
      color: AppColors.cremaClaro,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: AppColors.caramelo, size: 25),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoCafe,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            contenido,
          ],
        ),
      ),
    );
  }
}