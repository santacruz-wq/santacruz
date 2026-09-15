
import 'package:flutter/material.dart';

import '../idioma_data.dart';

import '../components/privacidad/privacidad_hearder.dart';
import '../components/privacidad/privacidad_opcion.dart';
import '../components/privacidad/privacidad_footer.dart';

class PrivacidadPage extends StatefulWidget {
  const PrivacidadPage({super.key});

  @override
  State<PrivacidadPage> createState() => _PrivacidadPageState();
}

class _PrivacidadPageState extends State<PrivacidadPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  late Animation<double> _opacidad;
  late Animation<Offset> _deslizamiento;

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);
  static const Color dorado = Color(0xFFDDB447);

  bool compartirDatos = false;
  bool mostrarTelefono = false;
  bool permitirUbicacion = true;

  Color get fondoActual =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF2A211D)
          : cremaClara;

  Color get tarjetaActual =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF3A2D27)
          : Colors.white;

  Color get textoPrincipal =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFFFFF8E7)
          : cafeOscuro;

  Color get textoSecundario =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFFE0D2C8)
          : Colors.black54;

  Color get iconoFondo =>
      IdiomaData.modoOscuro.value
          ? const Color(0xFF4A3931)
          : crema;

  @override
  void initState() {
    super.initState();

    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _opacidad = CurvedAnimation(
      parent: _controlador,
      curve: Curves.easeOut,
    );

    _deslizamiento = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controlador,
        curve: Curves.easeOutCubic,
      ),
    );

    _controlador.forward();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void mostrarPoliticaPrivacidad() {
    showDialog(
      context: context,
      builder: (context) {
        final bool oscuro = IdiomaData.modoOscuro.value;

        return AlertDialog(
          backgroundColor:
              oscuro ? const Color(0xFF2B211D) : Colors.white,
          title: Text(
            IdiomaData.texto('politica_privacidad'),
            style: TextStyle(
              color: oscuro ? Colors.white : cafeOscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              IdiomaData.texto('politica_privacidad_texto'),
              style: TextStyle(
                color: oscuro ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                IdiomaData.texto('cerrar'),
                style: const TextStyle(
                  color: dorado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void eliminarDatos() {
    showDialog(
      context: context,
      builder: (context) {
        final bool oscuro = IdiomaData.modoOscuro.value;

        return AlertDialog(
          backgroundColor:
              oscuro ? const Color(0xFF2B211D) : Colors.white,
          title: Text(
            IdiomaData.texto('eliminar_datos'),
            style: TextStyle(
              color: oscuro ? Colors.white : cafeOscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            IdiomaData.texto('eliminar_datos_texto'),
            style: TextStyle(
              color: oscuro ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                IdiomaData.texto('cancelar'),
                style: TextStyle(
                  color: oscuro ? Colors.white70 : cafeClaro,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      IdiomaData.texto('datos_eliminados'),
                    ),
                    backgroundColor: cafe,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dorado,
                foregroundColor: cafeOscuro,
              ),
              child: Text(
                IdiomaData.texto('eliminar'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: IdiomaData.modoOscuro,
      builder: (context, oscuro, child) {
        return ValueListenableBuilder<Locale>(
          valueListenable: IdiomaData.idioma,
          builder: (context, locale, child) {
            return Scaffold(
              backgroundColor: fondoActual,
              appBar: AppBar(
                backgroundColor:
                    oscuro ? const Color(0xFF2B211D) : cremaClara,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: textoPrincipal,
                ),
                title: Text(
                  IdiomaData.texto('privacidad'),
                  style: TextStyle(
                    color: textoPrincipal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: FadeTransition(
                opacity: _opacidad,
                child: SlideTransition(
                  position: _deslizamiento,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      18,
                      18,
                      25,
                    ),
                    children: [
                      PrivacidadHeader(
                        oscuro: oscuro,
                      ),

                      const SizedBox(height: 18),

                      // COMPARTIR DATOS
                      PrivacidadOpcion(
                        icono: Icons.share,
                        titulo:
                            IdiomaData.texto('compartir_datos'),
                        descripcion: IdiomaData.texto(
                          'compartir_datos_descripcion',
                        ),
                        trailing: Switch(
                          value: compartirDatos,
                          activeColor: dorado,
                          onChanged: (valor) {
                            setState(() {
                              compartirDatos = valor;
                            });
                          },
                        ),
                        oscuro: oscuro,
                        tarjeta: tarjetaActual,
                        iconoFondo: iconoFondo,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                        cafe: cafe,
                        dorado: dorado,
                      ),

                      // MOSTRAR TELEFONO
                      PrivacidadOpcion(
                        icono: Icons.phone,
                        titulo:
                            IdiomaData.texto('mostrar_telefono'),
                        descripcion: IdiomaData.texto(
                          'mostrar_telefono_descripcion',
                        ),
                        trailing: Switch(
                          value: mostrarTelefono,
                          activeColor: dorado,
                          onChanged: (valor) {
                            setState(() {
                              mostrarTelefono = valor;
                            });
                          },
                        ),
                        oscuro: oscuro,
                        tarjeta: tarjetaActual,
                        iconoFondo: iconoFondo,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                        cafe: cafe,
                        dorado: dorado,
                      ),

                      // PERMITIR UBICACION
                      PrivacidadOpcion(
                        icono: Icons.location_on,
                        titulo:
                            IdiomaData.texto('permitir_ubicacion'),
                        descripcion: IdiomaData.texto(
                          'permitir_ubicacion_descripcion',
                        ),
                        trailing: Switch(
                          value: permitirUbicacion,
                          activeColor: dorado,
                          onChanged: (valor) {
                            setState(() {
                              permitirUbicacion = valor;
                            });
                          },
                        ),
                        oscuro: oscuro,
                        tarjeta: tarjetaActual,
                        iconoFondo: iconoFondo,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                        cafe: cafe,
                        dorado: dorado,
                      ),

                      const SizedBox(height: 6),

                      // POLITICA DE PRIVACIDAD
                      PrivacidadOpcion(
                        icono: Icons.policy,
                        titulo: IdiomaData.texto(
                          'politica_privacidad',
                        ),
                        descripcion: IdiomaData.texto(
                          'ver_politica_privacidad',
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: textoSecundario,
                        ),
                        onTap: mostrarPoliticaPrivacidad,
                        oscuro: oscuro,
                        tarjeta: tarjetaActual,
                        iconoFondo: iconoFondo,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                        cafe: cafe,
                        dorado: dorado,
                      ),

                      // ELIMINAR DATOS
                      PrivacidadOpcion(
                        icono: Icons.delete_outline,
                        titulo: IdiomaData.texto(
                          'eliminar_datos',
                        ),
                        descripcion: IdiomaData.texto(
                          'eliminar_datos_descripcion',
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: textoSecundario,
                        ),
                        onTap: eliminarDatos,
                        oscuro: oscuro,
                        tarjeta: tarjetaActual,
                        iconoFondo: iconoFondo,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                        cafe: cafe,
                        dorado: dorado,
                      ),

                      const SizedBox(height: 18),

                      PrivacidadFooter(
                        oscuro: oscuro,
                        cafeClaro: cafeClaro,
                        cafe: cafe,
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


