
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardGuruPage extends StatefulWidget {
  const DashboardGuruPage({super.key});

  @override
  State<DashboardGuruPage> createState() => _DashboardGuruPageState();
}

class _DashboardGuruPageState extends State<DashboardGuruPage> {
  int _currentIndex = 0;
  bool _isLoggingOut = false;

  static const Color purple = Color(0xFF6C63FF);
  static const Color darkPurple = Color(0xFF29264F);

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

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
                color: purple,
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pak Aris',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _isLoggingOut ? null : _logout,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pantau kegiatan siswa dalam bakat\n'
                    'yang mereka minati',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Cepat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildQuickMenu(
                    icon: Icons.people_alt_outlined,
                    label: 'Data Siswa',
                    color: purple,
                    onTap: () {
                      Navigator.pushNamed(context, '/data_siswa');
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildQuickMenu(
                    icon: Icons.assignment_outlined,
                    label: 'Penilaian',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/penilaian_bakat',
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildQuickMenu(
                    icon: Icons.history,
                    label: 'Riwayat',
                    color: Colors.orange,
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Judul Siswa Terbaru
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Siswa Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List Siswa
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildStudentCard(
                    name: 'Noufal Zaidan',
                    className: 'XI RPL 1',
                    talent: 'Desain',
                  ),
                  _buildStudentCard(
                    name: 'Alya Nasmi',
                    className: 'XI RPL 2',
                    talent: 'Public Speaking',
                  ),
                  _buildStudentCard(
                    name: 'Siska Anjelin',
                    className: 'XII RPL B',
                    talent: 'Fotografi',
                  ),
                  _buildStudentCard(
                    name: 'Rizky Maulana',
                    className: 'X RPL 1',
                    talent: 'Coding',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Menu Cepat
  Widget _buildQuickMenu({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Siswa
  Widget _buildStudentCard({
    required String name,
    required String className,
    required String talent,
  }) {
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
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE8E7FF),
            child: Text(
              name[0],
              style: const TextStyle(
                color: purple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              talent,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation
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
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.pushNamed(context, '/data_siswa');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/penilaian_bakat');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Penilaian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
