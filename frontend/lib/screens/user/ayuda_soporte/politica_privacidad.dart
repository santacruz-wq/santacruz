
import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class PoliticaPrivacidadScreen extends StatelessWidget {
  const PoliticaPrivacidadScreen({super.key});

  final List<Map<String, String>> secciones = const [
    {
      'titulo': '1. Información que recopilamos',
      'contenido':
          'La aplicación puede recopilar información proporcionada durante el registro, como nombre, correo electrónico y datos necesarios para gestionar la cuenta.'
    },
    {
      'titulo': '2. Uso de la información',
      'contenido':
          'La información se utiliza para administrar las cuentas, gestionar pedidos, ofrecer las funciones de la aplicación y mejorar la atención al cliente.'
    },
    {
      'titulo': '3. Protección de los datos',
      'contenido':
          'Se aplican mecanismos de seguridad para proteger la información y evitar accesos no autorizados.'
    },
    {
      'titulo': '4. Servicios de terceros',
      'contenido':
          'La aplicación puede utilizar servicios externos para el almacenamiento de imágenes, autenticación, traducción de idiomas y funcionamiento de sus servicios.'
    },
    {
      'titulo': '5. Conservación de la información',
      'contenido':
          'Los datos se conservan durante el tiempo necesario para cumplir las finalidades del servicio y las obligaciones legales aplicables.'
    },
    {
      'titulo': '6. Derechos de los usuarios',
      'contenido':
          'Los usuarios pueden solicitar información sobre sus datos personales, así como su actualización, corrección o eliminación cuando corresponda, conforme a la legislación aplicable.'
    },
    {
      'titulo': '7. Actualizaciones de la política',
      'contenido':
          'Esta política puede actualizarse cuando se realicen cambios en la aplicación o en el tratamiento de la información.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text('Política de privacidad'),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(
            Icons.privacy_tip_outlined,
            color: AppColors.cafeMedio,
            size: 45,
          ),
          const SizedBox(height: 12),
          const Text(
            'Política de privacidad',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: AppColors.textoCafe,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'En Santa Cruz de la Plazuela nos comprometemos a tratar la información personal de los usuarios de manera responsable y conforme a la normativa aplicable.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: AppColors.cafeMedio,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ...secciones.map((seccion) {
            return Card(
              color: AppColors.cremaClaro,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(
                  seccion['titulo']!,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                iconColor: AppColors.cafeMedio,
                collapsedIconColor: AppColors.cafeMedio,
                childrenPadding: const EdgeInsets.fromLTRB(
                  16, 0, 16, 16,
                ),
                children: [
                  Text(
                    seccion['contenido']!,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: AppColors.cafeMedio,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Text(
            'Santa Cruz de la Plazuela\nPostres y café',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.cafeMedio,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
