import 'package:flutter/material.dart';

class BakatSayaPage extends StatefulWidget {
  const BakatSayaPage({super.key});

  @override
  State<BakatSayaPage> createState() => _BakatSayaPageState();
}

class _BakatSayaPageState extends State<BakatSayaPage> {
  int _selectedTab = 0; // 0 = Semua, 1 = Seni, 2 = Akademik

  final List<Map<String, dynamic>> _bakatList = [
    {
      "nama": "Menggambar",
      "kategori": "Seni",
      "icon": Icons.brush_outlined,
      "color": const Color(0xFF6C63FF),
      "status": "Disetujui",
    },
    {
      "nama": "Matematika",
      "kategori": "Akademik",
      "icon": Icons.calculate_outlined,
      "color": const Color(0xFF4CAF50),
      "status": "Pending",
    },
    {
      "nama": "Menyanyi",
      "kategori": "Seni",
      "icon": Icons.music_note_outlined,
      "color": const Color(0xFFFF9800),
      "status": "Disetujui",
    },
    {
      "nama": "Coding",
      "kategori": "Akademik",
      "icon": Icons.code,
      "color": const Color(0xFF2196F3),
      "status": "Disetujui",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          "Bakat Saya",
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF6C63FF)),
            onPressed: () {
              // Navigasi ke Tambah Bakat
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                _buildTab("Semua", 0),
                const SizedBox(width: 10),
                _buildTab("Seni", 1),
                const SizedBox(width: 10),
                _buildTab("Akademik", 2),
              ],
            ),
          ),

          // List Bakat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _bakatList.length,
              itemBuilder: (context, index) {
                final bakat = _bakatList[index];
                return _buildBakatItem(bakat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildBakatItem(Map<String, dynamic> bakat) {
    final isApproved = bakat["status"] == "Disetujui";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              color: (bakat["color"] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              bakat["icon"] as IconData,
              color: bakat["color"] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bakat["nama"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  bakat["kategori"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isApproved
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              bakat["status"],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isApproved ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}