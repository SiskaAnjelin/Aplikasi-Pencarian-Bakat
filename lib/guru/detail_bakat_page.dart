
import 'package:flutter/material.dart';
import 'penilaian_bakat_page.dart';

class DetailBakatGuruPage extends StatelessWidget {
  final String siswaName;
  final String kelas;

  const DetailBakatGuruPage({
    super.key,
    this.siswaName = 'Naufal Zaidan',
    this.kelas = 'XI RPL 1',
  });

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);

  static const List<String> rekomendasiList = [
    'Ikut lomba menyanyi',
    'Gabung ekstrakurikuler paduan suara',
    'Membuat konten cover lagu',
    'Mengikuti pelatihan vokal',
    'Berlatih teknik pernapasan dan intonasi',
  ];

  @override
  Widget build(BuildContext context) {
    final bakatList = [
      {
        'nama': 'Menyanyi',
        'kategori': 'Seni',
        'status': 'Disetujui',
      },
      {
        'nama': 'Coding',
        'kategori': 'Akademik',
        'status': 'Pending',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: darkPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Bakat',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Siswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE8E7FF),
                    child: Text(
                      siswaName.isNotEmpty
                          ? siswaName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    siswaName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kelas,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Daftar Bakat
            const Text(
              'Daftar Bakat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 12),

            ...bakatList.map((b) {
              final approved = b['status'] == 'Disetujui';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PenilaianBakatPage(
                        siswaName: siswaName,
                        bakatName: b['nama']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: purple,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b['nama']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: darkPurple,
                              ),
                            ),
                            Text(
                              b['kategori']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: approved
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          b['status']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: approved
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Ilustrasi Bakat
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.music_note_rounded,
                  size: 75,
                  color: purple,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Rekomendasi Pengembangan Bakat
            const Text(
              'Rekomendasi Pengembangan Bakat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 14),

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

      // Navigasi Bawah Guru
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
              '/dashboard_guru',
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/data_siswa',
            );
          } else if (index == 3) {
            Navigator.pushReplacementNamed(
              context,
              '/penilaian_bakat',
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
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Data Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Penilaian',
          ),
        ],
      ),
    );
  }
}
