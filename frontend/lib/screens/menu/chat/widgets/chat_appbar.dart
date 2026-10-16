part of '../../chat_screen.dart';

mixin _ChatAppBar on State<ChatScreen> {
  AppBar _buildAppBar(String titulo) {
    return AppBar(
      backgroundColor: AppColors.crema,
      foregroundColor: AppColors.textoCafe,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.local_cafe_rounded,
                  color: AppColors.cafeMedio,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Santa Cruz de la Plazuela',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.cafeMedio,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}