import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonOpacity;
  late Animation<double> _registerOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // ===== LOGO =====
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.42, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // ===== TÍTULO =====
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
      ),
    );

    // ===== SUBTÍTULO =====
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.70, curve: Curves.easeOut),
      ),
    );

    // ===== BOTÓN =====
    _buttonScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 0.90, curve: Curves.easeOutBack),
      ),
    );
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );

    // ===== REGISTRO =====
    _registerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut),
      ),
    );

    // Forzar animación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ===== FONDO (mejor centrado) =====
          Image.asset(
            'assets/img/imagen version 2.jpeg',
            fit: BoxFit.cover,

            alignment: const Alignment(0, -0.120),
          ),

          // Oscurecimiento
          Container(
            color: Colors.black.withOpacity(0.30),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ===== LOGO =====
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
                      width: 155,
                      height: 155,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== TÍTULO =====
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleOpacity,
                      child: const Text(
                        'SANTA CRUZ\nDE LA PLAZUELA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== SUBTÍTULO =====
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: const Text(
                      'postres y café',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ===== BOTÓN =====
                  ScaleTransition(
                    scale: _buttonScale,
                    child: FadeTransition(
                      opacity: _buttonOpacity,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/menu');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F0E6),
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Ver productos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== REGISTRO =====
                  FadeTransition(
                    opacity: _registerOpacity,
                    child: TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/registro');
                      },
                      child: const Text(
                        '¿No tienes cuenta? Regístrate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}