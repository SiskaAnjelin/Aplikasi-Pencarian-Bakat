import 'package:flutter/material.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  static const Color primaryPurple = Color(0xFF6C5CFF);
  static const Color lightGreyBg = Color(0xFFF0F2F5);
  static const Color cardGreyBg = Color(0xFFEFF1F4);
  static const Color textDark = Color(0xFF29264F);

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
                // Scrollable Content
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header / App Bar Custom
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        color: primaryPurple,
                        child: const Row(
                          children: [
                            Icon(Icons.menu, color: Colors.white, size: 24),
                            SizedBox(width: 16),
                            Text(
                              'Admin OSIS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                                Expanded(child: _buildStatCard(Icons.emoji_events, 'Total Peserta', '45', Colors.amber)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildStatCard(Icons.person_search, 'Guru Juri', '7', Colors.amber)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildStatCard(Icons.edit_calendar, 'Jadwal Tampil', '9', Colors.amber)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildStatCard(Icons.school, 'Kelas & Jurusan', '12', Colors.amber)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Menu Buttons
                            _buildMenuButton(
                              icon: Icons.person,
                              title: 'Kelola Data Siswa',
                              showArrow: false,
                              onTap: () {
                                Navigator.pushNamed(context, '/data_siswa');
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

                            const SizedBox(height: 70), // Padding untuk Bottom Navigation Bar
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home_outlined, 'Beranda', primaryPurple, true, () {}),
                        _buildNavItem(Icons.menu_book_outlined, 'Data', Colors.grey, false, () {}),
                        _buildNavItem(Icons.calendar_month_outlined, 'Jadwal', Colors.grey, false, () {}),
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

  // Widget Kartu Statistik
  Widget _buildStatCard(IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: cardGreyBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Menu Berbentuk Card Outlined
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required bool showArrow,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textDark.withValues(alpha: 0.4), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, color: textDark, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 14, color: textDark),
          ],
        ),
      ),
    );
  }

  // Widget Item Navigation Bar
  Widget _buildNavItem(IconData icon, String label, Color color, bool isSelected, VoidCallback onTap) {
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
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}