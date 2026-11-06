import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardSiswaPage extends StatefulWidget {
  const DashboardSiswaPage({super.key});

  @override
  State<DashboardSiswaPage> createState() => _DashboardSiswaPageState();
}

class _DashboardSiswaPageState extends State<DashboardSiswaPage> {
<<<<<<< HEAD
  static const Color purple = Color(0xFF6C5CFF);
  static const Color yellow = Color(0xFFFFC857);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color lightPurple = Color(0xFFE5DFFF);

  int selectedIndex = 0;
  bool _isLoggingOut = false;

  // ================= FUNGSI LOGOUT =================

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun Niskala?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Keluar dari Supabase Authentication
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      // Kembali ke halaman login
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
=======
  int _currentIndex = 0;
>>>>>>> origin/main

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
<<<<<<< HEAD

                      const SizedBox(height: 20),

                      // JUDUL DAN TOMBOL LOGOUT
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Dashboard Siswa',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: darkPurple,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed:
                                _isLoggingOut ? null : _logout,
                            tooltip: 'Logout',
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: purple,
                              size: 22,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // SAPAAN
                      const Text(
                        'Hai, Alya! 👋',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Saatnya eksplorasi bakatmu\n'
                        'dan raih masa depan yang cerah!',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TOMBOL TEMUKAN BAKAT
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/daftar_bakat',
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          label: const Text(
                            'Temukan Bakat',
=======
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, Alya!",
>>>>>>> origin/main
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Selamat datang kembali",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Card Bakat Saya
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
<<<<<<< HEAD
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [

                        _buildNavItem(
                          Icons.home,
                          'Beranda',
                          0,
                          () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),

                        _buildNavItem(
                          Icons.assignment_outlined,
                          'Bakat',
                          1,
                          () {
                            setState(() {
                              selectedIndex = 1;
                            });
                            _showMessage(context);
                          },
                        ),

                        _buildNavItem(
                          Icons.chat_bubble_outline,
                          'Detail',
                          2,
                          () {
                            setState(() {
                              selectedIndex = 2;
                            });
                            _showMessage(context);
                          },
                        ),

                        _buildNavItem(
                          Icons.person_outline,
                          'Profil',
                          3,
                          () {
                            setState(() {
                              selectedIndex = 3;
                            });
                            _showMessage(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
=======
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.star_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bakat Saya",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "3 bakat terdaftar",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
>>>>>>> origin/main
            ),

            const SizedBox(height: 24),

            // Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bakat Populer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Grid Bakat
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  _buildBakatCard("Menggambar", Icons.brush_outlined, const Color(0xFF6C63FF)),
                  _buildBakatCard("Matematika", Icons.calculate_outlined, const Color(0xFF4CAF50)),
                  _buildBakatCard("Menyanyi", Icons.music_note_outlined, const Color(0xFFFF9800)),
                  _buildBakatCard("Coding", Icons.code, const Color(0xFF2196F3)),
                  _buildBakatCard("Menari", Icons.nightlife, const Color(0xFFE91E63)),
                  _buildBakatCard("Olahraga", Icons.sports_soccer, const Color(0xFF009688)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBakatCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
<<<<<<< HEAD

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Kategori: $kategori',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: yellow.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: yellow,
              ),
            ),

            child: Text(
              status,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= NAVBAR ITEM =================

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    VoidCallback onTap,
  ) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: onTap,

=======
        ],
      ),
>>>>>>> origin/main
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
<<<<<<< HEAD

          Icon(
            icon,
            size: 20,
            color: isSelected ? purple : Colors.grey,
=======
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
>>>>>>> origin/main
          ),
          const SizedBox(height: 12),
          Text(
<<<<<<< HEAD
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isSelected ? purple : Colors.grey,
=======
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF1A1A2E),
>>>>>>> origin/main
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: "Bakat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Jadwal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}