import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardGuruPage extends StatefulWidget {
  const DashboardGuruPage({super.key});

  @override
  State<DashboardGuruPage> createState() => _DashboardGuruPageState();
}

class _DashboardGuruPageState extends State<DashboardGuruPage> {
  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color purple = Color(0xFF7062F5);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color lightPurple = Color(0xFFB8A5FF);

  // ==========================================
  // VARIABEL NAVIGASI
  // ==========================================

  int _currentIndex = 0;

  // ==========================================
  // FUTURE DATA SUPABASE
  // ==========================================

  late Future<String> _namaGuruFuture;
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();

    // Mengambil nama guru dan data dashboard.
    _namaGuruFuture = _ambilNamaGuru();
    _dashboardFuture = _ambilDataDashboard();
  }

  // ==========================================
  // MENGAMBIL NAMA GURU
  // ==========================================

  Future<String> _ambilNamaGuru() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return 'Guru';
    }

    try {
      final data = await supabase
          .from('guru')
          .select('nama_guru')
          .eq('user_id', user.id)
          .maybeSingle();

      return data?['nama_guru']?.toString() ?? 'Guru';
    } catch (e) {
      debugPrint('Gagal mengambil nama guru: $e');
      return 'Guru';
    }
  }

  // ==========================================
  // MENGAMBIL DATA DASHBOARD
  // ==========================================

  Future<Map<String, dynamic>> _ambilDataDashboard() async {
    final supabase = Supabase.instance.client;

    try {
      // Mengambil seluruh data siswa.
      final dataSiswa = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa, kelas');

      // Mengambil seluruh data bakat.
      final dataBakat = await supabase
          .from('bakat')
          .select('id_bakat, nama_bakat');

      // Mengambil jumlah kegiatan.
      final dataKegiatan = await supabase
          .from('jadwal_kegiatan')
          .select('id_jadwal');

      // Mengambil pengajuan bakat terbaru.
      final dataPengajuan = await supabase
          .from('pengajuan_bakat')
          .select('id_siswa, id_bakat, tanggal_pengajuan')
          .order('tanggal_pengajuan', ascending: false);

      // ==========================================
      // MAP DATA SISWA
      // ==========================================

      final Map<String, Map<String, dynamic>> siswaMap = {};

      for (final siswa in dataSiswa) {
        siswaMap[siswa['id_siswa'].toString()] =
            Map<String, dynamic>.from(siswa);
      }

      // ==========================================
      // MAP DATA BAKAT
      // ==========================================

      final Map<String, Map<String, dynamic>> bakatMap = {};

      for (final bakat in dataBakat) {
        bakatMap[bakat['id_bakat'].toString()] =
            Map<String, dynamic>.from(bakat);
      }

      // ==========================================
      // MENGAMBIL 3 POTENSI TERBARU
      // ==========================================

      final List<Map<String, dynamic>> potensiTerbaru = [];

      for (final pengajuan in dataPengajuan) {
        final idSiswa = pengajuan['id_siswa']?.toString();
        final idBakat = pengajuan['id_bakat']?.toString();

        final siswa = siswaMap[idSiswa];
        final bakat = bakatMap[idBakat];

        if (siswa != null && bakat != null) {
          potensiTerbaru.add({
            'id_siswa': siswa['id_siswa'],
            'nama_siswa': siswa['nama_siswa'] ?? '-',
            'kelas': siswa['kelas'] ?? '-',
            'nama_bakat': bakat['nama_bakat'] ?? '-',
          });
        }

        // Maksimal menampilkan 3 data terbaru.
        if (potensiTerbaru.length == 3) {
          break;
        }
      }

      // Mengembalikan data dashboard.
      return {
        'totalSiswa': dataSiswa.length,
        'totalBakat': dataBakat.length,
        'totalKegiatan': dataKegiatan.length,
        'potensiTerbaru': potensiTerbaru,
      };
    } catch (e) {
      debugPrint('Gagal mengambil data dashboard: $e');
      rethrow;
    }
  }

  // ==========================================
  // REFRESH DASHBOARD
  // ==========================================

  Future<void> _refreshDashboard() async {
    final namaFuture = _ambilNamaGuru();
    final dashboardFuture = _ambilDataDashboard();

    setState(() {
      _namaGuruFuture = namaFuture;
      _dashboardFuture = dashboardFuture;
    });

    try {
      await Future.wait([
        namaFuture,
        dashboardFuture,
      ]);
    } catch (_) {
      // Error ditampilkan melalui FutureBuilder.
    }
  }

  // ==========================================
  // NAVIGASI BOTTOM BAR
  // ==========================================

  void _onNavTap(int index) {
    if (index == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Beranda.
        break;

      case 1:
        Navigator.pushNamed(context, '/data_siswa');
        break;

      case 2:
        Navigator.pushNamed(context, '/riwayat');
        break;

      case 3:
        Navigator.pushNamed(context, '/penilaian_bakat');
        break;

      case 4:
        Navigator.pushNamed(context, '/profil_guru');
        break;
    }
  }

  // ==========================================
  // HEADER DASHBOARD
  // ==========================================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'Dashboard Guru',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: darkPurple,
            ),
          ),
        ),

        // Tombol refresh.
        IconButton(
          onPressed: _refreshDashboard,
          icon: const Icon(
            Icons.refresh,
            color: purple,
            size: 23,
          ),
          tooltip: 'Refresh Dashboard',
        ),
      ],
    );
  }

  // ==========================================
  // BAGIAN SAPAAN GURU
  // ==========================================

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat Datang,',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 4),

        FutureBuilder<String>(
          future: _namaGuruFuture,
          builder: (context, snapshot) {
            return Text(
              '${snapshot.data ?? 'Guru'}!',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        const Text(
          'Berikut ringkasan data siswa dan perkembangan bakat.',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // KARTU STATISTIK
  // ==========================================

  Widget _statCard(
    IconData icon,
    String number,
    String label,
    Color color,
  ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 105,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),

          const SizedBox(height: 8),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DAFTAR KARTU STATISTIK
  // ==========================================

  Widget _buildStatistics(
    int totalSiswa,
    int totalBakat,
    int totalKegiatan,
  ) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Icons.people_alt_outlined,
            totalSiswa.toString(),
            'Total Siswa',
            purple,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            Icons.star_outline,
            totalBakat.toString(),
            'Bakat Aktif',
            yellow,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            Icons.calendar_month_outlined,
            totalKegiatan.toString(),
            'Kegiatan',
            lightPurple,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // JUDUL POTENSI TERBARU
  // ==========================================

  Widget _buildSectionTitle() {
    return const Text(
      'Potensi Terbaru',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: darkPurple,
      ),
    );
  }

  // ==========================================
  // TAMPILAN JIKA BELUM ADA PENGAJUAN
  // ==========================================

  Widget _buildEmptyPotensi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 34,
            color: purple,
          ),

          SizedBox(height: 10),

          Text(
            'Belum ada pengajuan bakat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU POTENSI SISWA
  // ==========================================

  Widget _studentCard(
    String initial,
    String name,
    String kelas,
    String talent,
    Color avatarColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
          // Avatar siswa.
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColor,
            child: Text(
              initial,
              style: const TextStyle(
                color: darkPurple,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Informasi siswa.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  kelas,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Label bakat.
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                talent,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFB77900),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DAFTAR POTENSI TERBARU
  // ==========================================

  Widget _buildPotensiList(
    List<Map<String, dynamic>> potensi,
  ) {
    if (potensi.isEmpty) {
      return _buildEmptyPotensi();
    }

    final warnaAvatar = [
      const Color(0xFFFFD9E6),
      const Color(0xFFE3DDFF),
      const Color(0xFFFFE9C2),
    ];

    return Column(
      children: potensi.asMap().entries.map((entry) {
        final index = entry.key;
        final siswa = entry.value;

        final nama = (siswa['nama_siswa'] ?? '-').toString();
        final kelas = (siswa['kelas'] ?? '-').toString();
        final bakat = (siswa['nama_bakat'] ?? '-').toString();

        return _studentCard(
          nama.isNotEmpty ? nama[0].toUpperCase() : '?',
          nama,
          kelas,
          bakat,
          warnaAvatar[index % warnaAvatar.length],
        );
      }).toList(),
    );
  }

  // ==========================================
  // TAMPILAN ERROR
  // ==========================================

  Widget _buildErrorState(Object error) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 45,
              color: Colors.grey,
            ),

            const SizedBox(height: 12),

            const Text(
              'Gagal memuat data dashboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 14),

            ElevatedButton(
              onPressed: _refreshDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // KONTEN DASHBOARD
  // ==========================================

  Widget _buildDashboardContent(
    Map<String, dynamic> data,
  ) {
    final totalSiswa = data['totalSiswa'] ?? 0;
    final totalBakat = data['totalBakat'] ?? 0;
    final totalKegiatan = data['totalKegiatan'] ?? 0;

    final List<Map<String, dynamic>> potensi =
        List<Map<String, dynamic>>.from(
      data['potensiTerbaru'] ?? [],
    );

    return RefreshIndicator(
      color: purple,
      onRefresh: _refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          18,
          20,
          18,
          24,
        ),
        child: Center(
          child: ConstrainedBox(
            // Membatasi lebar konten pada tablet dan desktop.
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dashboard.
                _buildHeader(),

                const SizedBox(height: 18),

                // Sapaan guru.
                _buildWelcome(),

                const SizedBox(height: 24),

                // Statistik dashboard.
                _buildStatistics(
                  totalSiswa,
                  totalBakat,
                  totalKegiatan,
                ),

                const SizedBox(height: 28),

                // Judul potensi terbaru.
                _buildSectionTitle(),

                const SizedBox(height: 14),

                // Daftar potensi terbaru.
                _buildPotensiList(potensi),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 4,
          ),
          child: Row(
            children: [
              _navItem(
                Icons.home_filled,
                'Beranda',
                0,
              ),

              _navItem(
                Icons.people_alt_outlined,
                'Data Siswa',
                1,
              ),

              _navItem(
                Icons.history,
                'Riwayat',
                2,
              ),

              _navItem(
                Icons.assignment_outlined,
                'Penilaian',
                3,
              ),

              _navItem(
                Icons.person_outline,
                'Profil',
                4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ITEM BOTTOM NAVIGATION
  // ==========================================

  Widget _navItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool active = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onNavTap(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 21,
                color: active
                    ? purple
                    : Colors.grey.shade400,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: active
                      ? purple
                      : Colors.grey.shade400,
                  fontWeight: active
                      ? FontWeight.w600
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
  // BUILD HALAMAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Area konten utama.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Konten dashboard dapat di-scroll.
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _dashboardFuture,
                    builder: (context, snapshot) {
                      // Tampilan loading.
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        );
                      }

                      // Tampilan ketika terjadi error.
                      if (snapshot.hasError) {
                        return _buildErrorState(
                          snapshot.error!,
                        );
                      }

                      // Menampilkan data dashboard.
                      return _buildDashboardContent(
                        snapshot.data ?? {},
                      );
                    },
                  ),
                ),

                // Bottom navigation tetap di bagian bawah.
                _buildBottomNavigation(),
              ],
            );
          },
        ),
      ),
    );
  }
}