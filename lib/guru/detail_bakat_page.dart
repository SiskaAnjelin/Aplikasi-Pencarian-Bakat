
import 'package:flutter/material.dart';

class DetailBakatGuruPage extends StatelessWidget {
  final String siswaName;
  final String kelas;

  const DetailBakatGuruPage({
    super.key,
    this.siswaName = 'Naufal Zaidan',
    this.kelas = 'XII RPL B',
  });

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color yellow = Color(0xFFFFC857);

  final List<Map<String, dynamic>> rekomendasiList = const [
    {
      'judul': 'Uji Desain Gratis',
      'tanggal': '12 Nov 2026 • 08.30 - 10.00',
      'icon': Icons.edit_note_rounded,
    },
    {
      'judul': 'Latihan Kreativitas Desain',
      'tanggal': '13 Nov 2026 • 07.00 - 09.15',
      'icon': Icons.image_search_outlined,
    },
    {
      'judul': 'Uji Desain UI/UX',
      'tanggal': '16 Nov 2026 • 09.00 - 10.30',
      'icon': Icons.view_in_ar_outlined,
    },
  ];

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

              body: SafeArea(
                child: Column(
                  children: [
                    // HEADER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        12, 12, 16, 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Detail Bakat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // PROFIL SISWA
                            Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: lightPurple,
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    'assets/images/foto noufal.jpeg',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 35,
                                        color: purple,
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      siswaName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      kelas,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            // JUDUL BAKAT DAN STATUS
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Bakat Seni',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: yellow,
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Berkembang',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: darkPurple,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // DESKRIPSI BAKAT
                            const Text(
                              'Siswa menunjukkan kreativitas tinggi '
                              'dalam bidang seni, terutama menggambar '
                              'dan desain.',
                              style: TextStyle(
                                fontSize: 9,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // REKOMENDASI
                            const Text(
                              'Rekomendasi Pengujian',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // LIST REKOMENDASI
                            ...rekomendasiList.map((item) {
                              return Container(
                                width: double.infinity,
                                height: 43,
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF9B96C5),
                                    width: 0.8,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item['icon'] as IconData,
                                      color: purple,
                                      size: 25,
                                    ),

                                    const SizedBox(width: 9),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['judul'] as String,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight:
                                                  FontWeight.w600,
                                              color: darkPurple,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            item['tanggal'] as String,
                                            style: const TextStyle(
                                              fontSize: 8,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    // TOMBOL LIHAT JADWAL
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        30, 8, 30, 20,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/detail_jadwal',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Lihat Jadwal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
