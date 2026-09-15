import 'package:flutter/material.dart';
import '../components/direcciones/direccion_card.dart';
import '../components/direcciones/estado_vacio_direcciones.dart';
class DireccionesPage extends StatefulWidget {
  const DireccionesPage({super.key});

  @override
  State<DireccionesPage> createState() => _DireccionesPageState();
}

class _DireccionesPageState extends State<DireccionesPage> {
  // COLORES
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6D4C41);
  static const Color crema = Color(0xFFFFF8E7);
  static const Color fondo = Color(0xFFF8F3EA);
  static const Color dorado = Color(0xFFC49A3A);

  final List<Map<String, String>> direcciones = [];

  // ============================================================
  // AGREGAR DIRECCIÓN
  // ============================================================

  void agregarDireccion() {
    final direccionController = TextEditingController();
    final barrioController = TextEditingController();
    final referenciaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: crema,

          title: const Text(
            'Agregar dirección',
            style: TextStyle(color: cafeOscuro, fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    hintText: 'Ej: Calle 10 # 5-20',
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: cafe,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: barrioController,
                  decoration: InputDecoration(
                    labelText: 'Barrio',
                    hintText: 'Ej: Centro',
                    prefixIcon: const Icon(Icons.home_outlined, color: cafe),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: referenciaController,
                  decoration: InputDecoration(
                    labelText: 'Referencia',
                    hintText: 'Ej: Casa blanca, puerta café',
                    prefixIcon: const Icon(Icons.info_outline, color: cafe),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
              child: const Text('CANCELAR', style: TextStyle(color: cafe)),
            ),

            ElevatedButton(
              onPressed: () {
                if (direccionController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  direcciones.add({
                    'direccion': direccionController.text.trim(),
                    'barrio': barrioController.text.trim(),
                    'referencia': referenciaController.text.trim(),
                  });
                });

                Navigator.pop(context);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 99, 91),
                foregroundColor: Colors.white,
              ),

              child: const Text('GUARDAR'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ELIMINAR DIRECCIÓN
  // ============================================================

  void eliminarDireccion(int index) {
    setState(() {
      direcciones.removeAt(index);
    });
  }

  // ============================================================
  // EDITAR DIRECCIÓN
  // ============================================================

  void editarDireccion(int index) {
    final direccionController = TextEditingController(
      text: direcciones[index]['direccion'],
    );

    final barrioController = TextEditingController(
      text: direcciones[index]['barrio'],
    );

    final referenciaController = TextEditingController(
      text: direcciones[index]['referencia'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: crema,

          title: const Text(
            'Editar dirección',
            style: TextStyle(color: cafeOscuro, fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: cafe,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: barrioController,
                  decoration: InputDecoration(
                    labelText: 'Barrio',
                    prefixIcon: const Icon(Icons.home_outlined, color: cafe),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: referenciaController,
                  decoration: InputDecoration(
                    labelText: 'Referencia',
                    prefixIcon: const Icon(Icons.info_outline, color: cafe),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
              child: const Text('CANCELAR', style: TextStyle(color: cafe)),
            ),

            ElevatedButton(
              onPressed: () {
                if (direccionController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  direcciones[index] = {
                    'direccion': direccionController.text.trim(),
                    'barrio': barrioController.text.trim(),
                    'referencia': referenciaController.text.trim(),
                  };
                });

                Navigator.pop(context);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
              ),

              child: const Text('GUARDAR CAMBIOS'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: cafe,
        foregroundColor: Colors.white,
        title: const Text(
          'Mis direcciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: agregarDireccion,
        backgroundColor: cafe,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      body: direcciones.isEmpty
          ? EstadoVacioDirecciones(
  onAgregar: agregarDireccion,
)
          : ListView.builder(
              padding: const EdgeInsets.all(18),

              itemCount: direcciones.length,

              itemBuilder: (context, index) {
                final direccion = direcciones[index];
               
               return DireccionCard(
  direccion: direccion,
  onEditar: () => editarDireccion(index),
  onEliminar: () => eliminarDireccion(index),
);
              },
            ),
    );
  }
}
