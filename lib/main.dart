import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'guru/dashboard_guru_page.dart';
import 'guru/data_siswa_page.dart';

void main() {
  runApp(const NiskalaApp());
}

class NiskalaApp extends StatelessWidget {
  const NiskalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niskala - Aplikasi Pencarian Bakat',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CFF),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const SplashPage(),

      routes: <String, WidgetBuilder>{
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardGuruPage(),
        '/data_siswa': (context) => const DataSiswaPage(),
      },
    );
  }
}