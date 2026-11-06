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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Bakat',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}