import 'package:flutter/material.dart';

class DetailBakatSiswaPage extends StatelessWidget {
  final String nama;
  final String kategori;
  final String status;

  const DetailBakatSiswaPage({
    super.key,
    this.nama = 'Menggambar',
    this.kategori = 'Seni',
    this.status = 'Disetujui',
  });

  @override
  Widget build(BuildContext context) {
    final approved = status == 'Disetujui';
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFF6C63FF), size: 40),
              ),
              const SizedBox(height: 16),
              Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              Text(kategori, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: approved
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: approved ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}