import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color yellow = Color(0xFFFFC857);
  static const Color darkPurple = Color(0xFF29264F);

  bool _isPressed = false;

  void _openLogin() async {
    if (_isPressed) return;

    setState(() {
      _isPressed = true;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: _openLogin,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // BACKGROUND
                      const ColoredBox(
                        color: Colors.white,
                      ),

                      // AKSEN KUNING KANAN ATAS
                      Positioned(
                        top: -32,
                        right: -32,
                        child: _circle(155, yellow),
                      ),

                      // AKSEN UNGU KIRI BAWAH
                      Positioned(
                        left: -55,
                        bottom: 28,
                        child: _circle(140, purple),
                      ),

                      // AKSEN KUNING KANAN BAWAH
                      Positioned(
                        right: -20,
                        bottom: -10,
                        child: ClipPath(
                          clipper: BottomWaveClipper(),
                          child: Container(
                            width: 160,
                            height: 125,
                            color: yellow,
                          ),
                        ),
                      ),

                      // LOGO DAN TEKS
                      Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 30,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo_niskala.png',
                                  width: 200,
                                  height: 170,
                                  fit: BoxFit.contain,
                                ),

                                Transform.translate(
                                  offset: const Offset(0, -12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Niskala',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.6,
                                          color: darkPurple,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      const Text(
                                        'Menemukan Potensi yang Belum Terlihat',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: darkPurple,
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      const Text(
                                        'Klik Disini Untuk Masuk',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // EFEK GELAP TRANSPARAN
                      IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          color: Colors.black.withOpacity(
                            _isPressed ? 0.0 : 0.13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..cubicTo(
        15,
        size.height * 0.55,
        size.width * 0.45,
        size.height * 0.75,
        size.width * 0.55,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.05,
        size.width * 0.82,
        size.height * 0.05,
        size.width,
        0,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}