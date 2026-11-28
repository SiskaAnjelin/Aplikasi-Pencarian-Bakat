import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detail_bakat_page.dart';

class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

class _DataSiswaPageState extends State<DataSiswaPage> {
  // ==========================================
  // CONTROLLER DAN VARIABEL SEARCH, SORT, PAGINATION
  // ==========================================

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';
  String _sortType = 'A-Z';

  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  late Future<List<Map<String, dynamic>>> _siswaFuture;

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF202044);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color background = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();

    // Mengambil data siswa ketika halaman pertama kali dibuka.
    _siswaFuture = _ambilDataSiswa();
  }

  @override
  void dispose() {
    // Membersihkan controller ketika halaman ditutup.
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================
  // MENGAMBIL DATA SISWA DARI SUPABASE
  // ==========================================

  Future<List<Map<String, dynamic>>> _ambilDataSiswa() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Guru belum login. Silakan login kembali.');
    }

    try {
      // Mengambil bidang/deskripsi guru yang sedang login.
      final dataGuru = await supabase
          .from('guru')
          .select('deskripsi')
          .eq('user_id', user.id)
          .maybeSingle();

      if (dataGuru == null) {
        throw Exception('Data guru tidak ditemukan.');
      }

      final bidangGuruTeks =
          (dataGuru['deskripsi'] ?? '').toString().toLowerCase();

      // Menentukan kategori bakat berdasarkan bidang guru.
      final List<String> kategoriList = [];

      if (bidangGuruTeks.isEmpty) {
        kategoriList.addAll(['seni', 'teknologi', 'olahraga']);
      } else {
        if (bidangGuruTeks.contains('seni') ||
            bidangGuruTeks.contains('desain') ||
            bidangGuruTeks.contains('teater') ||
            bidangGuruTeks.contains('musik') ||
            bidangGuruTeks.contains('gambar') ||
            bidangGuruTeks.contains('menari') ||
            bidangGuruTeks.contains('menyanyi') ||
            bidangGuruTeks.contains('lukis') ||
            bidangGuruTeks.contains('vokal') ||
            bidangGuruTeks.contains('tari')) {
          kategoriList.add('seni');
        }

        if (bidangGuruTeks.contains('teknologi') ||
            bidangGuruTeks.contains('rpl') ||
            bidangGuruTeks.contains('tkj') ||
            bidangGuruTeks.contains('robotic') ||
            bidangGuruTeks.contains('coding') ||
            bidangGuruTeks.contains('matematika') ||
            bidangGuruTeks.contains('bahasa') ||
            bidangGuruTeks.contains('akademik') ||
            bidangGuruTeks.contains('it') ||
            bidangGuruTeks.contains('komputer')) {
          kategoriList.add('teknologi');
        }

        if (bidangGuruTeks.contains('olahraga') ||
            bidangGuruTeks.contains('futsal') ||
            bidangGuruTeks.contains('basket') ||
            bidangGuruTeks.contains('voli') ||
            bidangGuruTeks.contains('atletik') ||
            bidangGuruTeks.contains('badminton')) {
          kategoriList.add('olahraga');
        }

        // Jika bidang tidak cocok, tampilkan semua kategori.
        if (kategoriList.isEmpty) {
          kategoriList.addAll(['seni', 'teknologi', 'olahraga']);
        }
      }

      // Mengambil data pengajuan bakat beserta kategori bakat.
      final pengajuan = await supabase
          .from('pengajuan_bakat')
          .select('id_siswa, bakat:id_bakat(nama_bakat, kategori)');

      if (pengajuan.isEmpty) {
        return [];
      }

      // Menyimpan daftar bakat berdasarkan ID siswa.
      final Map<String, List<String>> bakatPerSiswa = {};
      final Set<String> targetIdSiswaSet = {};

      for (final item in pengajuan) {
        final idSiswa = item['id_siswa']?.toString();
        final bakat = item['bakat'];

        if (idSiswa != null && bakat != null) {
          final kategoriBakat =
              (bakat['kategori'] ?? '').toString().toLowerCase();

          final namaBakat =
              (bakat['nama_bakat'] ?? '').toString();

          bool sesuai = false;

          for (final kategori in kategoriList) {
            if (kategoriBakat.contains(kategori)) {
              sesuai = true;
              break;
            }
          }

          // Menyimpan siswa yang bakatnya sesuai dengan bidang guru.
          if (sesuai) {
            targetIdSiswaSet.add(idSiswa);

            bakatPerSiswa.putIfAbsent(idSiswa, () => []);

            if (!bakatPerSiswa[idSiswa]!.contains(namaBakat)) {
              bakatPerSiswa[idSiswa]!.add(namaBakat);
            }
          }
        }
      }

      if (targetIdSiswaSet.isEmpty) {
        return [];
      }

      // Mengambil data siswa berdasarkan ID yang sudah ditemukan.
      final siswaList = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa, kelas, nis, foto_profil')
          .filter('id_siswa', 'in', targetIdSiswaSet.toList());

      final List<Map<String, dynamic>> hasil = [];

      for (final siswa in siswaList) {
        final idStr = siswa['id_siswa'].toString();

        final daftarBakat = bakatPerSiswa[idStr] ?? [];

        hasil.add({
          'id_siswa': siswa['id_siswa'],
          'nama': siswa['nama_siswa'] ?? 'Tanpa Nama',
          'kelas': siswa['kelas'] ?? '-',
          'nis': siswa['nis'] ?? '-',
          'foto_profil': siswa['foto_profil'],
          'bakat': daftarBakat.isNotEmpty
              ? daftarBakat.join(', ')
              : 'Belum ada bakat',
        });
      }

      return hasil;
    } catch (e) {
      debugPrint('ERROR AMBIL DATA SISWA: $e');
      rethrow;
    }
  }

  // ==========================================
  // REFRESH DATA
  // ==========================================

  Future<void> _refreshData() async {
    final futureBaru = _ambilDataSiswa();

    setState(() {
      _siswaFuture = futureBaru;
    });

    await futureBaru;
  }

  // ==========================================
  // SEARCH DAN SORTING
  // ==========================================

  List<Map<String, dynamic>> _filteredSiswa(
    List<Map<String, dynamic>> data,
  ) {
    final hasil = data.where((siswa) {
      final nama = siswa['nama'].toString().toLowerCase();
      final kelas = siswa['kelas'].toString().toLowerCase();
      final bakat = siswa['bakat'].toString().toLowerCase();

      return nama.contains(_searchQuery) ||
          kelas.contains(_searchQuery) ||
          bakat.contains(_searchQuery);
    }).toList();

    // Mengurutkan nama siswa.
    if (_sortType == 'A-Z') {
      hasil.sort((a, b) {
        final namaA = (a['nama'] ?? '').toString().toLowerCase();
        final namaB = (b['nama'] ?? '').toString().toLowerCase();

        return namaA.compareTo(namaB);
      });
    } else {
      hasil.sort((a, b) {
        final namaA = (a['nama'] ?? '').toString().toLowerCase();
        final namaB = (b['nama'] ?? '').toString().toLowerCase();

        return namaB.compareTo(namaA);
      });
    }

    return hasil;
  }

  // ==========================================
  // MEMBUKA DETAIL SISWA
  // ==========================================

  void _bukaDetailSiswa(Map<String, dynamic> siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBakatGuruPage(
          idSiswa: siswa['id_siswa'].toString(),
        ),
      ),
    );
  }

  // ==========================================
  // FOTO PROFIL SISWA
  // ==========================================

  Widget _fotoSiswa(
    Map<String, dynamic> siswa, {
    double size = 64,
  }) {
    final foto = siswa['foto_profil']?.toString();
    final nama = siswa['nama']?.toString() ?? 'S';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: foto != null && foto.trim().isNotEmpty
            ? Image.network(
                foto,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _inisialSiswa(nama);
                },
              )
            : _inisialSiswa(nama),
      ),
    );
  }

  // ==========================================
  // FOTO DEFAULT BERUPA INISIAL
  // ==========================================

  Widget _inisialSiswa(String nama) {
    return Container(
      color: lightPurple,
      alignment: Alignment.center,
      child: Text(
        nama.isNotEmpty ? nama[0].toUpperCase() : 'S',
        style: const TextStyle(
          color: purple,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  // ==========================================
  // SEARCH DAN SORT BAR
  // ==========================================

  Widget _buildSearchSortBar() {
    return Row(
      children: [
        // Kolom pencarian siswa.
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                  _currentPage = 1;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama, kelas, atau bakat...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Tombol pengurutan siswa.
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.sort_rounded,
              color: purple,
            ),
            tooltip: 'Urutkan Siswa',
            initialValue: _sortType,
            onSelected: (value) {
              setState(() {
                _sortType = value;
                _currentPage = 1;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'A-Z',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Nama A - Z'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Z-A',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Nama Z - A'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // CARD DATA SISWA
  // ==========================================

  Widget _buildSiswaCard(
    Map<String, dynamic> siswa, {
    required double fotoSize,
  }) {
    final daftarBakat = siswa['bakat'].toString();
    final bakatPertama = daftarBakat.split(',').first.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _bukaDetailSiswa(siswa),
          child: Row(
            children: [
              // Foto siswa.
              _fotoSiswa(
                siswa,
                size: fotoSize,
              ),

              const SizedBox(width: 12),

              // Informasi siswa.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siswa['nama'] ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: darkPurple,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Kelas: ${siswa['kelas']} | NIS: ${siswa['nis']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 7),

                    // Label bakat siswa.
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        bakatPertama,
                        style: const TextStyle(
                          color: purple,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Ikon menuju halaman detail.
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAMPILAN KETIKA DATA KOSONG
  // ==========================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Siswa tidak ditemukan'
                  : 'Belum ada siswa dengan kategori bakat yang sesuai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAMPILAN KETIKA TERJADI ERROR
  // ==========================================

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal mengambil data siswa',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refreshData,
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
  // PAGINATION
  // ==========================================

  Widget _buildPagination(int totalItems) {
    final totalPages =
        (totalItems / _itemsPerPage).ceil();

    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          // Informasi halaman.
          Expanded(
            child: Text(
              'Hal $_currentPage dari $totalPages ($totalItems siswa)',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Tombol halaman sebelumnya.
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_left,
              size: 22,
            ),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
          ),

          // Tombol halaman berikutnya.
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_right,
              size: 22,
            ),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BUILD HALAMAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // AppBar halaman Data Siswa.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
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
              color: purple,
            ),
          ),
        ],
      ),

      // SafeArea menjaga konten tidak tertutup area sistem.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Mengatur jarak berdasarkan lebar layar.
            final bool layarLebar = constraints.maxWidth > 700;

            final double horizontalPadding =
                layarLebar ? 32 : 16;

            final double fotoSize =
                layarLebar ? 72 : 64;

            return Column(
              children: [
                // ==========================================
                // 1. SEARCH DAN SORT BAR
                // ==========================================

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    14,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 900,
                      ),
                      child: _buildSearchSortBar(),
                    ),
                  ),
                ),

                // ==========================================
                // 2. DAFTAR SISWA
                // ==========================================

                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _siswaFuture,
                    builder: (context, snapshot) {
                      // Kondisi loading.
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: purple,
                          ),
                        );
                      }

                      // Kondisi error.
                      if (snapshot.hasError) {
                        return _buildErrorState(
                          snapshot.error!,
                        );
                      }

                      final data = snapshot.data ?? [];

                      // Melakukan search dan sorting.
                      final filtered = _filteredSiswa(data);

                      // Kondisi data kosong.
                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }

                      // Menghitung jumlah halaman.
                      final totalItems = filtered.length;

                      final totalPages =
                          (totalItems / _itemsPerPage).ceil();

                      // Menjaga halaman tetap valid setelah pencarian.
                      final currentPage =
                          _currentPage.clamp(1, totalPages);

                      if (_currentPage != currentPage) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _currentPage = currentPage;
                            });
                          }
                        });
                      }

                      // Mengambil data sesuai halaman aktif.
                      final startIndex =
                          (currentPage - 1) * _itemsPerPage;

                      final endIndex =
                          (startIndex + _itemsPerPage)
                              .clamp(0, totalItems);

                      final paginatedList = filtered.sublist(
                        startIndex,
                        endIndex,
                      );

                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        color: purple,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 8,
                          ),
                          itemCount: paginatedList.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 900,
                                ),
                                child: _buildSiswaCard(
                                  paginatedList[index],
                                  fotoSize: fotoSize,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // ==========================================
                // 3. BAR NAVIGASI PAGINATION
                // ==========================================

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _siswaFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.hasError ||
                        snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final filteredAll =
                        _filteredSiswa(snapshot.data!);

                    if (filteredAll.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: _buildPagination(
                          filteredAll.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}