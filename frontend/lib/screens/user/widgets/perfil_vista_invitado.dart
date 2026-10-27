import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/navigation/menu_navigation.dart';
import '../../../providers/language_provider.dart';
import '../../../widgets/global/bottom_menu.dart';

class PerfilVistaInvitado extends StatelessWidget {
  final bool showBottomBar;

  const PerfilVistaInvitado({
    super.key,
    required this.showBottomBar,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: Text(
          lang.t('mi_perfil'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.crema,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.cremaOscuro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.cafeMedio,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lang.t('inicia_sesion_perfil'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.t('consulta_datos_favoritos'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.cafeMedio,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login),
                  label: Text(lang.t('iniciar_sesion')),
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
          ),
        ),
      ),
      bottomNavigationBar: showBottomBar
          ? BottomMenu(
              currentIndex: 2,
              onItemSelected: (i) => navegarDesdeMenu(context, i, 2),
            )
          : null,
    );
  }
}