<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
=======
>>>>>>> origin/main
import 'package:flutter/material.dart';

class ProfilSiswaPage extends StatelessWidget {
  const ProfilSiswaPage({super.key});

<<<<<<< HEAD
  final Color primaryColor = const Color(0xFF6C5CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Tombol Kembali & Judul
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Profil Siswa',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // KARTU PROFIL SINGKAT
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFD3E3FD),
                    child: Icon(Icons.person, size: 36, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Alya Nasmi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'XI RPL B',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // MENU DAFTAR PILIHAN (Bungkus dalam container bergaris tepi)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: CupertinoIcons.person_alt,
                      title: 'Data Pribadi',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: CupertinoIcons.book_fill,
                      title: 'Kelas',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: CupertinoIcons.calendar_badge_plus,
                      title: 'Bakat',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: CupertinoIcons.gear_alt_fill,
                      title: 'Detail jadwal',
                      onTap: () {
                        Navigator.pushNamed(context, '/detail_jadwal_siswa');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // TOMBOL KELUAR (MERAH)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D4D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Logika Keluar / Logout
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profil Siswa",
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Color(0xFFE8E7FF),
                    child: Text(
                      "A",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Alya Nayumi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "XI RPL 2",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu
            _buildMenuItem(Icons.person_outline, "Data Pribadi", () {}),
            _buildMenuItem(Icons.star_outline, "Bakat Saya", () {}),
            _buildMenuItem(Icons.lock_outline, "Ubah Password", () {}),
            _buildMenuItem(Icons.help_outline, "Bantuan", () {}),
            _buildMenuItem(Icons.logout, "Keluar", () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }, isLogout: true),
          ],
>>>>>>> origin/main
        ),
      ),
    );
  }

<<<<<<< HEAD
  // Widget pembantu untuk item menu profil
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
      icon,
       color: Colors.black87,
       size: 20,
     ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
=======
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF6C63FF),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : const Color(0xFF1A1A2E),
          ),
        ),
        trailing: isLogout
            ? null
            : const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ),
>>>>>>> origin/main
    );
  }
}