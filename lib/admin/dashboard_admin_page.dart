import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() =>
      _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  // ==========================================
  // KONEKSI SUPABASE
  // ==========================================

  final supabase = Supabase.instance.client;

  // ==========================================
  // VARIABEL KONDISI
  // ==========================================

  bool _isLoading = true;
  bool _isLoadingSiswa = true;
  bool _isLoggingOut = false;

  // Data statistik dashboard
  int _totalSiswa = 0;
  int _totalGuru = 0;
  int _totalJadwal = 0;
  int _totalLaporan = 0;

  // Index bottom navigation
  int _selectedIndex = 0;

  // Bidang guru
  String _bidangGuru = '';

  // Data siswa terbaru
  List<Map<String, dynamic>> _siswaTerbaru = [];

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color purple = Color(0xFF6C63FF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color background = Colors.white;
  static const Color cardGrey = Color(0xFFF0F0F2);
  static const Color red = Color(0xFFE57373);

  // ==========================================
  // UKURAN FONT
  // ==========================================

  double fontSize(double size) => size * 1.18;

  @override
  void initState() {
    super.initState();

    // Mengambil data ketika halaman pertama dibuka
    _fetchStats();
    _fetchSiswaTerbaru();
  }

  // ==========================================
  // MENGAMBIL STATISTIK
  // ==========================================

  Future<void> _fetchStats() async {
    try {
      // Menghitung total siswa
      final siswaRes =
          await supabase.from('siswa').count(CountOption.exact);

      // Menghitung total guru
      final guruRes =
          await supabase.from('guru').count(CountOption.exact);

      // Menghitung total jadwal
      final jadwalRes = await supabase
          .from('jadwal_kegiatan')
          .count(CountOption.exact);

      // Menghitung total laporan/pengajuan
      final laporanRes = await supabase
          .from('pengajuan_bakat')
          .count(CountOption.exact);

      if (!mounted) return;

      setState(() {
        _totalSiswa = siswaRes;
        _totalGuru = guruRes;
        _totalJadwal = jadwalRes;
        _totalLaporan = laporanRes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data: $e'),
          backgroundColor: red,
        ),
      );
    }
  }

  // ==========================================
  // MENGAMBIL PROFIL SISWA SESUAI BIDANG GURU
  // ==========================================

  Future<void> _fetchSiswaTerbaru() async {
    try {
      // Mengambil user yang sedang login
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Akun belum login.');
      }

      // Mengambil bidang guru yang login
      final guruResponse = await supabase
          .from('guru')
          .select('bidang')
          .eq('user_id', user.id)
          .maybeSingle();

      if (guruResponse == null) {
        throw Exception('Data guru tidak ditemukan.');
      }

      final bidang = guruResponse['bidang']?.toString().trim();

      if (bidang == null || bidang.isEmpty) {
        throw Exception('Bidang guru belum diisi.');
      }

      // Mengambil siswa berdasarkan bidang bakat
      final response = await supabase
          .from('siswa')
          .select('''
            nama_siswa,
            kelas,
            foto_profil,
            pengajuan_bakat!inner(
              id_pengajuan,
              status,
              bakat!inner(
                nama_bakat
              )
            )
          ''')
          .eq('pengajuan_bakat.bakat.nama_bakat', bidang)
          .order('nama_siswa', ascending: true)
          .limit(5);

      if (!mounted) return;

      setState(() {
        _bidangGuru = bidang;
        _siswaTerbaru =
            List<Map<String, dynamic>>.from(response);
        _isLoadingSiswa = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingSiswa = false;
      });

      debugPrint('Gagal mengambil profil siswa: $e');
    }
  }

  // ==========================================
  // REFRESH DASHBOARD
  // ==========================================

  Future<void> _refreshDashboard() async {
    await Future.wait([
      _fetchStats(),
      _fetchSiswaTerbaru(),
    ]);
  }

  // ==========================================
  // NAVIGASI HALAMAN
  // ==========================================

  Future<void> _bukaHalaman(String route) async {
    await Navigator.pushNamed(context, route);

    if (!mounted) return;

    // Memperbarui dashboard ketika kembali
    await _refreshDashboard();
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    // Dialog konfirmasi keluar
    final hasil = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          'Konfirmasi Keluar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize(14),
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize(11),
            color: Colors.black87,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        actions: [
          SizedBox(
            width: 85,
            height: 36,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Text(
                'Batal',
                style: TextStyle(fontSize: fontSize(10)),
              ),
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 85,
            height: 36,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Text(
                'Keluar',
                style: TextStyle(
                  fontSize: fontSize(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (hasil != true) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Mengeluarkan akun dari Supabase
      await supabase.auth.signOut();

      if (!mounted) return;

      // Kembali ke halaman login
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
          content: Text('Gagal keluar: $e'),
          backgroundColor: red,
        ),
      );
    }
  }

  // ==========================================
  // KARTU STATISTIK RESPONSIF
  // ==========================================

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 58,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: yellow,
            size: 23,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize(8),
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize(9),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FOTO PROFIL SISWA
  // ==========================================

  Widget _fotoProfil(String? fotoProfil) {
    // Foto default jika belum tersedia
    if (fotoProfil == null || fotoProfil.trim().isEmpty) {
      return Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          color: Color(0xFFEAE8FF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          color: purple,
          size: 25,
        ),
      );
    }

    // Mengambil foto dari URL
    return ClipOval(
      child: Image.network(
        fotoProfil,
        width: 46,
        height: 46,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.65),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 46,
            height: 46,
            color: const Color(0xFFEAE8FF),
            child: const Icon(
              Icons.person,
              color: purple,
              size: 25,
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // PROFIL SISWA SESUAI BIDANG GURU
  // ==========================================

  Widget _bagianProfilSiswa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan tombol lihat semua
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil Siswa',
                    style: TextStyle(
                      fontSize: fontSize(11),
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),

                  if (_bidangGuru.isNotEmpty)
                    Text(
                      'Bidang $_bidangGuru',
                      style: TextStyle(
                        fontSize: fontSize(8),
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                _bukaHalaman('/kelola_siswa');
              },
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: fontSize(8),
                  color: purple,
                ),
              ),
            ),
          ],
        ),

        // Kondisi loading
        if (_isLoadingSiswa)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(
                color: purple,
                strokeWidth: 2,
              ),
            ),
          )

        // Kondisi data kosong
        else if (_siswaTerbaru.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Belum ada siswa pada bidang ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize(9),
                color: Colors.black54,
              ),
            ),
          )

        // Menampilkan daftar siswa
        else
          ..._siswaTerbaru.map((siswa) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Foto profil
                  _fotoProfil(
                    siswa['foto_profil']?.toString(),
                  ),

                  const SizedBox(width: 10),

                  // Nama dan kelas siswa
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          siswa['nama_siswa']?.toString() ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize(9),
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          siswa['kelas']?.toString() ?? '-',
                          style: TextStyle(
                            fontSize: fontSize(8),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  // ==========================================
  // MENU UTAMA RESPONSIF
  // ==========================================

  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 44,
        ),
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9995AD),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF444444),
              size: 18,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize(9),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              size: 19,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION RESPONSIF
  // ==========================================

  Widget _bottomNav() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEAEAEA),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(
            icon: Icons.home_outlined,
            label: 'Beranda',
            index: 0,
          ),

          _navItem(
            icon: Icons.storage_outlined,
            label: 'Data',
            index: 1,
          ),

          _navItem(
            icon: Icons.calendar_month_outlined,
            label: 'Jadwal',
            index: 2,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ITEM BOTTOM NAVIGATION
  // ==========================================

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (index == 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else if (index == 1) {
            setState(() {
              _selectedIndex = 1;
            });

            _bukaHalaman('/laporan');
          } else if (index == 2) {
            setState(() {
              _selectedIndex = 2;
            });

            _bukaHalaman('/detail_jadwal');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 21,
                color: selected ? purple : Colors.grey,
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize(8),
                  color: selected ? purple : Colors.grey,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD DASHBOARD ADMIN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // Menghindari area status bar dan navigasi sistem
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Mengambil lebar layar yang tersedia
            final lebarLayar = constraints.maxWidth;

            // Padding menyesuaikan ukuran layar
            final paddingHorizontal =
                lebarLayar < 360 ? 14.0 : 20.0;

            return Column(
              children: [
                // ==================================
                // HEADER UNGU
                // ==================================

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    paddingHorizontal,
                    8,
                    paddingHorizontal,
                    8,
                  ),
                  decoration: const BoxDecoration(
                    color: purple,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed:
                          _isLoggingOut ? null : _logout,
                      tooltip: 'Keluar',
                      icon: _isLoggingOut
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                    ),
                  ),
                ),

                // ==================================
                // KONTEN DASHBOARD
                // ==================================

                Expanded(
                  child: RefreshIndicator(
                    color: purple,
                    onRefresh: _refreshDashboard,
                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        paddingHorizontal,
                        20,
                        paddingHorizontal,
                        20,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          // Membatasi pelebaran konten pada tablet,
                          // tetapi tetap mengikuti lebar layar HP.
                          constraints: const BoxConstraints(
                            maxWidth: 800,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              // ==========================
                              // CARD SAPAAN ADMIN
                              // ==========================

                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 58,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAEAEA),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Halo, Admin OSIS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: fontSize(13),
                                        fontWeight: FontWeight.bold,
                                        color: darkPurple,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      'kelola data penampilan dengan mudah',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: fontSize(8),
                                        color: darkPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ==========================
                              // STATISTIK BARIS PERTAMA
                              // ==========================

                              Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      title: 'Total Peserta',
                                      value: _isLoading
                                          ? '...'
                                          : '$_totalSiswa',
                                      icon:
                                          Icons.workspace_premium,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: _statCard(
                                      title: 'Guru Juri',
                                      value: _isLoading
                                          ? '...'
                                          : '$_totalGuru',
                                      icon: Icons
                                          .person_add_alt_1_rounded,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // ==========================
                              // STATISTIK BARIS KEDUA
                              // ==========================

                              Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      title: 'Jadwal Tampil',
                                      value: _isLoading
                                          ? '...'
                                          : '$_totalJadwal',
                                      icon: Icons
                                          .calendar_month_rounded,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: _statCard(
                                      title: 'Kelas & Jurusan',
                                      value: _isLoading
                                          ? '...'
                                          : '$_totalLaporan',
                                      icon: Icons.school_outlined,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ==========================
                              // PROFIL SISWA
                              // ==========================

                              _bagianProfilSiswa(),

                              const SizedBox(height: 15),

                              // ==========================
                              // MENU UTAMA
                              // ==========================

                              _menuCard(
                                icon: Icons.person,
                                title: 'Kelola Data Siswa',
                                onTap: () {
                                  _bukaHalaman('/kelola_siswa');
                                },
                              ),

                              _menuCard(
                                icon: Icons.person_outline,
                                title: 'Kelola Guru Juri',
                                onTap: () {
                                  _bukaHalaman('/kelola_guru');
                                },
                              ),

                              _menuCard(
                                icon:
                                    Icons.calendar_month_outlined,
                                title: 'Kelola Jadwal Penampilan',
                                onTap: () {
                                  _bukaHalaman('/detail_jadwal');
                                },
                              ),

                              _menuCard(
                                icon: Icons.search,
                                title: 'Lihat Semua Data',
                                onTap: () {
                                  _bukaHalaman('/laporan');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // ==================================
      // BOTTOM NAVIGATION
      // ==================================

      bottomNavigationBar: SafeArea(
        top: false,
        child: _bottomNav(),
      ),
    );
  }
}