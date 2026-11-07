
import 'package:flutter/material.dart';

class DetailBakatPage extends StatelessWidget {
  final String nama;
  final String kategori;
  final String status;

  const DetailBakatPage({
    super.key,
    this.nama = 'Menyanyi',
    this.kategori = 'Seni',
    this.status = 'Unggul',
  });

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);

  final List<String> rekomendasiList = const [
    'Ikut lomba menyanyi',
    'Gabung ekstrakurikuler paduan suara',
    'Membuat konten cover lagu',
    'Mengikuti pelatihan vokal',
    'Berlatih teknik pernapasan dan intonasi',
  ];

  @override
  Widget build(BuildContext context) {
    final approved = status == 'Disetujui' || status == 'Unggul';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF1A1A2E),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Bakat',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ILUSTRASI BAKAT
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  nama.toLowerCase().contains('nyanyi')
                      ? Icons.music_note_rounded
                      : nama.toLowerCase().contains('gambar')
                          ? Icons.draw_outlined
                          : nama.toLowerCase().contains('coding')
                              ? Icons.code
                              : Icons.star_rounded,
                  size: 85,
                  color: purple,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NAMA BAKAT DAN STATUS
            Row(
              children: [
                Expanded(
                  child: Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: approved
                        ? const Color(0xFFEDEBFF)
                        : const Color(0xFFFFF1D6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: approved
                          ? purple
                          : const Color(0xFFE69500),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // DESKRIPSI
            const Text(
              'Terus kembangkan kemampuan dan potensi dirimu '
              'agar semakin percaya diri dalam menunjukkan bakat.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // INFORMASI KATEGORI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFEAEAF2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    color: purple,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategori Bakat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kategori,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: darkPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // JUDUL REKOMENDASI
            const Text(
              'Rekomendasi Pengembangan Bakat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 14),

            // DAFTAR REKOMENDASI
            ...rekomendasiList.map((rekomendasi) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEAEAF2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.event_note_outlined,
                        size: 21,
                        color: purple,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        rekomendasi,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: darkPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),

      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard_siswa',
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/daftar_bakat',
            );
          } else if (index == 3) {
            Navigator.pushReplacementNamed(
              context,
              '/profil_siswa',
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Cari Bakat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
