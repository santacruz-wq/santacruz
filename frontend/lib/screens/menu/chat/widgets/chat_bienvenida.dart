part of '../../chat_screen.dart';

mixin _ChatBienvenida on State<ChatScreen> {
  Widget _buildBienvenida({
    required String bienvenida,
    required String titulo,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cremaClaro.withValues(
              alpha: 0.94,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.cremaOscuro,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cremaOscuro,
                  ),
                ),
                child: Image.asset(
                  'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_cafe_rounded,
                    size: 45,
                    color: AppColors.caramelo,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                bienvenida,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textoCafe,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: TextStyle(
                  color: AppColors.cafeMedio,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}