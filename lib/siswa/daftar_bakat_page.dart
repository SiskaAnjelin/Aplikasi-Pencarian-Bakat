import 'package:flutter/material.dart';
import 'tambah_bakat_page.dart';

class DaftarBakatPage extends StatelessWidget {
  const DaftarBakatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'nama': 'Menggambar', 'icon': Icons.brush_outlined, 'color': const Color(0xFF6C63FF)},
      {'nama': 'Matematika', 'icon': Icons.calculate_outlined, 'color': const Color(0xFF4CAF50)},
      {'nama': 'Menyanyi', 'icon': Icons.music_note_outlined, 'color': const Color(0xFFFF9800)},
      {'nama': 'Coding', 'icon': Icons.code, 'color': const Color(0xFF2196F3)},
      {'nama': 'Menari', 'icon': Icons.nightlife, 'color': const Color(0xFFE91E63)},
      {'nama': 'Olahraga', 'icon': Icons.sports_soccer, 'color': const Color(0xFF009688)},
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
        title: const Text('Daftar Bakat',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF6C63FF)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahBakatPage()));
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.1,
        children: items.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(item['nama'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1A2E))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}