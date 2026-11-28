import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailJadwalPage extends StatefulWidget {
  const DetailJadwalPage({super.key});

  @override
  State<DetailJadwalPage> createState() => _DetailJadwalPageState();
}

class _DetailJadwalPageState extends State<DetailJadwalPage> {
  // Menghubungkan aplikasi dengan Supabase.
  final supabase = Supabase.instance.client;

  // Warna utama aplikasi.
  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);

  // Variabel untuk mengatur kondisi halaman.
  bool _isLoading = true;
  String _role = '';
  String _error = '';

  // Menyimpan daftar jadwal kegiatan.
  List<Map<String, dynamic>> _jadwal = [];

  @override
  void initState() {
    super.initState();

    // Mengambil data jadwal ketika halaman dibuka.
    _fetchJadwal();
  }

  // ==========================================
  // MENGAMBIL ROLE DAN JADWAL
  // ==========================================

  Future<void> _fetchJadwal() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Mengambil akun yang sedang login.
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Akun belum login.');
      }

      String role = '';
      String? idRole;

      // Mengecek apakah akun merupakan siswa.
      final siswa = await supabase
          .from('siswa')
          .select('id_siswa')
          .eq('user_id', user.id)
          .maybeSingle();

      if (siswa != null) {
        role = 'siswa';
        idRole = siswa['id_siswa'].toString();
      } else {
        // Mengecek apakah akun merupakan guru.
        final guru = await supabase
            .from('guru')
            .select('id_guru')
            .eq('user_id', user.id)
            .maybeSingle();

        if (guru != null) {
          role = 'guru';
          idRole = guru['id_guru'].toString();
        } else {
          // Mengecek apakah akun merupakan admin.
          final admin = await supabase
              .from('admin')
              .select('id_admin')
              .eq('user_id', user.id)
              .maybeSingle();

          if (admin != null) {
            role = 'admin';
            idRole = admin['id_admin'].toString();
          }
        }
      }

      // Memastikan role akun berhasil ditemukan.
      if (role.isEmpty || idRole == null) {
        throw Exception('Role akun tidak ditemukan.');
      }

      List<Map<String, dynamic>> jadwalList = [];

      // ======================================
      // ADMIN: MENGAMBIL SEMUA JADWAL
      // ======================================

      if (role == 'admin') {
        final response = await supabase
            .from('jadwal_kegiatan')
            .select()
            .order('tanggal', ascending: true);

        jadwalList = List<Map<String, dynamic>>.from(response);
      }

      // ======================================
      // GURU: JADWAL SESUAI ID GURU LOGIN
      // ======================================

      else if (role == 'guru') {
        final response = await supabase
            .from('jadwal_kegiatan')
            .select()
            .eq('id_guru', idRole)
            .order('tanggal', ascending: true);

        jadwalList = List<Map<String, dynamic>>.from(response);
      }

      // ======================================
      // SISWA: JADWAL SESUAI BAKAT DIAJUKAN
      // ======================================

      else if (role == 'siswa') {
        final pengajuan = await supabase
            .from('pengajuan_bakat')
            .select('id_bakat')
            .eq('id_siswa', idRole);

        final List<String> idBakat = pengajuan
            .map<String?>((item) => item['id_bakat']?.toString())
            .whereType<String>()
            .toSet()
            .toList();

        if (idBakat.isNotEmpty) {
          final response = await supabase
              .from('jadwal_kegiatan')
              .select()
              .inFilter('id_bakat', idBakat)
              .order('tanggal', ascending: true);

          jadwalList = List<Map<String, dynamic>>.from(response);
        }
      }

      // ======================================
      // MENGAMBIL ID GURU DAN ID BAKAT
      // ======================================

      final guruIds = jadwalList
          .map((item) => item['id_guru']?.toString())
          .whereType<String>()
          .toSet()
          .toList();

      final bakatIds = jadwalList
          .map((item) => item['id_bakat']?.toString())
          .whereType<String>()
          .toSet()
          .toList();

      Map<String, Map<String, dynamic>> guruMap = {};
      Map<String, Map<String, dynamic>> bakatMap = {};

      // ======================================
      // MENGAMBIL DATA GURU
      // ======================================

      if (guruIds.isNotEmpty) {
        final guruResponse = await supabase
            .from('guru')
            .select('id_guru, nama_guru, deskripsi')
            .inFilter('id_guru', guruIds);

        for (final item in guruResponse) {
          guruMap[item['id_guru'].toString()] =
              Map<String, dynamic>.from(item);
        }
      }

      // ======================================
      // MENGAMBIL DATA BAKAT
      // ======================================

      if (bakatIds.isNotEmpty) {
        final bakatResponse = await supabase
            .from('bakat')
            .select('id_bakat, nama_bakat, kategori')
            .inFilter('id_bakat', bakatIds);

        for (final item in bakatResponse) {
          bakatMap[item['id_bakat'].toString()] =
              Map<String, dynamic>.from(item);
        }
      }

      // ======================================
      // MENGGABUNGKAN DATA JADWAL
      // ======================================

      final hasil = jadwalList.map((item) {
        final guruId = item['id_guru']?.toString();
        final bakatId = item['id_bakat']?.toString();

        final dataGuru = guruMap[guruId];
        final dataBakat = bakatMap[bakatId];

        return {
          ...item,
          'nama_guru': dataGuru?['nama_guru'] ?? '-',
          'bidang_guru': dataGuru?['deskripsi'] ?? '-',
          'nama_bakat': dataBakat?['nama_bakat'] ?? '-',
          'kategori_bakat': dataBakat?['kategori'] ?? '-',
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _role = role;
        _jadwal = hasil;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil jadwal: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ==========================================
  // FORMAT TANGGAL
  // ==========================================

  DateTime? _parseTanggal(dynamic tanggal) {
    if (tanggal == null) return null;
    return DateTime.tryParse(tanggal.toString());
  }

  String _formatHari(dynamic tanggal) {
    final date = _parseTanggal(tanggal);
    return date?.day.toString() ?? '-';
  }

  String _formatBulanTahun(dynamic tanggal) {
    final date = _parseTanggal(tanggal);
    if (date == null) return '-';

    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'Mei', 'Jun', 'Jul', 'Agu',
      'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${bulan[date.month - 1]}\n${date.year}';
  }

  String _formatTanggal(dynamic tanggal) {
    final date = _parseTanggal(tanggal);
    if (date == null) return '-';

    const bulan = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  // ==========================================
  // WARNA STATUS
  // ==========================================

  Color _warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'terdaftar':
      case 'disetujui':
        return const Color(0xFFD1F2D9);

      case 'selesai':
        return const Color(0xFFD3E3FD);

      case 'dibatalkan':
      case 'ditolak':
        return const Color(0xFFFFDADA);

      default:
        return const Color(0xFFFFF0CC);
    }
  }

  Color _warnaTeksStatus(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
      case 'terdaftar':
      case 'disetujui':
        return const Color(0xFF1E7E34);

      case 'selesai':
        return const Color(0xFF2456A6);

      case 'dibatalkan':
      case 'ditolak':
        return Colors.red;

      default:
        return const Color(0xFF946200);
    }
  }

  // ==========================================
  // KARTU JADWAL
  // ==========================================

  Widget _kartuJadwal(Map<String, dynamic> item) {
    final namaKegiatan =
        item['nama_kegiatan']?.toString() ?? '-';

    final waktu = item['waktu']?.toString() ?? '-';
    final tempat = item['tempat']?.toString() ?? '-';
    final status = item['status']?.toString() ?? '-';

    final guru = item['nama_guru']?.toString() ?? '-';
    final bidang = item['bidang_guru']?.toString() ?? '-';

    final bakat = item['nama_bakat']?.toString() ?? '-';
    final kategori = item['kategori_bakat']?.toString() ?? '-';

    final deskripsi =
        item['deskripsi_kegiatan']?.toString() ?? '-';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      // Isi kartu jadwal.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak tanggal kegiatan.
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3CFF8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatHari(item['tanggal']),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: darkPurple,
                      ),
                    ),
                    Text(
                      _formatBulanTahun(item['tanggal']),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: darkPurple,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Informasi utama kegiatan.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaKegiatan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 7),

                    _infoRow(
                      Icons.calendar_today_outlined,
                      _formatTanggal(item['tanggal']),
                    ),

                    const SizedBox(height: 4),

                    _infoRow(Icons.access_time, waktu),

                    const SizedBox(height: 4),

                    _infoRow(
                      Icons.location_on_outlined,
                      tempat,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 8),

          _detailRow(
            Icons.category_outlined,
            'Nama Bakat',
            bakat,
          ),

          const SizedBox(height: 10),

          _detailRow(
            Icons.interests_outlined,
            'Kategori',
            kategori,
          ),

          const SizedBox(height: 10),

          _detailRow(
            Icons.person_outline,
            'Guru Juri',
            guru,
          ),

          const SizedBox(height: 10),

          _detailRow(
            Icons.school_outlined,
            'Bidang Guru',
            bidang,
          ),

          const SizedBox(height: 15),

          const Text(
            'Deskripsi Kegiatan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 7),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              deskripsi.isEmpty ? '-' : deskripsi,
              style: const TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Status',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Label status kegiatan.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: _warnaStatus(status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _warnaTeksStatus(status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BARIS INFORMASI
  // ==========================================

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: Colors.grey,
        ),

        const SizedBox(width: 5),

        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  // Baris detail dengan lebar label yang fleksibel.
  Widget _detailRow(
    IconData icon,
    String label,
    String value,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: purple,
              size: 18,
            ),

            const SizedBox(width: 9),

            SizedBox(
              width: constraints.maxWidth < 350 ? 75 : 95,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ),

            const Text(
              ': ',
              style: TextStyle(fontSize: 11),
            ),

            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: darkPurple,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // TAMPILAN KOSONG
  // ==========================================

  Widget _emptyState() {
    String pesan;

    if (_role == 'siswa') {
      pesan = 'Belum ada jadwal untuk bakat yang kamu ajukan.';
    } else if (_role == 'guru') {
      pesan = 'Belum ada jadwal yang ditugaskan kepada kamu.';
    } else {
      pesan = 'Jadwal kegiatan belum tersedia.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 55),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 12),

            const Text(
              'Belum ada jadwal kegiatan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                pesan,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUILD RESPONSIF
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // SafeArea menjaga konten agar tidak tertutup
      // oleh status bar dan navigasi perangkat.
      body: SafeArea(
        child: Column(
          children: [
            // ==================================
            // HEADER
            // ==================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Detail Jadwal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Tombol refresh data.
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _fetchJadwal,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: purple,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================
            // LABEL ROLE
            // ==================================

            if (_role.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _role == 'admin'
                        ? 'Semua Jadwal'
                        : _role == 'guru'
                            ? 'Jadwal Penilaian Saya'
                            : 'Jadwal Kegiatan Saya',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // ==================================
            // ISI HALAMAN
            // ==================================

            Expanded(
              child: _isLoading

                  // Tampilan loading.
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: purple,
                      ),
                    )

                  // Tampilan jika terjadi error.
                  : _error.isNotEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  _error,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                ElevatedButton(
                                  onPressed: _fetchJadwal,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: purple,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )

                      // Tampilan jika jadwal kosong.
                      : _jadwal.isEmpty
                          ? RefreshIndicator(
                              color: purple,
                              onRefresh: _fetchJadwal,
                              child: ListView(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                            .size
                                            .height *
                                        0.55,
                                    child: _emptyState(),
                                  ),
                                ],
                              ),
                            )

                          // Tampilan daftar jadwal.
                          : RefreshIndicator(
                              color: purple,
                              onRefresh: _fetchJadwal,
                              child: ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),

                                // Padding menyesuaikan lebar layar.
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width > 600
                                          ? 32
                                          : 16,
                                  vertical: 8,
                                ),

                                itemCount: _jadwal.length,

                                itemBuilder: (context, index) {
                                  return _kartuJadwal(
                                    _jadwal[index],
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}