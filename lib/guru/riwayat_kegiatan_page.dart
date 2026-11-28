import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatKegiatanPage extends StatefulWidget {
  const RiwayatKegiatanPage({super.key});

  @override
  State<RiwayatKegiatanPage> createState() =>
      _RiwayatKegiatanPageState();
}

class _RiwayatKegiatanPageState extends State<RiwayatKegiatanPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);
  static const Color lightPurple = Color(0xFFEDEBFF);

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> kegiatanList = [];

  bool isLoading = true;
  String selectedFilter = 'Semua';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadRiwayat();
  }

  // ==========================================
  // MENGAMBIL DATA DARI SUPABASE
  // ==========================================

  Future<void> loadRiwayat() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 1. AMBIL JADWAL KEGIATAN
      final response = await supabase
          .from('jadwal_kegiatan')
          .select(
            'id_jadwal, nama_kegiatan, tanggal, waktu, tempat, '
            'status, deskripsi_kegiatan, id_guru, id_bakat, id_siswa',
          )
          .order('tanggal', ascending: false);

      final data = List<Map<String, dynamic>>.from(response);

      debugPrint('========== RIWAYAT KEGIATAN ==========');
      debugPrint('Jumlah jadwal: ${data.length}');
      debugPrint('Data jadwal: $data');

      // 2. AMBIL ID SISWA DAN BAKAT
      final siswaIds = data
          .map((item) => item['id_siswa'])
          .where((id) => id != null)
          .map((id) => id.toString())
          .toSet()
          .toList();

      final bakatIds = data
          .map((item) => item['id_bakat'])
          .where((id) => id != null)
          .map((id) => id.toString())
          .toSet()
          .toList();

      final Map<String, String> siswaMap = {};
      final Map<String, String> bakatMap = {};

      // 3. AMBIL NAMA SISWA
      if (siswaIds.isNotEmpty) {
        final siswaResponse = await supabase
            .from('siswa')
            .select('id_siswa, nama_siswa')
            .inFilter('id_siswa', siswaIds);

        for (final siswa in siswaResponse) {
          siswaMap[siswa['id_siswa'].toString()] =
              (siswa['nama_siswa'] ?? 'Nama siswa').toString();
        }
      }

      // 4. AMBIL NAMA BAKAT
      if (bakatIds.isNotEmpty) {
        final bakatResponse = await supabase
            .from('bakat')
            .select('id_bakat, nama_bakat')
            .inFilter('id_bakat', bakatIds);

        for (final bakat in bakatResponse) {
          bakatMap[bakat['id_bakat'].toString()] =
              (bakat['nama_bakat'] ?? 'Nama bakat').toString();
        }
      }

      // 5. GABUNGKAN DATA JADWAL, SISWA, DAN BAKAT
      final hasil = data.map((item) {
        final idSiswa = item['id_siswa']?.toString();
        final idBakat = item['id_bakat']?.toString();

        return {
          ...item,
          'nama_siswa': idSiswa == null
              ? 'Belum ditentukan'
              : siswaMap[idSiswa] ?? 'Nama siswa tidak ditemukan',
          'nama_bakat': idBakat == null
              ? 'Belum ditentukan'
              : bakatMap[idBakat] ?? 'Nama bakat tidak ditemukan',
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        kegiatanList = hasil;
        isLoading = false;
      });

      debugPrint('Jumlah riwayat berhasil ditampilkan: ${hasil.length}');
    } catch (e, stackTrace) {
      debugPrint('ERROR RIWAYAT KEGIATAN: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ==========================================
  // FILTER STATUS
  // ==========================================

  List<Map<String, dynamic>> get filteredList {
    if (selectedFilter == 'Semua') {
      return kegiatanList;
    }

    return kegiatanList.where((item) {
      final status =
          item['status']?.toString().trim().toLowerCase() ?? '';

      return status == selectedFilter.toLowerCase();
    }).toList();
  }

  // ==========================================
  // FORMAT TANGGAL
  // ==========================================

  String formatTanggal(dynamic tanggal) {
    if (tanggal == null || tanggal.toString().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(tanggal.toString());

    if (date == null) {
      return tanggal.toString();
    }

    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  // ==========================================
  // WARNA STATUS
  // ==========================================

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green.shade100;
      case 'aktif':
        return lightPurple;
      case 'dibatalkan':
        return Colors.red.shade100;
      default:
        return const Color(0xFFFFE9B5);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green.shade800;
      case 'aktif':
        return purple;
      case 'dibatalkan':
        return Colors.red.shade800;
      default:
        return darkPurple;
    }
  }

  // ==========================================
  // INFORMASI KEGIATAN
  // ==========================================

  Widget buildInfo(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: purple),
          const SizedBox(width: 7),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: darkPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU KEGIATAN
  // ==========================================

  Widget buildKegiatanCard(Map<String, dynamic> item) {
    final namaKegiatan =
        item['nama_kegiatan']?.toString() ?? '-';

    final namaSiswa =
        item['nama_siswa']?.toString() ?? '-';

    final namaBakat =
        item['nama_bakat']?.toString() ?? '-';

    final tanggal = formatTanggal(item['tanggal']);

    final waktu = item['waktu']?.toString() ?? '-';

    final tempat = item['tempat']?.toString() ?? '-';

    final status = item['status']?.toString() ?? '-';

    final deskripsi =
        item['deskripsi_kegiatan']?.toString() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE2DFF1),
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: lightPurple,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  color: purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaKegiatan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      namaSiswa,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: getStatusTextColor(status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Divider(
            height: 1,
            color: Color(0xFFECEAF5),
          ),

          const SizedBox(height: 10),

          buildInfo(
            Icons.lightbulb_outline,
            'Bakat',
            namaBakat,
          ),

          buildInfo(
            Icons.calendar_today_outlined,
            'Tanggal',
            tanggal,
          ),

          buildInfo(
            Icons.access_time_rounded,
            'Waktu',
            waktu,
          ),

          buildInfo(
            Icons.location_on_outlined,
            'Tempat',
            tempat,
          ),

          if (deskripsi.trim().isNotEmpty) ...[
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                deskripsi,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // FILTER BUTTON
  // ==========================================

  Widget filterButton(String title) {
    final selected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected ? purple : lightPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : darkPurple,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE
  // ==========================================

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 45,
            color: purple.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          const Text(
            'Belum ada riwayat kegiatan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkPurple,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Data kegiatan akan muncul di sini.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ERROR STATE
  // ==========================================

  Widget errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.red,
              size: 38,
            ),
            const SizedBox(height: 10),
            const Text(
              'Gagal mengambil data riwayat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loadRiwayat,
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar halaman langsung mengikuti ukuran layar perangkat.
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Padding menyesuaikan lebar layar, tanpa menentukan ukuran HP.
            final horizontalPadding =
                constraints.maxWidth >= 600 ? 24.0 : 16.0;

            return Center(
              // Pada layar lebar, konten tetap nyaman dibaca dan tidak melebar
              // tanpa batas. Pada HP, konten menggunakan seluruh lebar tersedia.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    // HEADER
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        12,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.pop(context),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: darkPurple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Riwayat Kegiatan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Muat ulang',
                            onPressed: loadRiwayat,
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: purple,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // JUDUL DAN FILTER
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daftar Riwayat Pengujian',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Pantau kegiatan dan pengujian bakat siswa.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                filterButton('Semua'),
                                const SizedBox(width: 8),
                                filterButton('Aktif'),
                                const SizedBox(width: 8),
                                filterButton('Selesai'),
                                const SizedBox(width: 8),
                                filterButton('Dibatalkan'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),

                    // DAFTAR KEGIATAN
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: purple,
                              ),
                            )
                          : errorMessage != null
                              ? errorState()
                              : filteredList.isEmpty
                                  ? emptyState()
                                  : RefreshIndicator(
                                      color: purple,
                                      onRefresh: loadRiwayat,
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding,
                                          vertical: 8,
                                        ),
                                        itemCount: filteredList.length,
                                        itemBuilder: (context, index) {
                                          return buildKegiatanCard(
                                            filteredList[index],
                                          );
                                        },
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}