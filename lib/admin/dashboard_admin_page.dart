<<<<<<< HEAD

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

=======
import 'package:flutter/material.dart';
import 'kelola_siswa_page.dart';
import 'kelola_guru_page.dart';
import 'laporan_page.dart';
import 'detail_jadwal_page.dart';

>>>>>>> origin/main
class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
<<<<<<< HEAD
  static const Color primaryPurple = Color(0xFF6C5CFF);
  static const Color lightGreyBg = Color(0xFFF0F2F5);
  static const Color cardGreyBg = Color(0xFFEFF1F4);
  static const Color textDark = Color(0xFF29264F);
=======
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _AdminHomeTab(),
      const KelolaSiswaPage(),
      const KelolaGuruPage(),
      const LaporanPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: const Color(0xFFB2BEC3),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Siswa'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Guru'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Laporan'),
        ],
      ),
    );
  }
}

class _AdminHomeTab extends StatelessWidget {
  const _AdminHomeTab();
>>>>>>> origin/main

  bool _isLoggingOut = false;

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
<<<<<<< HEAD
        child: Center(
          child: Container(
            width: 320,
            height: 680,
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header / App Bar Custom
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        color: primaryPurple,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Admin OSIS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  _isLoggingOut ? null : _logout,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              tooltip: 'Logout',
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Banner Welcome
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: cardGreyBg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    'Halo, Admin OSIS',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: textDark,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'kelola data penampilan dengan mudah',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Grid Stats 2x2
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    Icons.emoji_events,
                                    'Total Peserta',
                                    '45',
                                    Colors.yellow,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    Icons.person_search,
                                    'Guru Juri',
                                    '7',
                                    Colors.yellow,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    Icons.edit_calendar,
                                    'Jadwal Tampil',
                                    '9',
                                    Colors.yellow,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    Icons.school,
                                    'Kelas & Jurusan',
                                    '12',
                                    Colors.yellow,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Menu Buttons
                           _buildMenuButton(
  icon: Icons.person,
  title: 'Kelola Data Siswa',
  showArrow: true,
  onTap: () {
    Navigator.pushNamed(
      context,
      '/data_siswa',
    );
  },
),

                            const SizedBox(height: 10),

                            _buildMenuButton(
                              icon: Icons.person_outline,
                              title: 'Kelola Guru Juri',
                              showArrow: true,
                              onTap: () {},
                            ),

                            const SizedBox(height: 10),

                            _buildMenuButton(
                              icon: Icons.calendar_month_outlined,
                              title: 'Kelola Jadwal Penampilan',
                              showArrow: true,
                              onTap: () {},
                            ),

                            const SizedBox(height: 10),

                            _buildMenuButton(
                              icon: Icons.search,
                              title: 'Lihat Semua Data',
                              showArrow: true,
                              onTap: () {},
                            ),

                            const SizedBox(height: 70),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
=======
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFE17055).withOpacity(0.15),
                    child: const Text(
                      'A',
                      style: TextStyle(
                        color: Color(0xFFE17055),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
>>>>>>> origin/main
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        _buildNavItem(
                          Icons.home_outlined,
                          'Beranda',
                          primaryPurple,
                          true,
                          () {},
                        ),
                        _buildNavItem(
                          Icons.menu_book_outlined,
                          'Data',
                          Colors.grey,
                          false,
                          () {},
                        ),
                        _buildNavItem(
                          Icons.calendar_month_outlined,
                          'Jadwal',
                          Colors.grey,
                          false,
                          () {},
=======
                        Text('Halo, Admin', style: TextStyle(fontSize: 13, color: Color(0xFF636E72))),
                        Text(
                          'Admin Niskala',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
>>>>>>> origin/main
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _statCard('Total Siswa', '4', Icons.people_outline, const Color(0xFF6C5CE7))),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Total Guru', '2', Icons.school_outlined, const Color(0xFF00B894))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _statCard('Total Bakat', '15', Icons.star_outline, const Color(0xFFFDCB6E))),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Laporan', '3', Icons.description_outlined, const Color(0xFFE17055))),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Menu Cepat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
              ),
              const SizedBox(height: 12),
              _menuCard(
                context,
                icon: Icons.people_rounded,
                title: 'Kelola Siswa',
                subtitle: 'Tambah, edit, hapus data siswa',
                color: const Color(0xFF6C5CE7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KelolaSiswaPage(standalone: true)),
                  );
                },
              ),
              _menuCard(
                context,
                icon: Icons.school_rounded,
                title: 'Kelola Guru',
                subtitle: 'Kelola data guru & bidang keahlian',
                color: const Color(0xFF00B894),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KelolaGuruPage(standalone: true)),
                  );
                },
              ),
              _menuCard(
                context,
                icon: Icons.bar_chart_rounded,
                title: 'Laporan Data',
                subtitle: 'Lihat & export laporan bakat',
                color: const Color(0xFFE17055),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LaporanPage(standalone: true)),
                  );
                },
              ),
              _menuCard(
                context,
                icon: Icons.calendar_month_rounded,
                title: 'Jadwal Kegiatan',
                subtitle: 'Lihat detail jadwal',
                color: const Color(0xFF6C5CE7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DetailJadwalPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  // Widget Kartu Statistik
  Widget _buildStatCard(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
=======
  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
>>>>>>> origin/main
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
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
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF636E72))),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // Widget Tombol Menu
  Widget _buildMenuButton({
=======
  Widget _menuCard(
    BuildContext context, {
>>>>>>> origin/main
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
<<<<<<< HEAD
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: textDark.withValues(alpha: 0.4),
            width: 1.2,
          ),
=======
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
>>>>>>> origin/main
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF2D3436))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF636E72))),
                ],
              ),
            ),
<<<<<<< HEAD
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: textDark,
              ),
=======
            Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.6)),
>>>>>>> origin/main
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

  // Widget Item Navigation Bar
  Widget _buildNavItem(
    IconData icon,
    String label,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
=======
}
>>>>>>> origin/main
