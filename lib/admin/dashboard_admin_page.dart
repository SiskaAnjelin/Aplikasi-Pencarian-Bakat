import 'package:flutter/material.dart';
import 'kelola_siswa_page.dart';
import 'kelola_guru_page.dart';
import 'laporan_page.dart';
import 'detail_jadwal_page.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
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

  @override
  Widget build(BuildContext context) {
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, Admin', style: TextStyle(fontSize: 13, color: Color(0xFF636E72))),
                        Text(
                          'Admin Niskala',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
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

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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

  Widget _menuCard(
    BuildContext context, {
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
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF2D3436))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF636E72))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}