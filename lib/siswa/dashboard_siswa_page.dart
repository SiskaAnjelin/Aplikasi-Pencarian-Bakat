
import 'package:flutter/material.dart';

class DashboardSiswaPage extends StatefulWidget {
  const DashboardSiswaPage({super.key});

  @override
  State<DashboardSiswaPage> createState() =>
      _DashboardSiswaPageState();
}

class _DashboardSiswaPageState extends State<DashboardSiswaPage> {
  static const Color purple = Color(0xFF6C63FF);
  static const Color darkPurple = Color(0xFF29264F);

  int _currentIndex = 0;

  // NAVIGASI BOTTOM BAR
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.pushNamed(context, '/daftar_bakat');
        break;

      case 2:
        Navigator.pushNamed(context, '/detail_jadwal');
        break;

      case 3:
        Navigator.pushNamed(context, '/profil_siswa');
        break;
    }
  }

  // NAVIGASI KE TAMBAH BAKAT
  void _keTambahBakat() {
    Navigator.pushNamed(context, '/tambah_bakat');
  }

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
            child: Scaffold(
              backgroundColor: Colors.white,

              // BODY DASHBOARD
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // JUDUL DASHBOARD
                      const Text(
                        'Dashboard Siswa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // SAPAAN
                      const Text(
                        'Hai, Alya!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DESKRIPSI
                      const Text(
                        'Saatnya Eksplorasi Bakatmu\n'
                        'Dan Raih Masa Depan Yang Cerah!',
                        style: TextStyle(
                          fontSize: 9,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 17),

                      // TOMBOL TEMUKAN BAKAT
                      Center(
                        child: SizedBox(
                          width: 139,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: _keTambahBakat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Temukan Bakat',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // JUDUL BAKAT SAYA
                      const Text(
                        'Bakat Saya',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 23),

                      // LIST BAKAT
                      _buildBakatCard(
                        title: 'Menggambar',
                        kategori: 'Seni',
                        status: 'Berkembang',
                        icon: Icons.palette_rounded,
                        color: const Color(0xFFFFB74D),
                      ),

                      const SizedBox(height: 12),

                      _buildBakatCard(
                        title: 'Menyanyi',
                        kategori: 'Seni',
                        status: 'Unggul',
                        icon: Icons.music_note_rounded,
                        color: const Color(0xFF9C83FF),
                      ),

                      const SizedBox(height: 12),

                      _buildBakatCard(
                        title: 'Coding',
                        kategori: 'Teknologi',
                        status: 'Potensial',
                        icon: Icons.code_rounded,
                        color: const Color(0xFF3D78D8),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // BOTTOM NAVIGATION
              bottomNavigationBar: _buildBottomNav(),
            ),
          ),
        ),
      ),
    );
  }

  // CARD BAKAT SAYA
  Widget _buildBakatCard({
    required String title,
    required String kategori,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // ICON BAKAT
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
              color: color,
            ),
          ),

          const SizedBox(width: 9),

          // NAMA DAN KATEGORI
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kategori: $kategori',
                  style: const TextStyle(
                    fontSize: 7,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // STATUS BAKAT
          Container(
            width: 65,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFC857),
                width: 0.8,
              ),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 7,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION
  Widget _buildBottomNav() {
    return Container(
      height: 55,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            title: 'Beranda',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.library_books_outlined,
            title: 'Bakat',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.more_horiz_rounded,
            title: 'Detail',
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.person,
            title: 'Profil',
            index: 3,
          ),
        ],
      ),
    );
  }

  // ITEM BOTTOM NAVIGATION
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool active = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          _onNavTap(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? purple : Colors.black87,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 8,
                color: Colors.black,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
