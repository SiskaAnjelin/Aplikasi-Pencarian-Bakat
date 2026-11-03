import 'package:flutter/material.dart';

class DashboardGuruPage extends StatelessWidget {
  const DashboardGuruPage({super.key});

  static const Color purple = Color(0xFF6C5CFF);
  static const Color yellow = Color(0xFFFFC857);
  static const Color darkPurple = Color(0xFF29264F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                // Konten utama dengan scroll
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Judul
                      const Text(
                        'Dashboard Guru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: darkPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selamat Datang,\nPak Aris!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Berikut ringkasan data siswa dan perkembangan bakat.',
                        style: TextStyle(
                          fontSize: 10,
                          color: darkPurple.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Statistik Cards (Row 3 Kotak)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard('120', 'Total Siswa', purple, Colors.white),
                          _buildStatCard('32', 'Status Aktif', yellow, darkPurple),
                          _buildStatCard('11', 'Kegiatan', purple, Colors.white),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Bagian Potensi Terbaru
                      const Text(
                        'Potensi Terbaru',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Item List 1: Alya Nasmi
                      _buildPotensiItem(
                        'Alya Nasmi',
                        'Bakat Public Speaking',
                        'Berkembang',
                        yellow,
                        darkPurple,
                      ),
                      const SizedBox(height: 10),

                      // Item List 2: Siska Anjelin
                      _buildPotensiItem(
                        'Siska Anjelin',
                        'Bakat Fotografi',
                        'Mulai Berkembang',
                        yellow,
                        darkPurple,
                      ),

                      const SizedBox(height: 70), // Spasi bawah untuk Bottom Nav
                    ],
                  ),
                ),

                // Bottom Navigation Bar Kustom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home, 'Beranda', purple, true, () {}),
                        _buildNavItem(Icons.group, 'Daftar Siswa', Colors.grey, false, () {
                          Navigator.pushNamed(context, '/data_siswa');
                        }),
                        _buildNavItem(Icons.history, 'Riwayat', Colors.grey, false, () {}),
                        _buildNavItem(Icons.person, 'Profil', Colors.grey, false, () {}),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label, Color bgColor, Color textColor) {
    return Container(
      width: 86,
      height: 86,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotensiItem(String name, String bakat, String status, Color badgeColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bakat,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, Color color, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}