import 'package:flutter/material.dart';

class DetailJadwalPage extends StatelessWidget {
  const DetailJadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwalList = [
      {
        'title': 'Latihan Vokal',
        'guru': 'Bu Sari',
        'lokasi': 'Aula Sekolah',
        'tanggal': 'Senin, 10 Nov 2026',
        'waktu': '14:00 - 16:00',
        'deskripsi': 'Latihan teknik pernapasan dan pitch control',
        'status': 'upcoming',
      },
      {
        'title': 'Workshop Coding',
        'guru': 'Pak Arif',
        'lokasi': 'Lab Komputer',
        'tanggal': 'Rabu, 12 Nov 2026',
        'waktu': '13:00 - 15:30',
        'deskripsi': 'Pengenalan Flutter & Dart dasar',
        'status': 'upcoming',
      },
      {
        'title': 'Latihan Menggambar',
        'guru': 'Naufal Zaidan',
        'lokasi': 'Ruang Seni',
        'tanggal': 'Jumat, 8 Nov 2026',
        'waktu': '10:00 - 12:00',
        'deskripsi': 'Teknik shading dan perspektif',
        'status': 'completed',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jadwalList.length,
        itemBuilder: (context, index) {
          final j = jadwalList[index];
          final isUpcoming = j['status'] == 'upcoming';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? const Color(0xFF6C5CE7).withOpacity(0.08)
                        : const Color(0xFFB2BEC3).withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        color: isUpcoming ? const Color(0xFF6C5CE7) : const Color(0xFF636E72),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          j['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isUpcoming ? const Color(0xFF6C5CE7) : const Color(0xFF2D3436),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isUpcoming ? const Color(0xFF6C5CE7) : const Color(0xFFB2BEC3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isUpcoming ? 'Mendatang' : 'Selesai',
                          style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow(Icons.person_outline, 'Guru', j['guru']!),
                      _infoRow(Icons.location_on_outlined, 'Lokasi', j['lokasi']!),
                      _infoRow(Icons.calendar_today_outlined, 'Tanggal', j['tanggal']!),
                      _infoRow(Icons.access_time_outlined, 'Waktu', j['waktu']!),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Deskripsi Kegiatan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF636E72)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(j['deskripsi']!, style: const TextStyle(fontSize: 14, color: Color(0xFF2D3436))),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFB2BEC3)),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF636E72))),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF2D3436))),
          ),
        ],
      ),
    );
  }
}