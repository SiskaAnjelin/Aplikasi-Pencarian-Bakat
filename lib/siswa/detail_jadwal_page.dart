import 'package:flutter/material.dart';

class DetailJadwalPage extends StatelessWidget {
  const DetailJadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      {
        'title': 'Latihan Vokal',
        'guru': 'Bu Sari',
        'lokasi': 'Aula Sekolah',
        'tanggal': 'Senin, 10 Nov 2026',
        'waktu': '14:00 - 16:00',
        'deskripsi': 'Latihan teknik pernapasan dan pitch control',
        'status': 'Mendatang',
      },
      {
        'title': 'Workshop Coding',
        'guru': 'Pak Arif',
        'lokasi': 'Lab Komputer',
        'tanggal': 'Rabu, 12 Nov 2026',
        'waktu': '13:00 - 15:30',
        'deskripsi': 'Pengenalan Flutter & Dart dasar',
        'status': 'Mendatang',
      },
      {
        'title': 'Latihan Menggambar',
        'guru': 'Pak Arif',
        'lokasi': 'Ruang Seni',
        'tanggal': 'Jumat, 8 Nov 2026',
        'waktu': '10:00 - 12:00',
        'deskripsi': 'Teknik shading dan perspektif',
        'status': 'Selesai',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Kegiatan',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final j = list[i];
          final upcoming = j['status'] == 'Mendatang';

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: upcoming
                        ? const Color(0xFF6C63FF).withOpacity(0.08)
                        : Colors.grey.withOpacity(0.08),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        color: upcoming ? const Color(0xFF6C63FF) : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          j['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: upcoming
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: upcoming
                              ? const Color(0xFF6C63FF)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          j['status']!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Detail
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(Icons.person_outline, 'Guru', j['guru']!),
                      _row(Icons.location_on_outlined, 'Lokasi', j['lokasi']!),
                      _row(Icons.calendar_today_outlined, 'Tanggal', j['tanggal']!),
                      _row(Icons.access_time, 'Waktu', j['waktu']!),
                      const Divider(height: 20),
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        j['deskripsi']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}