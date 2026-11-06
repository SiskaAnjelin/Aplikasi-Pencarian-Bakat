import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'guru/dashboard_guru_page.dart' as guru;
import 'siswa/dashboard_siswa_page.dart';
import 'guru/data_siswa_page.dart';

import 'admin/dashboard_admin_page.dart';
import 'admin/kelola_siswa_page.dart';
import 'admin/kelola_guru_page.dart';
import 'admin/laporan_page.dart';
import 'admin/detail_jadwal_page.dart';

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

        '/dashboard_admin': (context) => const DashboardAdminPage(),
        '/kelola_siswa': (context) => const KelolaSiswaPage(standalone: true),
        '/kelola_guru': (context) => const KelolaGuruPage(standalone: true),
        '/laporan': (context) => const LaporanPage(standalone: true),
        '/detail_jadwal': (context) => const DetailJadwalPage(),
      },
    );
  }
}