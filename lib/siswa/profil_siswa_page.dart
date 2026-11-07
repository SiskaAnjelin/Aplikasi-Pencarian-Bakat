
import 'package:flutter/material.dart';

class ProfilSiswaPage extends StatelessWidget {
  const ProfilSiswaPage({super.key});

  final Color primaryColor = const Color(0xFF6C5CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
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

              // PROFIL SISWA
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFD3E3FD),
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.grey,
                    ),
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

              // MENU PROFIL
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Data Pribadi',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: Icons.school_outlined,
                      title: 'Kelas',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: Icons.star_outline,
                      title: 'Bakat',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 55),
                    _buildMenuItem(
                      icon: Icons.calendar_month_outlined,
                      title: 'Detail Jadwal',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail_jadwal_siswa',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // TOMBOL KELUAR
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
        ),
      ),
    );
  }

  // WIDGET MENU PROFIL
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
    );
  }
}
