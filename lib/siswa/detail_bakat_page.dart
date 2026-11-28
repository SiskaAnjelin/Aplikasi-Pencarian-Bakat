
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailBakatPage extends StatefulWidget {
  final String idBakat;
  final String status;

  const DetailBakatPage({
    super.key,
    this.idBakat = '',
    this.status = 'Belum diajukan',
  });

  @override
  State<DetailBakatPage> createState() => _DetailBakatPageState();
}

class _DetailBakatPageState extends State<DetailBakatPage> {
  final supabase = Supabase.instance.client;

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);

  late Future<Map<String, dynamic>> futureBakat;

  String _effectiveIdBakat = '';
  String _effectiveStatus = 'Belum diajukan';

  @override
  void initState() {
    super.initState();
    _effectiveIdBakat = widget.idBakat;
    _effectiveStatus = widget.status;
    futureBakat = ambilDetailBakat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_effectiveIdBakat.isNotEmpty) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String && args.isNotEmpty) {
      _effectiveIdBakat = args;
      futureBakat = ambilDetailBakat();
    } else if (args is Map) {
      _effectiveIdBakat =
          (args['idBakat'] ?? args['id_bakat'] ?? '').toString();

      _effectiveStatus =
          (args['status'] ?? _effectiveStatus).toString();

      if (_effectiveIdBakat.isNotEmpty) {
        futureBakat = ambilDetailBakat();
      }
    }
  }

  // ==========================================
  // AMBIL DATA BAKAT DARI SUPABASE
  // ==========================================

  Future<Map<String, dynamic>> ambilDetailBakat() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login. Silakan login kembali.');
    }

    // 1. AMBIL DATA SISWA YANG SEDANG LOGIN
    final dataSiswa = await supabase
        .from('siswa')
        .select('id_siswa, nama_siswa, user_id')
        .eq('user_id', user.id)
        .limit(2);

    if (dataSiswa.isEmpty) {
      throw Exception(
        'Data siswa tidak ditemukan. Periksa user_id pada tabel siswa.',
      );
    }

    if (dataSiswa.length > 1) {
      throw Exception(
        'Terdapat lebih dari satu data siswa pada akun ini.',
      );
    }

    final idSiswa = dataSiswa.first['id_siswa'].toString();

    // 2. ID BAKAT HARUS BERASAL DARI PILIHAN SISWA
    final targetIdBakat = _effectiveIdBakat.trim();

    if (targetIdBakat.isEmpty) {
      throw Exception(
        'ID bakat belum diterima. Silakan pilih bakat dari halaman sebelumnya.',
      );
    }

    // 3. AMBIL DETAIL BAKAT
    final dataBakat = await supabase
        .from('bakat')
        .select('id_bakat, nama_bakat, deskripsi, kategori')
        .eq('id_bakat', targetIdBakat)
        .maybeSingle();

    if (dataBakat == null) {
      throw Exception('Data bakat tidak ditemukan.');
    }

    // 4. AMBIL PENGAJUAN MILIK SISWA UNTUK BAKAT TERSEBUT
    final dataPengajuan = await supabase
        .from('pengajuan_bakat')
        .select(
          'id_pengajuan, id_siswa, id_bakat, status, '
          'tanggal_pengajuan, rekomendasi',
        )
        .eq('id_siswa', idSiswa)
        .eq('id_bakat', targetIdBakat)
        .order('tanggal_pengajuan', ascending: false)
        .limit(1);

    String statusPengajuan = 'Belum diajukan';
    String rekomendasi = '';
    String tanggalPengajuan = '';

    if (dataPengajuan.isNotEmpty) {
      final pengajuan = dataPengajuan.first;

      statusPengajuan =
          pengajuan['status']?.toString() ?? 'Menunggu';

      rekomendasi =
          pengajuan['rekomendasi']?.toString() ?? '';

      tanggalPengajuan =
          pengajuan['tanggal_pengajuan']?.toString() ?? '';
    }

    return {
      ...Map<String, dynamic>.from(dataBakat),
      'id_siswa': idSiswa,
      'status_pengajuan': statusPengajuan,
      'rekomendasi': rekomendasi,
      'tanggal_pengajuan': tanggalPengajuan,
    };
  }

  // ==========================================
  // IKON SESUAI NAMA BAKAT
  // ==========================================

  IconData pilihIcon(String nama) {
    final namaBakat = nama.toLowerCase();

    if (namaBakat.contains('nyanyi')) {
      return Icons.music_note_rounded;
    } else if (namaBakat.contains('gambar')) {
      return Icons.draw_outlined;
    } else if (namaBakat.contains('coding')) {
      return Icons.code;
    } else if (namaBakat.contains('menari')) {
      return Icons.accessibility_new;
    } else if (namaBakat.contains('desain')) {
      return Icons.palette_outlined;
    } else if (namaBakat.contains('matematika')) {
      return Icons.calculate_outlined;
    } else if (namaBakat.contains('bahasa')) {
      return Icons.translate;
    } else if (namaBakat.contains('public speaking')) {
      return Icons.record_voice_over;
    }

    return Icons.star_rounded;
  }

  // ==========================================
  // WARNA STATUS
  // ==========================================

  Color warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
      case 'unggul':
      case 'diterima':
        return purple;

      case 'ditolak':
        return Colors.red;

      case 'belum diajukan':
        return Colors.grey;

      default:
        return const Color(0xFFE69500);
    }
  }

  Color backgroundStatus(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
      case 'unggul':
      case 'diterima':
        return const Color(0xFFEDEBFF);

      case 'ditolak':
        return const Color(0xFFFFE8E8);

      case 'belum diajukan':
        return const Color(0xFFF0F0F0);

      default:
        return const Color(0xFFFFF1D6);
    }
  }

  // ==========================================
  // COBA AMBIL DATA LAGI
  // ==========================================

  Future<void> cobaLagi() async {
    setState(() {
      futureBakat = ambilDetailBakat();
    });

    await futureBakat;
  }

  // ==========================================
  // BUILD HALAMAN
  // ==========================================

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
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Color(0xFF1A1A2E),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Detail Bakat',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),

              body: FutureBuilder<Map<String, dynamic>>(
                future: futureBakat,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: purple,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 45,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Gagal mengambil detail bakat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: cobaLagi,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Data bakat tidak ditemukan'),
                    );
                  }

                  final data = snapshot.data!;

                  final nama =
                      data['nama_bakat']?.toString() ?? '-';

                  final kategori =
                      data['kategori']?.toString() ?? '-';

                  final deskripsi =
                      data['deskripsi']?.toString() ?? '-';

                  final status =
                      data['status_pengajuan']?.toString() ??
                          'Belum diajukan';

                  final rekomendasi =
                      data['rekomendasi']?.toString() ?? '';

                  final tanggalPengajuan =
                      data['tanggal_pengajuan']?.toString() ?? '';

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ILUSTRASI BAKAT
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDEBFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Icon(
                              pilihIcon(nama),
                              size: 85,
                              color: purple,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // NAMA BAKAT DAN STATUS
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                nama,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: backgroundStatus(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: warnaStatus(status),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // DESKRIPSI
                        Text(
                          deskripsi,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),

                        if (tanggalPengajuan.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Tanggal pengajuan: $tanggalPengajuan',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // KATEGORI
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFEAEAF2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                color: purple,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kategori Bakat',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    kategori,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: darkPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // REKOMENDASI DARI SUPABASE
                        const Text(
                          'Rekomendasi Pengembangan Bakat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),

                        const SizedBox(height: 14),

                        if (rekomendasi.trim().isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFEAEAF2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDEBFF),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb_outline,
                                    size: 21,
                                    color: purple,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    rekomendasi,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: darkPurple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFEAEAF2),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: purple,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Belum ada rekomendasi dari guru.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // BOTTOM NAVIGATION
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 2,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: purple,
                unselectedItemColor: Colors.grey,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                onTap: (index) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/dashboard_siswa',
                    );
                  } else if (index == 1) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/daftar_bakat',
                    );
                  } else if (index == 3) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/profil_siswa',
                    );
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    activeIcon: Icon(Icons.search),
                    label: 'Cari Bakat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star_outline),
                    activeIcon: Icon(Icons.star),
                    label: 'Detail',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}