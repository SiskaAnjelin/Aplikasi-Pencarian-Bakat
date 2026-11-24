import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailJadwalPage extends StatefulWidget {
  const DetailJadwalPage({super.key});

  @override
  State<DetailJadwalPage> createState() => _DetailJadwalPageState();
}

class _DetailJadwalPageState extends State<DetailJadwalPage> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchJadwal() async {
    try {
      final res = await supabase.from('jadwal_kegiatan').select().order('tanggal', ascending: true);
      return List<Map<String, dynamic>>.from(res);
    } catch (_) {
      try {
        final res = await supabase.from('jadwal').select().order('tanggal', ascending: true);
        return List<Map<String, dynamic>>.from(res);
      } catch (e) {
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Jadwal Kegiatan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchJadwal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada jadwal kegiatan.', style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['judul'] ?? item['nama_kegiatan'] ?? 'Kegiatan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['status'] ?? 'Terdaftar',
                            style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['tanggal'] ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 14),
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['jam'] ?? item['waktu'] ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.room_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['ruangan'] ?? item['tempat'] ?? '-', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    if (item['deskripsi'] != null && (item['deskripsi'] as String).isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(item['deskripsi'], style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ]
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}