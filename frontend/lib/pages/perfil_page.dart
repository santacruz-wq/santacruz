import 'package:flutter/material.dart';
import '../favoritos_data.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // COLORES DEL PERFIL
  static const Color cafe = Color(0xFF6D4C41);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color crema = Color(0xFFFFF8E7);
  static const Color dorado = Color(0xFFC49A3A);
  static const Color fondo = Color(0xFFF8F3EA);

  String nombre = 'Mi usuario';
  String correo = 'usuario@santacruz.com';
  String telefono = '300 000 0000';

  // ==========================================
  // EDITAR PERFIL
  // ==========================================
  void editarPerfil() {
    final nombreController = TextEditingController(text: nombre);

    final correoController = TextEditingController(text: correo);

    final telefonoController = TextEditingController(text: telefono);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Editar perfil',
            style: TextStyle(fontWeight: FontWeight.bold, color: cafeOscuro),
          ),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: const Icon(Icons.person_outline, color: cafe),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: cafe, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email_outlined, color: cafe),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: cafe, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: const Icon(Icons.phone_outlined, color: cafe),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: cafe, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  nombre = nombreController.text.trim();

                  correo = correoController.text.trim();

                  telefono = telefonoController.text.trim();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil actualizado correctamente'),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
              ),

              child: const Text('GUARDAR'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // CERRAR SESIÓN
  // ==========================================
  void cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(fontWeight: FontWeight.bold, color: cafeOscuro),
          ),

          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('CERRAR SESIÓN'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // OPCIÓN DEL PERFIL
  // ==========================================
  Widget opcionPerfil({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

      leading: Container(
        width: 45,
        height: 45,

        decoration: BoxDecoration(
          color: crema,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Icon(icono, color: cafe),
      ),

      title: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: cafeOscuro,
        ),
      ),

      subtitle: Text(
        subtitulo,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),

      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 17, color: Colors.grey),

      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cantidadFavoritos = FavoritosData.favoritos.length;

    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        backgroundColor: cafeOscuro,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            // ======================================
            // ENCABEZADO
            // ======================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [cafeOscuro, cafe, Color(0xFF8D6E63)],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(22),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),

                    blurRadius: 12,

                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                children: [
                  // FOTO
                  Container(
                    width: 105,
                    height: 105,

                    decoration: BoxDecoration(
                      color: crema,
                      shape: BoxShape.circle,

                      border: Border.all(color: dorado, width: 4),
                    ),

                    child: const Icon(Icons.person, size: 65, color: cafe),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    correo,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 15),

                  // EDITAR
                  OutlinedButton.icon(
                    onPressed: editarPerfil,

                    icon: const Icon(Icons.edit, size: 18),

                    label: const Text('Editar perfil'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,

                      side: const BorderSide(color: Colors.white),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // INFORMACIÓN PERSONAL
            // ======================================
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Información personal',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: cafeOscuro,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 2,

              color: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  opcionPerfil(
                    icono: Icons.person_outline,
                    titulo: 'Nombre',
                    subtitulo: nombre,
                    onTap: editarPerfil,
                  ),

                  const Divider(height: 1),

                  opcionPerfil(
                    icono: Icons.email_outlined,
                    titulo: 'Correo electrónico',
                    subtitulo: correo,
                    onTap: editarPerfil,
                  ),

                  const Divider(height: 1),

                  opcionPerfil(
                    icono: Icons.phone_outlined,
                    titulo: 'Teléfono',
                    subtitulo: telefono,
                    onTap: editarPerfil,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // MI CUENTA
            // ======================================
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Mi cuenta',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: cafeOscuro,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 2,

              color: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  opcionPerfil(
                    icono: Icons.shopping_bag_outlined,
                    titulo: 'Mis pedidos',
                    subtitulo: 'Consulta tus pedidos',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sección de pedidos próximamente'),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  opcionPerfil(
                    icono: Icons.favorite_outline,
                    titulo: 'Mis favoritos',
                    subtitulo: '$cantidadFavoritos productos guardados',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tienes $cantidadFavoritos favoritos'),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  opcionPerfil(
                    icono: Icons.location_on_outlined,
                    titulo: 'Mis direcciones',
                    subtitulo: 'Gestiona tus direcciones',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sección de direcciones próximamente'),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  opcionPerfil(
                    icono: Icons.settings_outlined,
                    titulo: 'Configuración',
                    subtitulo: 'Personaliza la aplicación',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuración próximamente'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ======================================
            // CERRAR SESIÓN
            // ======================================
            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton.icon(
                onPressed: cerrarSesion,

                icon: const Icon(Icons.logout, color: Colors.red),

                label: const Text(
                  'CERRAR SESIÓN',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // VERSIÓN
            // ======================================
            const Text(
              'Santa Cruz • Versión 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
