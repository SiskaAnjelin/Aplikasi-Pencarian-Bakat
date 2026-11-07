import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() =>
      _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6C5CE7);
    const dark = Color(0xFF2D3436);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFEDE9FF),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: purple,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Admin',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Admin Niskala',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoggingOut ? null : _logout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                    tooltip: 'Logout',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Total Siswa',
                      '4',
                      Icons.people_outline,
                      purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      'Total Guru',
                      '2',
                      Icons.school_outlined,
                      const Color(0xFF00B894),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      'Total Bakat',
                      '15',
                      Icons.star_outline,
                      const Color(0xFFFDCB6E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      'Laporan',
                      '3',
                      Icons.description_outlined,
                      const Color(0xFFE17055),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),

              const SizedBox(height: 12),

              _menuCard(
                icon: Icons.people_rounded,
                title: 'Kelola Siswa',
                subtitle: 'Tambah, edit, hapus data siswa',
                color: purple,
                onTap: () {
                  Navigator.pushNamed(context, '/kelola_siswa');
                },
              ),

              _menuCard(
                icon: Icons.school_rounded,
                title: 'Kelola Guru',
                subtitle: 'Kelola data guru dan bidang keahlian',
                color: const Color(0xFF00B894),
                onTap: () {
                  Navigator.pushNamed(context, '/kelola_guru');
                },
              ),

              _menuCard(
                icon: Icons.bar_chart_rounded,
                title: 'Laporan Data',
                subtitle: 'Lihat dan export laporan bakat',
                color: const Color(0xFFE17055),
                onTap: () {
                  Navigator.pushNamed(context, '/laporan');
                },
              ),

              _menuCard(
                icon: Icons.calendar_month_rounded,
                title: 'Jadwal Kegiatan',
                subtitle: 'Lihat detail jadwal kegiatan',
                color: purple,
                onTap: () {
                  Navigator.pushNamed(context, '/detail_jadwal');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
