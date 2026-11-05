import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const Color purple = Color(0xFF6C5CFF);
  static const Color yellow = Color(0xFFFFC857);
  static const Color darkPurple = Color(0xFF29264F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: AspectRatio(
              aspectRatio: 0.53,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background utama
                    const ColoredBox(color: Colors.white),

                    // Aksen kuning kanan atas
                    Positioned(
                      top: -32,
                      right: -32,
                      child: _circle(155, yellow),
                    ),

                    // Aksen ungu kiri bawah
                    Positioned(
                      left: -55,
                      bottom: 28,
                      child: _circle(140, purple),
                    ),

                    // Aksen kuning kanan bawah
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

                    // Logo dan teks Niskala
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo Niskala
                            Image.asset(
                              'assets/images/logo_niskala.png',
                              width: 200,
                              height: 170,
                              fit: BoxFit.contain,
                            ),

                            // Nama Niskala
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

                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'Menemukan Potensi yang Belum Terlihat',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: darkPurple,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Petunjuk masuk
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
                  ],
                ),
              ),
            ),
          ),
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
        15, size.height * 0.55,
        size.width * 0.45, size.height * 0.75,
        size.width * 0.55, size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.65, size.height * 0.05,
        size.width * 0.82, size.height * 0.05,
        size.width, 0,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
