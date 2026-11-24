
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  bool _isLoggingOut = false;
  bool _isLoading = true;

  int _totalSiswa = 0;
  int _totalGuru = 0;
  int _totalJadwal = 0;

  static const Color purple = Color(0xFF6C5CE7);
  static const Color dark = Color(0xFF2D3436);
  static const Color background = Color(0xFFF8F9FE);

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  //ambil jumlah data dari supabase
  Future<void> _fetchStats() async {
    try {
      final siswaRes = await supabase
          .from('siswa')
          .count(CountOption.exact);

      final guruRes = await supabase
          .from('guru')
          .count(CountOption.exact);

      final jadwalRes = await supabase
          .from('jadwal_kegiatan')
          .count(CountOption.exact);

      if (!mounted) return;

      setState(() {
        _totalSiswa = siswaRes;
        _totalGuru = guruRes;
        _totalJadwal = jadwalRes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil ringkasan data: $e'),
        ),
      );
    }
  }

  //konfirmasi dan proses logout
  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Center(
          child: Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF29264F),
            ),
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        actions: [
          // tombol batal warna hijau
          SizedBox(
            width: 105,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00A878),
                side: const BorderSide(
                  color: Color(0xFF00A878),
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // tombol keluar warna merah
          SizedBox(
            width: 105,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4757),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      //keluar dari akun supabase
      await supabase.auth.signOut();

      if (!mounted) return;

      //kembali ke halaman login
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
        SnackBar(
          content: Text('Gagal logout: $e'),
        ),
      );
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
              color: background,
              borderRadius: BorderRadius.circular(40),
            ),

            child: Scaffold(
              backgroundColor: background,

              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: _fetchStats,

                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //header dashboard
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 21,
                              backgroundColor: Color(0xFFEDE9FF),
                              child: Icon(
                                Icons.admin_panel_settings,
                                color: purple,
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 10),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, Admin',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  SizedBox(height: 2),

                                  Text(
                                    'Admin Niskala',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: dark,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //tombol logout
                            IconButton(
                              onPressed:
                                  _isLoggingOut ? null : _logout,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 21,
                              ),
                              tooltip: 'Keluar',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //ringkasan data
                        const Text(
                          'Ringkasan Data',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: dark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                'Total Siswa',
                                _isLoading ? '...' : '$_totalSiswa',
                                Icons.people_outline,
                                purple,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _statCard(
                                'Total Guru',
                                _isLoading ? '...' : '$_totalGuru',
                                Icons.school_outlined,
                                const Color(0xFF00B894),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                'Total Jadwal',
                                _isLoading ? '...' : '$_totalJadwal',
                                Icons.calendar_month_outlined,
                                const Color(0xFFFDCB6E),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _statCard(
                                'Laporan',
                                '3',
                                Icons.description_outlined,
                                const Color(0xFFE17055),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        //menu cepat
                        const Text(
                          'Menu Cepat',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: dark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        //menu kelola siswa
                        _menuCard(
                          icon: Icons.people_rounded,
                          title: 'Kelola Siswa',
                          subtitle: 'Tambah, edit, hapus data siswa',
                          color: purple,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/kelola_siswa',
                            );

                            _fetchStats();
                          },
                        ),

                        //menu kelola guru
                        _menuCard(
                          icon: Icons.school_rounded,
                          title: 'Kelola Guru',
                          subtitle: 'Kelola data guru dan bidang keahlian',
                          color: const Color(0xFF00B894),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/kelola_guru',
                            );

                            _fetchStats();
                          },
                        ),

                        //menu laporan
                        _menuCard(
                          icon: Icons.bar_chart_rounded,
                          title: 'Laporan Data',
                          subtitle: 'Lihat dan export laporan',
                          color: const Color(0xFFE17055),
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/laporan',
                            );

                            _fetchStats();
                          },
                        ),

                        //menu jadwal kegiatan
                        _menuCard(
                          icon: Icons.calendar_month_rounded,
                          title: 'Jadwal Kegiatan',
                          subtitle: 'Kelola jadwal kegiatan siswa',
                          color: purple,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              '/detail_jadwal',
                            );

                            _fetchStats();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //tampilan kartu ringkasan
  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),

            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),

          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  //tampilan menu cepat
  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: color.withOpacity(0.6),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
