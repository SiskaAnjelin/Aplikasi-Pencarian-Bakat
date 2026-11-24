import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenilaianBakatPage extends StatefulWidget {
  const PenilaianBakatPage({super.key});

  @override
  State<PenilaianBakatPage> createState() =>
      _PenilaianBakatPageState();
}

class _PenilaianBakatPageState extends State<PenilaianBakatPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);

  final supabase = Supabase.instance.client;

  int _selectedTab = 0;

  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _ambilDataPenilaian();
  }

  // ambil data pengajuan, siswa, dan bakat dari supabase
  Future<List<Map<String, dynamic>>> _ambilDataPenilaian() async {
    try {
      // ambil semua pengajuan bakat
      final pengajuan = await supabase
          .from('pengajuan_bakat')
          .select()
          .order('tanggal_pengajuan', ascending: false);

      debugPrint('JUMLAH PENGAJUAN: ${pengajuan.length}');
      debugPrint('DATA PENGAJUAN: $pengajuan');

      // ambil data siswa
      final siswa = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa, kelas');

      debugPrint('JUMLAH SISWA: ${siswa.length}');

      // ambil data bakat
      final bakat = await supabase
          .from('bakat')
          .select('id_bakat, nama_bakat, kategori');

      debugPrint('JUMLAH BAKAT: ${bakat.length}');

      // buat pencocokan berdasarkan id siswa
      final siswaById = {
        for (final item in siswa)
          item['id_siswa'].toString(): item,
      };

      // buat pencocokan berdasarkan id bakat
      final bakatById = {
        for (final item in bakat)
          item['id_bakat'].toString(): item,
      };

      final hasil = <Map<String, dynamic>>[];

      // gabungkan data pengajuan dengan siswa dan bakat
      for (final item in pengajuan) {
        final dataSiswa =
            siswaById[item['id_siswa'].toString()];

        final dataBakat =
            bakatById[item['id_bakat'].toString()];

        debugPrint('ID PENGAJUAN: ${item['id_pengajuan']}');
        debugPrint('DATA SISWA COCOK: $dataSiswa');
        debugPrint('DATA BAKAT COCOK: $dataBakat');

        hasil.add({
          ...item,
          'nama_siswa':
              dataSiswa?['nama_siswa'] ?? 'Siswa tidak ditemukan',
          'kelas':
              dataSiswa?['kelas'] ?? 'Kelas belum tersedia',
          'nama_bakat':
              dataBakat?['nama_bakat'] ?? 'Bakat tidak ditemukan',
          'kategori':
              dataBakat?['kategori'] ?? 'Kategori belum tersedia',
        });
      }

      debugPrint('TOTAL DATA DITAMPILKAN: ${hasil.length}');

      return hasil;
    } catch (e) {
      debugPrint('ERROR AMBIL DATA PENILAIAN: $e');
      rethrow;
    }
  }

  // muat ulang data
  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = _ambilDataPenilaian();
    });

    await _dataFuture;
  }

  // filter data berdasarkan status
  List<Map<String, dynamic>> _filterData(
    List<Map<String, dynamic>> data,
  ) {
    if (_selectedTab == 0) {
      return data;
    }

    final statusDipilih = [
      '',
      'menunggu',
      'dalam proses',
      'disetujui',
    ][_selectedTab];

    return data.where((item) {
      final status = item['status']
              ?.toString()
              .toLowerCase()
              .trim() ??
          '';

      return status == statusDipilih;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _phoneFrame(
      Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 55,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: darkPurple,
              size: 19,
            ),
          ),
          title: const Text(
            'Penilaian Bakat',
            style: TextStyle(
              color: darkPurple,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _refreshData,
              icon: const Icon(
                Icons.refresh,
                color: purple,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // tab status pengajuan
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab('Semua', 0),
                    const SizedBox(width: 7),
                    _buildTab('Menunggu', 1),
                    const SizedBox(width: 7),
                    _buildTab('Dalam Proses', 2),
                    const SizedBox(width: 7),
                    _buildTab('Disetujui', 3),
                  ],
                ),
              ),
            ),

            // daftar pengajuan dari supabase
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dataFuture,
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
                              size: 38,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Gagal mengambil data dari Supabase',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _refreshData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final semuaData = snapshot.data ?? [];
                  final filteredData = _filterData(semuaData);

                  if (semuaData.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada pengajuan bakat',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }

                  if (filteredData.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada pengajuan pada status ini',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${filteredData.length} pengajuan ditemukan',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Expanded(
                        child: RefreshIndicator(
                          color: purple,
                          onRefresh: _refreshData,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              return _buildPengajuanCard(
                                filteredData[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // tampilan tab status
  Widget _buildTab(String label, int index) {
    final selected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? purple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? purple : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  // card data pengajuan
  Widget _buildPengajuanCard(Map<String, dynamic> item) {
    final nama = item['nama_siswa'].toString();
    final bakat = item['nama_bakat'].toString();
    final kelas = item['kelas'].toString();
    final status = item['status']?.toString() ?? 'Menunggu';

    Color statusColor;

    switch (status.toLowerCase().trim()) {
      case 'menunggu':
        statusColor = Colors.orange;
        break;
      case 'dalam proses':
        statusColor = Colors.blue;
        break;
      case 'disetujui':
        statusColor = Colors.green;
        break;
      case 'ditolak':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
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
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE8E7FF),
            child: Text(
              nama.isNotEmpty ? nama[0].toUpperCase() : '?',
              style: const TextStyle(
                color: purple,
                fontSize: 17,
                fontWeight: FontWeight.bold,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$bakat • $kelas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// frame tampilan hp
Widget _phoneFrame(Widget child) {
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
            borderRadius: BorderRadius.circular(38),
          ),
          child: child,
        ),
      ),
    ),
  );
}
