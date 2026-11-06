import 'package:flutter/material.dart';

class RiwayatKegiatanPage extends StatelessWidget {
  const RiwayatKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      {'title': 'Tes Seni Lukis', 'siswa': 'Naufal Zaidan', 'tanggal': '15 Okt 2026', 'status': 'Selesai'},
      {'title': 'Latihan Vocal Group', 'siswa': 'Alya Nayumi', 'tanggal': '20 Okt 2026', 'status': 'Selesai'},
      {'title': 'Workshop Python', 'siswa': 'Rizky Maulana', 'tanggal': '25 Okt 2026', 'status': 'Selesai'},
      {'title': 'Latihan Menari', 'siswa': 'Sinta Angelia', 'tanggal': '1 Nov 2026', 'status': 'Selesai'},
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
        title: const Text('Riwayat Kegiatan',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final item = list[i];
          return Container(
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
                  child: const Icon(Icons.event_note_rounded, color: Color(0xFF6C63FF)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title']!,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 3),
                      Text('${item['siswa']} · ${item['tanggal']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item['status']!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF4CAF50))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}