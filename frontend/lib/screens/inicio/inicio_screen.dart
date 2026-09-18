import 'package:flutter/material.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/link_button.dart';
import '../../widgets/inicio/animate_logo.dart';
import '../../widgets/inicio/animate_title.dart';

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

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.70, curve: Curves.easeOut),
      ),
    );

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

    _registerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward(from: 0.0);
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
          Image.asset(
            'assets/img/imagen_version_2.jpeg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.120),
          ),
          Container(color: Colors.black.withOpacity(0.30)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AnimatedLogo(
                    assetPath:
                        'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
                    scaleAnimation: _logoScale,
                    opacityAnimation: _logoOpacity,
                  ),
                  const SizedBox(height: 30),
                  AnimatedTitle(
                    title: 'SANTA CRUZ\nDE LA PLAZUELA',
                    subtitle: 'postres y café',
                    titleSlide: _titleSlide,
                    titleOpacity: _titleOpacity,
                    subtitleOpacity: _subtitleOpacity,
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Ver productos',
                    onPressed: () {
                      Navigator.pushNamed(context, '/language-selection');
                    },
                    scaleAnimation: _buttonScale,
                    opacityAnimation: _buttonOpacity,
                  ),
                  const SizedBox(height: 16),
                  FadeLinkButton(
                    text: '¿No tienes cuenta? Regístrate',
                    onPressed: () {
                      // Navigator.pushNamed(context, '/registro');
                    },
                    opacityAnimation: _registerOpacity,
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