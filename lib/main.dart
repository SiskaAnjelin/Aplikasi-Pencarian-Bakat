import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'guru/dashboard_guru_page.dart' as guru;
import 'siswa/dashboard_siswa_page.dart';
import 'guru/data_siswa_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cegepyuqjdzqrjfpjavz.supabase.co',
    anonKey: 'sb_publishable_GxKryo3tQ-maRVb6Pm83Vg_lGv40ARA',
  );

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

      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard_guru': (context) => const guru.DashboardGuruPage(),
        '/dashboard_siswa': (context) => const DashboardSiswaPage(),
        '/data_siswa': (context) => const DataSiswaPage(),
      },
    );
  }
}