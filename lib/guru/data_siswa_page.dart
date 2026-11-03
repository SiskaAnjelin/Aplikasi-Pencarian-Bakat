import 'package:flutter/material.dart';

class DataSiswaPage extends StatelessWidget {
  const DataSiswaPage({super.key});

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
                // Aksen lingkaran ungu di kanan atas
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Aksen lingkaran kuning di kiri bawah
                Positioned(
                  left: -30,
                  bottom: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Konten Utama
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (Tombol Back & Judul)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Data Siswa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: darkPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Kotak Pencarian (Search Bar)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.menu, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(fontSize: 11),
                                decoration: InputDecoration(
                                  hintText: 'Cari nama siswa...',
                                  hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Tombol (Semua & Kelas)
                      Row(
                        children: [
                          _buildFilterButton('Semua', true),
                          const SizedBox(width: 8),
                          _buildFilterButton('Kelas', false),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Daftar Siswa (ListView)
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 60),
                          children: [
                            _buildStudentItem('Noufal Zaidan', 'XII RPL B', darkPurple),
                            _buildStudentItem('Alya Nasmi', 'XI RPL B', darkPurple),
                            _buildStudentItem('Siska Anjelin', 'XII RPL B', darkPurple),
                            _buildStudentItem('Rizky Maulana', 'X TKJ D', darkPurple),
                          ],
                        ),
                      ),
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
                        _buildNavItem(Icons.home, 'Beranda', Colors.grey, false, () {
                          Navigator.pop(context);
                        }),
                        _buildNavItem(Icons.group, 'Daftar Siswa', purple, true, () {}),
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

  Widget _buildFilterButton(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? purple : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : purple,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: isSelected ? Colors.white : purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(String name, String kelas, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kelas,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.black54,
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