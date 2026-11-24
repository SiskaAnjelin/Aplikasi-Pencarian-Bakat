import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detail_bakat_page.dart';

class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

class _DataSiswaPageState extends State<DataSiswaPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  late Future<List<Map<String, dynamic>>> _siswaFuture;

  @override
  void initState() {
    super.initState();
    _siswaFuture = _ambilDataSiswa();
  }

  // ambil data siswa dari supabase
  Future<List<Map<String, dynamic>>> _ambilDataSiswa() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    // ambil seluruh data siswa
    final dataSiswa = await supabase
        .from('siswa')
        .select('id_siswa, nama_siswa, kelas, foto_profil');

    debugPrint('EMAIL GURU: ${user.email}');
    debugPrint('UID GURU: ${user.id}');
    debugPrint('DATA SISWA: $dataSiswa');

    if (dataSiswa.isEmpty) {
      return [];
    }

    // ambil seluruh id siswa
    final idSiswaList = dataSiswa
        .map((siswa) => siswa['id_siswa'])
        .where((id) => id != null)
        .toSet()
        .toList();

    // ambil pengajuan bakat berdasarkan id siswa
    final pengajuan = await supabase
        .from('pengajuan_bakat')
        .select('id_siswa, id_bakat')
        .inFilter('id_siswa', idSiswaList);

    debugPrint('DATA PENGAJUAN BAKAT: $pengajuan');

    // ambil id bakat
    final idBakatList = pengajuan
        .map((item) => item['id_bakat'])
        .where((id) => id != null)
        .toSet()
        .toList();

    // siapkan daftar nama bakat
    Map<String, String> namaBakatById = {};

    if (idBakatList.isNotEmpty) {
      // ambil nama bakat dari tabel bakat
      final dataBakat = await supabase
          .from('bakat')
          .select('id_bakat, nama_bakat')
          .inFilter('id_bakat', idBakatList);

      debugPrint('DATA BAKAT: $dataBakat');

      namaBakatById = {
        for (final bakat in dataBakat)
          bakat['id_bakat'].toString():
              bakat['nama_bakat']?.toString() ?? 'Bakat',
      };
    }

    // kelompokkan bakat berdasarkan id siswa
    final Map<String, List<String>> bakatSiswa = {};

    for (final item in pengajuan) {
      final idSiswa = item['id_siswa']?.toString();
      final idBakat = item['id_bakat']?.toString();

      if (idSiswa == null || idBakat == null) continue;

      final namaBakat = namaBakatById[idBakat];

      if (namaBakat == null) continue;

      bakatSiswa.putIfAbsent(idSiswa, () => []);

      if (!bakatSiswa[idSiswa]!.contains(namaBakat)) {
        bakatSiswa[idSiswa]!.add(namaBakat);
      }
    }

    // gabungkan data siswa dan bakat
    final List<Map<String, dynamic>> hasil = [];

    for (final siswa in dataSiswa) {
      final idSiswa = siswa['id_siswa'].toString();

      final daftarBakat = bakatSiswa[idSiswa] ?? [];

      hasil.add({
        'id_siswa': idSiswa,
        'nama': siswa['nama_siswa']?.toString() ?? 'Nama siswa',
        'kelas': siswa['kelas']?.toString() ?? 'Kelas belum tersedia',
        'foto_profil': siswa['foto_profil']?.toString(),
        'bakat': daftarBakat.isEmpty
            ? 'Belum ada bakat'
            : daftarBakat.join(', '),
      });
    }

    // urutkan nama siswa berdasarkan abjad
    hasil.sort(
      (a, b) => a['nama']
          .toString()
          .toLowerCase()
          .compareTo(b['nama'].toString().toLowerCase()),
    );

    return hasil;
  }

  // filter pencarian siswa
  List<Map<String, dynamic>> _filteredSiswa(
    List<Map<String, dynamic>> data,
  ) {
    return data.where((siswa) {
      final nama = siswa['nama'].toString().toLowerCase();
      final kelas = siswa['kelas'].toString().toLowerCase();
      final bakat = siswa['bakat'].toString().toLowerCase();

      return nama.contains(_searchQuery) ||
          kelas.contains(_searchQuery) ||
          bakat.contains(_searchQuery);
    }).toList();
  }

  // membuka detail bakat siswa
  void _bukaDetailSiswa(Map<String, dynamic> siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBakatGuruPage(
          siswaName: siswa['nama'].toString(),
          kelas: siswa['kelas'].toString(),
        ),
      ),
    );
  }

  // foto profil siswa
  Widget _fotoSiswa(Map<String, dynamic> siswa) {
    final foto = siswa['foto_profil']?.toString();

    return CircleAvatar(
      radius: 26,
      backgroundColor: const Color(0xFFE8E7FF),
      backgroundImage:
          foto != null && foto.isNotEmpty ? NetworkImage(foto) : null,
      child: foto == null || foto.isEmpty
          ? Text(
              siswa['nama'].toString().isNotEmpty
                  ? siswa['nama'].toString()[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          : null,
    );
  }

  // refresh data siswa
  Future<void> _refreshData() async {
    setState(() {
      _siswaFuture = _ambilDataSiswa();
    });

    await _siswaFuture;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FC),

              // app bar
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
                  'Data Siswa',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: _refreshData,
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),

              // body
              body: Column(
                children: [
                  // search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari nama, kelas, atau bakat...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // daftar siswa dari supabase
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _siswaFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6C63FF),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          debugPrint('ERROR DATA SISWA: ${snapshot.error}');

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 45,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Gagal mengambil data siswa',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        }

                        final semuaSiswa = snapshot.data ?? [];
                        final siswaList = _filteredSiswa(semuaSiswa);

                        if (semuaSiswa.isEmpty) {
                          return const Center(
                            child: Text(
                              'Belum ada data siswa',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            // jumlah siswa
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${siswaList.length} siswa ditemukan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // list siswa
                            Expanded(
                              child: siswaList.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 55,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Siswa tidak ditemukan',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Coba gunakan kata kunci lain',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemCount: siswaList.length,
                                      itemBuilder: (context, index) {
                                        final siswa = siswaList[index];

                                        return _buildSiswaCard(siswa);
                                      },
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
          ),
        ),
      ),
    );
  }

  // card siswa
  Widget _buildSiswaCard(Map<String, dynamic> siswa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _bukaDetailSiswa(siswa);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // foto siswa
                _fotoSiswa(siswa),

                const SizedBox(width: 14),

                // nama dan kelas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        siswa['nama'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        siswa['kelas'].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // label bakat
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      siswa['bakat'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
