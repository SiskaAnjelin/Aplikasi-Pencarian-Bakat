
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardSiswaPage extends StatefulWidget {
  const DashboardSiswaPage({super.key});

  @override
  State<DashboardSiswaPage> createState() =>
      _DashboardSiswaPageState();
}

class _DashboardSiswaPageState extends State<DashboardSiswaPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            height: 680,
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),

            child: Stack(
              children: [

                // ================= KONTEN DASHBOARD =================

                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

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
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // JUDUL BAKAT SAYA
                      const Text(
                        'Bakat Saya',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // BAKAT 1
                      _buildBakatItem(
                        emoji: '🎨',
                        nama: 'Menggambar',
                        kategori: 'Seni',
                        status: 'Berkembang',
                      ),

                      const SizedBox(height: 12),

                      // BAKAT 2
                      _buildBakatItem(
                        emoji: '🎤',
                        nama: 'Menyanyi',
                        kategori: 'Seni',
                        status: 'Unggul',
                      ),

                      const SizedBox(height: 12),

                      // BAKAT 3
                      _buildBakatItem(
                        emoji: '💻',
                        nama: 'Coding',
                        kategori: 'Teknologi',
                        status: 'Potensial',
                      ),

                      // JARAK UNTUK NAVBAR
                      const SizedBox(height: 80),
                    ],
                  ),
                ),

                // ================= NAVBAR BAWAH =================

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),

                    child: Row(
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
            ),
          ),
        ),
      ),
    );
  }

  // ================= ITEM BAKAT =================

  Widget _buildBakatItem({
    required String emoji,
    required String nama,
    required String kategori,
    required String status,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 20,
            backgroundColor: lightPurple,
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),

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

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 20,
            color: isSelected ? purple : Colors.grey,
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isSelected ? purple : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PESAN SEMENTARA =================

  void _showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Halaman ini akan dibuat selanjutnya.',
        ),
      ),
    );

    setState(() {
      selectedIndex = 0;
    });
  }
}
