<<<<<<< HEAD

import 'package:flutter/material.dart';

class DetailBakatGuruPage extends StatefulWidget {
  const DetailBakatGuruPage({super.key});

  @override
  State<DetailBakatGuruPage> createState() =>
      _DetailBakatGuruPageState();
}

class _DetailBakatGuruPageState
    extends State<DetailBakatGuruPage> {

  final List<String> rekomendasiList = [
    'Ikut lomba menyanyi',
    'Gabung ekstrakurikuler paduan suara',
    'Membuat konten cover lagu',
    'Mengikuti pelatihan vokal',
    'Berlatih teknik pernapasan dan intonasi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

=======
import 'package:flutter/material.dart';
import 'penilaian_bakat_page.dart';

class DetailBakatPage extends StatelessWidget {
  final String siswaName;
  final String kelas;

  const DetailBakatPage({
    super.key,
    this.siswaName = 'Naufal Zaidan',
    this.kelas = 'XI RPL 1',
  });

  @override
  Widget build(BuildContext context) {
    final bakatList = [
      {'nama': 'Menyanyi', 'kategori': 'Seni', 'status': 'Disetujui'},
      {'nama': 'Coding', 'kategori': 'Akademik', 'status': 'Pending'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
>>>>>>> origin/main
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
<<<<<<< HEAD
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Bakat',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

=======
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Bakat',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
>>>>>>> origin/main
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            // Ilustrasi bakat
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.music_note_rounded,
                  size: 85,
                  color: Color(0xFF6C5CFF),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nama bakat dan status
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Menyanyi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202044),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEBFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Unggul',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C5CFF),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Deskripsi bakat
            const Text(
              'Siswa memiliki suara yang bagus dan percaya diri saat tampil di depan umum.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Informasi kategori
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
              child: const Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: Color(0xFF6C5CFF),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kategori Bakat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Seni',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF202044),
=======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE8E7FF),
                    child: Text(siswaName[0],
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
                  ),
                  const SizedBox(height: 14),
                  Text(siswaName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  Text(kelas, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Daftar Bakat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            ...bakatList.map((b) {
              final approved = b['status'] == 'Disetujui';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PenilaianBakatPage(siswaName: siswaName, bakatName: b['nama']),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.star_rounded, color: Color(0xFF6C63FF)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b['nama']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            Text(b['kategori']!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: approved
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          b['status']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: approved ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                          ),
>>>>>>> origin/main
                        ),
                      ),
                    ],
                  ),
<<<<<<< HEAD
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Judul rekomendasi
            const Text(
              'Rekomendasi Pengembangan Bakat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202044),
              ),
            ),

            const SizedBox(height: 14),

            // Daftar rekomendasi
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
                        color: Color(0xFF6C5CFF),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        rekomendasi,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF202044),
                        ),
                      ),
                    ),
                  ],
=======
>>>>>>> origin/main
                ),
              );
            }),
          ],
        ),
      ),
<<<<<<< HEAD

      // Navigasi bawah khusus Guru
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CFF),
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
=======
    );
  }
}
>>>>>>> origin/main
