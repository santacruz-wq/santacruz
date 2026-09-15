import 'package:flutter/material.dart';

import '../idioma_data.dart';
import 'privacidad_page.dart';

import '../components/configuracion/configuracion_header.dart';
import '../components/configuracion/configuracion_opcion.dart';
import '../components/configuracion/configuracion_switch.dart';
import '../components/configuracion/configuracion_version.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  // ================================================================
  // COLORES
  // ================================================================

  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);
  static const Color dorado = Color(0xFFDDB447);

  // ================================================================
  // VARIABLES
  // ================================================================

  bool notificaciones = true;
  bool modoOscuro = false;

  // ================================================================
  // INICIALIZAR
  // ================================================================

  @override
  void initState() {
    super.initState();
    modoOscuro = IdiomaData.modoOscuro.value;
  }

  // ================================================================
  // TRADUCCIONES
  // ================================================================

  String t(String clave) => IdiomaData.texto(clave);

  // ================================================================
  // MENSAJE
  // ================================================================

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ================================================================
  // SELECCIONAR IDIOMA
  // ================================================================

  void seleccionarIdioma() {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    String idiomaSeleccionado = IdiomaData.idioma.value.languageCode == 'es'
        ? 'Español'
        : 'English';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: modoOscuro
                  ? const Color(0xFF2B211D)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: modoOscuro ? const Color(0xFF3A2B25) : crema,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.language,
                      color: modoOscuro ? dorado : cafe,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t('seleccionar_idioma'),
                      style: TextStyle(
                        color: modoOscuro ? Colors.white : cafeOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'Español',
                    groupValue: idiomaSeleccionado,
                    title: Text(
                      'Español',
                      style: TextStyle(
                        color: modoOscuro ? Colors.white : cafeOscuro,
                      ),
                    ),
                    activeColor: dorado,
                    onChanged: (valor) {
                      setDialogState(() {
                        idiomaSeleccionado = valor!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    value: 'English',
                    groupValue: idiomaSeleccionado,
                    title: Text(
                      'English',
                      style: TextStyle(
                        color: modoOscuro ? Colors.white : cafeOscuro,
                      ),
                    ),
                    activeColor: dorado,
                    onChanged: (valor) {
                      setDialogState(() {
                        idiomaSeleccionado = valor!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    es ? 'Cancelar' : 'Cancel',
                    style: TextStyle(color: modoOscuro ? dorado : cafe),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cafe,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (idiomaSeleccionado == 'Español') {
                      IdiomaData.cambiarIdioma('es');
                    } else {
                      IdiomaData.cambiarIdioma('en');
                    }

                    Navigator.pop(context);

                    mostrarMensaje(
                      idiomaSeleccionado == 'Español'
                          ? 'Idioma cambiado a Español.'
                          : 'Language changed to English.',
                    );

                    setState(() {});
                  },
                  child: Text(es ? 'Guardar' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================================================================
  // PRIVACIDAD
  // ================================================================

  void privacidad() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacidadPage()),
    );
  }

  // ================================================================
  // ACERCA DE
  // ================================================================

  void acercaDe() {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: modoOscuro ? const Color(0xFF2B211D) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: modoOscuro ? const Color(0xFF3A2B25) : crema,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.coffee,
                  color: modoOscuro ? dorado : cafe,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Santa Cruz',
                style: TextStyle(
                  color: modoOscuro ? Colors.white : cafeOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            es
                ? 'Aplicación de productos de repostería y postres.\n\nVersión 1.0.0'
                : 'Bakery and dessert products application.\n\nVersion 1.0.0',
            style: TextStyle(
              color: modoOscuro ? Colors.white : cafeOscuro,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                es ? 'Cerrar' : 'Close',
                style: TextStyle(color: modoOscuro ? dorado : cafe),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // CERRAR SESIÓN
  // ================================================================

  void cerrarSesion() {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: modoOscuro ? const Color(0xFF2B211D) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            es ? 'Cerrar sesión' : 'Log out',
            style: TextStyle(
              color: modoOscuro ? Colors.white : cafeOscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            es
                ? '¿Estás seguro de que deseas cerrar sesión?'
                : 'Are you sure you want to log out?',
            style: TextStyle(color: modoOscuro ? Colors.white : cafeOscuro),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                es ? 'Cancelar' : 'Cancel',
                style: TextStyle(color: modoOscuro ? dorado : cafe),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);

                mostrarMensaje(
                  es
                      ? 'Sesión cerrada correctamente.'
                      : 'Logged out successfully.',
                );
              },
              child: Text(es ? 'Cerrar sesión' : 'Log out'),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: IdiomaData.modoOscuro,
          builder: (context, oscuro, child) {
            final bool es = locale.languageCode == 'es';

            modoOscuro = oscuro;

            final Color fondoActual = modoOscuro
                ? const Color(0xFF1E1714)
                : cremaClara;

            final Color textoPrincipal = modoOscuro ? Colors.white : cafeOscuro;

            return Scaffold(
              backgroundColor: fondoActual,

              // ======================================================
              // APP BAR
              // ======================================================
              appBar: AppBar(
                backgroundColor: fondoActual,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textoPrincipal),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  t('configuracion'),
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),

              // ======================================================
              // BODY
              // ======================================================
              body: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
                children: [
                  // ====================================================
                  // ENCABEZADO
                  // ====================================================
                  ConfiguracionHeader(modoOscuro: modoOscuro, es: es),

                  // ====================================================
                  // PREFERENCIAS
                  // ====================================================
                  Text(
                    es ? 'Preferencias' : 'Preferences',
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ====================================================
                  // NOTIFICACIONES
                  // ====================================================
                  ConfiguracionSwitch(
                    icono: Icons.notifications_outlined,
                    titulo: t('notificaciones'),
                    subtitulo: es
                        ? 'Recibir notificaciones de la aplicación'
                        : 'Receive application notifications',
                    valor: notificaciones,
                    modoOscuro: modoOscuro,
                    onChanged: (valor) {
                      setState(() {
                        notificaciones = valor;
                      });

                      mostrarMensaje(
                        valor
                            ? (es
                                  ? 'Notificaciones activadas.'
                                  : 'Notifications enabled.')
                            : (es
                                  ? 'Notificaciones desactivadas.'
                                  : 'Notifications disabled.'),
                      );
                    },
                  ),

                  // ====================================================
                  // MODO OSCURO
                  // ====================================================
                  ConfiguracionSwitch(
                    icono: Icons.dark_mode_outlined,
                    titulo: t('modo_oscuro'),
                    subtitulo: es
                        ? 'Cambiar la apariencia de la aplicación'
                        : 'Change the appearance of the application',
                    valor: modoOscuro,
                    modoOscuro: modoOscuro,
                    onChanged: (valor) {
                      IdiomaData.cambiarModoOscuro(valor);

                      mostrarMensaje(
                        valor
                            ? (es
                                  ? 'Modo oscuro activado.'
                                  : 'Dark mode enabled.')
                            : (es
                                  ? 'Modo oscuro desactivado.'
                                  : 'Dark mode disabled.'),
                      );
                    },
                  ),

                  // ====================================================
                  // IDIOMA
                  // ====================================================
                  ConfiguracionOpcion(
                    icono: Icons.language,
                    titulo: t('idioma'),
                    subtitulo: es
                        ? 'Seleccionar idioma de la aplicación'
                        : 'Select application language',
                    modoOscuro: modoOscuro,
                    onTap: seleccionarIdioma,
                  ),

                  const SizedBox(height: 14),

                  // ====================================================
                  // INFORMACIÓN
                  // ====================================================
                  Text(
                    es ? 'Información' : 'Information',
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ====================================================
                  // PRIVACIDAD
                  // ====================================================
                  ConfiguracionOpcion(
                    icono: Icons.privacy_tip_outlined,
                    titulo: es ? 'Privacidad' : 'Privacy',
                    subtitulo: es
                        ? 'Información sobre privacidad y datos'
                        : 'Information about privacy and data',
                    modoOscuro: modoOscuro,
                    onTap: privacidad,
                  ),

                  // ====================================================
                  // ACERCA DE
                  // ====================================================
                  ConfiguracionOpcion(
                    icono: Icons.info_outline,
                    titulo: es ? 'Acerca de' : 'About',
                    subtitulo: es
                        ? 'Información sobre Santa Cruz'
                        : 'Information about Santa Cruz',
                    modoOscuro: modoOscuro,
                    onTap: acercaDe,
                  ),

                  const SizedBox(height: 6),

                  // ====================================================
                  // CERRAR SESIÓN
                  // ====================================================
                  Card(
                    elevation: 0,
                    color: modoOscuro ? const Color(0xFF2B211D) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: cerrarSesion,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    es ? 'Cerrar sesión' : 'Log out',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    es
                                        ? 'Salir de tu cuenta'
                                        : 'Sign out of your account',
                                    style: TextStyle(
                                      color: modoOscuro
                                          ? Colors.white70
                                          : Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.chevron_right,
                              color: Colors.red.withValues(alpha: 0.65),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ====================================================
                  // VERSIÓN
                  // ====================================================
                  const ConfiguracionVersion(),

                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
