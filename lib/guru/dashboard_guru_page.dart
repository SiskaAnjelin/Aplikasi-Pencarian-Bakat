
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardGuruPage extends StatefulWidget {
  const DashboardGuruPage({super.key});

  @override
  State<DashboardGuruPage> createState() =>
      _DashboardGuruPageState();
}

class _DashboardGuruPageState extends State<DashboardGuruPage> {
  int _currentIndex = 0;
  bool _isLoggingOut = false;

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);

  // LOGOUT SUPABASE
  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    setState(() => _isLoggingOut = true);

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

      setState(() => _isLoggingOut = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
        ),
      );
    }
  }

  // NAVIGASI BAWAH
  void _onNavTap(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }

    String route = '';

    switch (index) {
      case 1:
        route = '/data_siswa';
        break;

      case 2:
        route = '/riwayat_kegiatan';
        break;

      case 3:
        route = '/penilaian_bakat';
        break;

      case 4:
        route = '/profil_guru';
        break;
    }

    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route).then((_) {
        if (mounted) {
          setState(() {
            _currentIndex = 0;
          });
        }
      });
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
            child: Column(
              children: [
                // KONTEN DASHBOARD
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // JUDUL DASHBOARD
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashboard Guru',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                            IconButton(
                              onPressed: _isLoggingOut
                                  ? null
                                  : _logout,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: purple,
                                size: 21,
                              ),
                              tooltip: 'Logout',
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // SAPAAN
                        const Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 3),

                        const Text(
                          'Pak Aris!',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Berikut ringkasan data siswa dan '
                          'perkembangan bakat.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // KARTU STATISTIK
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                value: '120',
                                label: 'Total Siswa',
                                color: const Color(0xFF9188FF),
                                icon: Icons.people_alt_outlined,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: _buildStatCard(
                                value: '20',
                                label: 'Bakat Aktif',
                                color: yellow,
                                icon: Icons.star_outline_rounded,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: _buildStatCard(
                                value: '8',
                                label: 'Kegiatan',
                                color: const Color(0xFFB7A4FF),
                                icon: Icons.event_note_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // POTENSI TERBARU
                        const Text(
                          'Potensi Terbaru',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildStudentCard(
                          name: 'Alya Nasmi',
                          className: 'XI RPL 2',
                          talent: 'Public Speaking',
                          initial: 'A',
                          avatarColor: Color(0xFFFFD9E8),
                        ),

                        const SizedBox(height: 12),

                        _buildStudentCard(
                          name: 'Siska Anjelin',
                          className: 'XII RPL B',
                          talent: 'Fotografi',
                          initial: 'S',
                          avatarColor: Color(0xFFE0DCFF),
                        ),

                        const SizedBox(height: 12),

                        _buildStudentCard(
                          name: 'Noufal Zaidan',
                          className: 'XI RPL 1',
                          talent: 'Desain',
                          initial: 'N',
                          avatarColor: Color(0xFFDDF3FF),
                        ),
                      ],
                    ),
                  ),
                ),

                // NAVIGASI BAWAH
                _buildBottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // KARTU STATISTIK
  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // KARTU SISWA
  Widget _buildStudentCard({
    required String name,
    required String className,
    required String talent,
    required String initial,
    required Color avatarColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColor,
            child: Text(
              initial,
              style: const TextStyle(
                color: darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  className,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                talent,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB47A16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey.shade400,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Data Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Penilaian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
