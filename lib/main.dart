import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';

// SISWA
import 'siswa/dashboard_siswa_page.dart';
import 'siswa/daftar_bakat_page.dart' as siswa_daftar;
import 'siswa/detail_bakat_page.dart' as siswa_detail;
import 'siswa/detail_jadwal_page.dart' as siswa_jadwal;
import 'siswa/profil_siswa_page.dart' as siswa_profil;
import 'siswa/tambah_bakat_page.dart';

// GURU
import 'guru/dashboard_guru_page.dart' as guru;
import 'guru/data_siswa_page.dart';
import 'guru/detail_bakat_page.dart' as guru_detail;
import 'guru/penilaian_bakat_page.dart';

// ADMIN
import 'admin/dashboard_admin_page.dart';
import 'admin/detail_jadwal_page.dart' as admin_jadwal;
import 'admin/kelola_siswa_page.dart';
import 'admin/tambah_siswa_page.dart';

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

        // SISWA
        '/dashboard_siswa': (context) =>
            const DashboardSiswaPage(),

        '/daftar_bakat': (context) =>
            const siswa_daftar.DaftarBakatPage(),

        '/detail_bakat': (context) =>
            const siswa_detail.DetailBakatPage(),

        '/tambah_bakat': (context) =>
            const TambahBakatPage(),

        '/detail_jadwal_siswa': (context) =>
            const siswa_jadwal.DetailJadwalPage(),

        '/profil_siswa': (context) =>
            const siswa_profil.ProfilSiswaPage(),

        // GURU
        '/dashboard_guru': (context) =>
            const guru.DashboardGuruPage(),

        '/data_siswa': (context) =>
            const DataSiswaPage(),

        '/detail_bakat_guru': (context) =>
            const guru_detail.DetailBakatGuruPage(),

        '/penilaian_bakat': (context) =>
            const PenilaianBakatPage(),

        // ADMIN
        '/dashboard_admin': (context) =>
            const DashboardAdminPage(),

        '/detail_jadwal': (context) =>
            const admin_jadwal.DetailJadwalPage(),

        '/kelola_siswa': (context) =>
            const KelolaSiswaPage(),

        '/tambah_siswa': (context) =>
            const TambahSiswaPage(),
      },
    );
  }
}