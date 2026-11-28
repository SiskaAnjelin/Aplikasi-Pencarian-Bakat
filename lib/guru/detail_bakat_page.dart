import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailBakatGuruPage extends StatefulWidget {
  final String idSiswa;

  const DetailBakatGuruPage({
    super.key,
    this.idSiswa = '',
  });

  @override
  State<DetailBakatGuruPage> createState() =>
      _DetailBakatGuruPageState();
}

class _DetailBakatGuruPageState
    extends State<DetailBakatGuruPage> {

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color yellow = Color(0xFFFFC857);

  // Koneksi Supabase.
  final supabase = Supabase.instance.client;

  // Future untuk mengambil detail siswa.
  late Future<Map<String, dynamic>> detailFuture;

  // Menyimpan ID siswa yang dipilih.
  String _effectiveIdSiswa = '';

  @override
  void initState() {
    super.initState();

    _effectiveIdSiswa = widget.idSiswa;
    detailFuture = loadDetail();
  }

  // ==========================================
  // MENGAMBIL ID SISWA DARI ARGUMENT
  // ==========================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_effectiveIdSiswa.isNotEmpty) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    String id = '';

    if (args is String) {
      id = args;
    } else if (args is Map) {
      id = (args['idSiswa'] ?? args['id_siswa'] ?? '')
          .toString();
    }

    if (id.isNotEmpty) {
      _effectiveIdSiswa = id;
      detailFuture = loadDetail();
    }
  }

  // ==========================================
  // MENGUBAH BIDANG GURU MENJADI KATEGORI BAKAT
  // ==========================================

  Set<String> getKategoriGuru(String bidang) {
    final teks = bidang.toLowerCase().trim();

    final hasil = <String>{};

    if (teks.contains('seni') ||
        teks.contains('desain') ||
        teks.contains('teater') ||
        teks.contains('musik') ||
        teks.contains('gambar') ||
        teks.contains('menari') ||
        teks.contains('menyanyi') ||
        teks.contains('vokal')) {
      hasil.add('seni');
    }

    if (teks.contains('rpl') ||
        teks.contains('teknologi') ||
        teks.contains('robotic') ||
        teks.contains('coding') ||
        teks.contains('matematika') ||
        teks.contains('bahasa') ||
        teks.contains('akademik')) {
      hasil.add('akademik');
    }

    if (teks.contains('olahraga')) {
      hasil.add('olahraga');
    }

    return hasil;
  }

  // ==========================================
  // MEMERIKSA KESESUAIAN KATEGORI BAKAT
  // ==========================================

  bool sesuaiBidang(
    String kategori,
    Set<String> kategoriGuru,
  ) {
    if (kategoriGuru.isEmpty) return true;

    final kategoriBakat = kategori.toLowerCase().trim();

    if (kategoriBakat.isEmpty) return false;

    return kategoriGuru.any(
      (item) => kategoriBakat.contains(item),
    );
  }

  // ==========================================
  // MENGAMBIL DATA DARI SUPABASE
  // ==========================================

  Future<Map<String, dynamic>> loadDetail() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Guru belum login. Silakan login kembali.',
      );
    }

    // ID siswa wajib diterima dari halaman sebelumnya.
    final targetIdSiswa = _effectiveIdSiswa.trim();

    if (targetIdSiswa.isEmpty) {
      throw Exception(
        'ID siswa belum diterima. Silakan kembali ke daftar siswa dan pilih siswa terlebih dahulu.',
      );
    }

    // ======================================
    // 1. MENGAMBIL DATA GURU
    // ======================================

    final dataGuru = await supabase
        .from('guru')
        .select('id_guru, nama_guru, bidang, user_id')
        .eq('user_id', user.id)
        .limit(2);

    if (dataGuru.isEmpty) {
      throw Exception('Data guru tidak ditemukan.');
    }

    if (dataGuru.length > 1) {
      throw Exception(
        'Ditemukan lebih dari satu data guru untuk akun ini.',
      );
    }

    final guru = Map<String, dynamic>.from(dataGuru.first);

    final idGuru = guru['id_guru'].toString();

    final bidangGuru =
        guru['bidang']?.toString() ?? '';

    final kategoriGuru = getKategoriGuru(bidangGuru);

    // ======================================
    // 2. MENGAMBIL DATA SISWA
    // ======================================

    final dataSiswa = await supabase
        .from('siswa')
        .select(
          'id_siswa, nama_siswa, kelas, foto_profil',
        )
        .eq('id_siswa', targetIdSiswa)
        .maybeSingle();

    if (dataSiswa == null) {
      throw Exception('Data siswa tidak ditemukan.');
    }

    final siswa = Map<String, dynamic>.from(dataSiswa);

    // ======================================
    // 3. MENGAMBIL PENGAJUAN BAKAT SISWA
    // ======================================

    final dataPengajuan = await supabase
        .from('pengajuan_bakat')
        .select(
          'id_pengajuan, id_siswa, id_bakat, status, '
          'tanggal_pengajuan, nilai_kreativitas, '
          'nilai_teknik, nilai_konsistensi, rekomendasi, id_guru',
        )
        .eq('id_siswa', targetIdSiswa)
        .order(
          'tanggal_pengajuan',
          ascending: false,
        );

    // ======================================
    // 4. MENGAMBIL DATA BAKAT
    // ======================================

    final dataBakat = await supabase
        .from('bakat')
        .select(
          'id_bakat, nama_bakat, kategori, deskripsi',
        );

    final Map<String, Map<String, dynamic>> bakatById = {
      for (final item in dataBakat)
        item['id_bakat'].toString():
            Map<String, dynamic>.from(item),
    };

    // ======================================
    // 5. FILTER PENGAJUAN SESUAI BIDANG GURU
    // ======================================

    final List<Map<String, dynamic>> daftarBakat = [];

    for (final pengajuanData in dataPengajuan) {
      final pengajuan =
          Map<String, dynamic>.from(pengajuanData);

      final idBakat = pengajuan['id_bakat']?.toString();

      if (idBakat == null || idBakat.isEmpty) continue;

      final bakat = bakatById[idBakat];

      if (bakat == null) continue;

      final kategoriBakat =
          bakat['kategori']?.toString() ?? '';

      if (!sesuaiBidang(kategoriBakat, kategoriGuru)) {
        continue;
      }

      // ==================================
      // 6. MENGAMBIL JADWAL PENGUJIAN
      // ==================================

      final dataJadwal = await supabase
          .from('jadwal_kegiatan')
          .select(
            'id_jadwal, nama_kegiatan, tanggal, waktu, '
            'tempat, status, deskripsi_kegiatan, id_siswa',
          )
          .eq('id_bakat', idBakat)
          .order('tanggal', ascending: true);

      // Mengambil jadwal khusus siswa dan jadwal umum.
      final List<Map<String, dynamic>> jadwal = dataJadwal
          .where((item) {
            final idJadwalSiswa =
                item['id_siswa']?.toString();

            return idJadwalSiswa == targetIdSiswa ||
                item['id_siswa'] == null;
          })
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();

      daftarBakat.add({
        'pengajuan': pengajuan,
        'bakat': bakat,
        'jadwal': jadwal,
      });
    }

    // Mengembalikan seluruh data yang sudah digabungkan.
    return {
      'siswa': siswa,
      'daftarBakat': daftarBakat,
      'guru': guru,
      'idGuru': idGuru,
      'bidangGuru': bidangGuru,
    };
  }

  // ==========================================
  // WARNA STATUS
  // ==========================================

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'unggul':
      case 'selesai':
      case 'disetujui':
      case 'diterima':
        return Colors.green;

      case 'berkembang':
      case 'menunggu':
        return yellow;

      case 'ditolak':
        return Colors.red.shade100;

      case 'belum diajukan':
        return Colors.grey.shade200;

      default:
        return lightPurple;
    }
  }

  Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'unggul':
      case 'selesai':
      case 'disetujui':
      case 'diterima':
        return Colors.white;

      case 'ditolak':
        return Colors.red.shade700;

      case 'menunggu':
      case 'berkembang':
        return darkPurple;

      default:
        return purple;
    }
  }

  // ==========================================
  // WIDGET JADWAL
  // ==========================================

  Widget buildJadwal(Map<String, dynamic> jadwal) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE1DDF5),
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFCFBFF),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: purple,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal['nama_kegiatan']?.toString() ??
                      'Kegiatan Pengujian',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${jadwal['tanggal'] ?? '-'} • ${jadwal['waktu'] ?? '-'}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Tempat: ${jadwal['tempat'] ?? '-'}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),

                if (jadwal['status'] != null) ...[
                  const SizedBox(height: 4),

                  Text(
                    'Status: ${jadwal['status']}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET NILAI
  // ==========================================

  Widget buildNilai(String judul, dynamic nilai) {
    final sudahDinilai = nilai != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              judul,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
            ),
          ),

          Text(
            sudahDinilai
                ? nilai.toString()
                : 'Belum dinilai',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: sudahDinilai ? purple : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET DETAIL BAKAT
  // ==========================================

  Widget buildBakat(Map<String, dynamic> data) {
    final pengajuan =
        data['pengajuan'] as Map<String, dynamic>;

    final bakat =
        data['bakat'] as Map<String, dynamic>;

    final jadwal =
        data['jadwal'] as List<Map<String, dynamic>>;

    final namaBakat =
        bakat['nama_bakat']?.toString() ?? '-';

    final status =
        pengajuan['status']?.toString() ?? 'Menunggu';

    final deskripsi =
        bakat['deskripsi']?.toString() ??
            'Belum ada deskripsi bakat.';

    final rekomendasi =
        pengajuan['rekomendasi']?.toString() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE1DDF5),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama bakat dan status.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  namaBakat,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusTextColor(status),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'Kategori: ${bakat['kategori'] ?? '-'}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            deskripsi,
            style: const TextStyle(
              fontSize: 11,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Hasil Penilaian',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkPurple,
            ),
          ),

          const SizedBox(height: 10),

          buildNilai(
            'Kreativitas',
            pengajuan['nilai_kreativitas'],
          ),

          buildNilai(
            'Teknik',
            pengajuan['nilai_teknik'],
          ),

          buildNilai(
            'Konsistensi',
            pengajuan['nilai_konsistensi'],
          ),

          // Rekomendasi guru.
          if (rekomendasi.trim().isNotEmpty) ...[
            const SizedBox(height: 8),

            const Text(
              'Rekomendasi Guru',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                rekomendasi,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: darkPurple,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          const Text(
            'Jadwal Pengujian',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkPurple,
            ),
          ),

          const SizedBox(height: 9),

          if (jadwal.isEmpty)
            const Text(
              'Belum ada jadwal pengujian.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            )
          else
            ...jadwal.map(
              (item) => buildJadwal(item),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // REFRESH DATA
  // ==========================================

  Future<void> refreshDetail() async {
    final future = loadDetail();

    setState(() {
      detailFuture = future;
    });

    await future;
  }

  // ==========================================
  // WIDGET PROFIL SISWA
  // ==========================================

  Widget buildProfilSiswa(
    Map<String, dynamic> siswa,
  ) {
    final foto =
        siswa['foto_profil']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Foto profil siswa.
          Container(
            width: 60,
            height: 60,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: foto.isNotEmpty
                ? Image.network(
                    foto,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.35),
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.person,
                        size: 36,
                        color: purple,
                      );
                    },
                  )
                : const Icon(
                    Icons.person,
                    size: 36,
                    color: purple,
                  ),
          ),

          const SizedBox(width: 12),

          // Informasi siswa.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  siswa['nama_siswa']?.toString() ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Kelas: ${siswa['kelas'] ?? '-'}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
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
  // TAMPILAN ERROR
  // ==========================================

  Widget buildError(Object error) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 45,
            ),

            const SizedBox(height: 12),

            const Text(
              'Gagal mengambil data siswa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: refreshDetail,
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
  // BUILD RESPONSIF
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Mengikuti ukuran layar perangkat.
      body: SafeArea(
        child: Column(
          children: [
            // ==================================
            // HEADER
            // ==================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: darkPurple,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Detail Bakat Siswa',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: refreshDetail,
                    icon: const Icon(
                      Icons.refresh,
                      color: purple,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================
            // DATA SUPABASE
            // ==================================

            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: detailFuture,

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

                  // Tampilan error.
                  if (snapshot.hasError) {
                    return buildError(snapshot.error!);
                  }

                  // Jika data tidak ditemukan.
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'Data siswa tidak ditemukan.',
                        style: TextStyle(
                          color: darkPurple,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  final siswa =
                      data['siswa'] as Map<String, dynamic>;

                  final daftarBakat =
                      data['daftarBakat']
                          as List<Map<String, dynamic>>;

                  // Mengatur padding berdasarkan lebar layar.
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final lebarPadding =
                          constraints.maxWidth > 700 ? 32.0 : 16.0;

                      return RefreshIndicator(
                        color: purple,
                        onRefresh: refreshDetail,

                        child: ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),

                          padding: EdgeInsets.symmetric(
                            horizontal: lebarPadding,
                            vertical: 12,
                          ),

                          children: [
                            // ==========================
                            // PROFIL SISWA
                            // ==========================

                            buildProfilSiswa(siswa),

                            const SizedBox(height: 22),

                            // ==========================
                            // JUDUL DETAIL BAKAT
                            // ==========================

                            const Text(
                              'Detail Bakat Siswa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '${daftarBakat.length} bakat sesuai bidang keahlian',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ==========================
                            // DAFTAR BAKAT
                            // ==========================

                            if (daftarBakat.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: lightPurple,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 42,
                                      color: purple,
                                    ),

                                    SizedBox(height: 12),

                                    Text(
                                      'Belum ada pengajuan bakat yang sesuai dengan bidang keahlian guru.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: darkPurple,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...daftarBakat.map(
                                (item) => buildBakat(item),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}