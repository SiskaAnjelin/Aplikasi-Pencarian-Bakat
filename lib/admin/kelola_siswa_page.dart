import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_siswa_page.dart';

class KelolaSiswaPage extends StatefulWidget {
  final bool standalone;

  const KelolaSiswaPage({
    super.key,
    this.standalone = false,
  });

  @override
  State<KelolaSiswaPage> createState() => _KelolaSiswaPageState();
}

class _KelolaSiswaPageState extends State<KelolaSiswaPage> {
  // Koneksi Supabase
  final supabase = Supabase.instance.client;

  // ==========================================
  // VARIABEL SEARCH, SORT, DAN PAGINATION
  // ==========================================

  String _searchQuery = '';
  String _sortType = 'A-Z';

  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  late Future<List<Map<String, dynamic>>> _futureSiswa;

  // Warna utama aplikasi
  static const Color purple = Color(0xFF6C5CFF);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color background = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  // ==========================================
  // MENGAMBIL DATA SISWA DARI SUPABASE
  // ==========================================

  void _loadSiswa() {
    _futureSiswa = supabase
        .from('siswa')
        .select()
        .order('nama_siswa', ascending: true);
  }

  // ==========================================
  // REFRESH DATA SISWA
  // ==========================================

  Future<void> _refreshSiswa() async {
    setState(() {
      _loadSiswa();
    });

    await _futureSiswa;
  }

  // ==========================================
  // MENGHAPUS DATA SISWA
  // ==========================================

  Future<void> _hapusSiswa(dynamic id, String nama) async {
    if (id == null) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Hapus Data Siswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus data $nama?',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      await supabase
          .from('siswa')
          .delete()
          .eq('id_siswa', id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data $nama berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );

      await _refreshSiswa();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus siswa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================
  // FOTO PROFIL SISWA
  // ==========================================

  Widget fotoProfil(Map<String, dynamic> item, String nama) {
    final foto = item['foto_profil']?.toString();

    return Container(
      width: 60,
      height: 60,
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
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => fotoDefault(nama),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: purple,
                      strokeWidth: 2,
                    ),
                  );
                },
              )
            : fotoDefault(nama),
      ),
    );
  }

  // ==========================================
  // FOTO DEFAULT JIKA TIDAK ADA FOTO PROFIL
  // ==========================================

  Widget fotoDefault(String nama) {
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
  // MENGURUTKAN DATA SISWA
  // ==========================================

  List<Map<String, dynamic>> _prosesData(
    List<Map<String, dynamic>> data,
  ) {
    // Filter berdasarkan nama siswa
    final filtered = data.where((item) {
      final nama = (
        item['nama_siswa'] ?? item['nama'] ?? ''
      ).toString().toLowerCase();

      return nama.contains(_searchQuery.toLowerCase());
    }).toList();

    // Mengurutkan nama siswa
    filtered.sort((a, b) {
      final namaA = (
        a['nama_siswa'] ?? a['nama'] ?? ''
      ).toString().toLowerCase();

      final namaB = (
        b['nama_siswa'] ?? b['nama'] ?? ''
      ).toString().toLowerCase();

      if (_sortType == 'A-Z') {
        return namaA.compareTo(namaB);
      }

      return namaB.compareTo(namaA);
    });

    return filtered;
  }

  // ==========================================
  // MEMBUAT TOMBOL TAMBAH SISWA
  // ==========================================

  Widget _tombolTambah() {
    return ElevatedButton.icon(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TambahSiswaPage(),
          ),
        );

        if (!mounted) return;

        await _refreshSiswa();
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text(
        'Tambah Siswa',
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ==========================================
  // SEARCH DAN SORTING
  // ==========================================

  Widget _searchDanSort() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _currentPage = 1;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari nama siswa...',
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: purple,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Menu pengurutan
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text('Nama A - Z'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Z-A',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 18,
                    ),
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

  Widget _cardSiswa(Map<String, dynamic> item) {
    final nama = (
      item['nama_siswa'] ?? item['nama'] ?? 'Siswa'
    ).toString();

    final kelas = (item['kelas'] ?? '-').toString();
    final nis = (item['nis'] ?? '-').toString();
    final email = (item['email'] ?? '-').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // LayoutBuilder menyesuaikan isi card dengan lebar layar
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 380;

          return Row(
            children: [
              fotoProfil(item, nama),
              const SizedBox(width: 12),

              // Informasi siswa
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelas: $kelas | NIS: $nis',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol edit dan hapus
              if (!isNarrow) ...[
                _tombolAksi(item, nama),
              ] else ...[
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert,
                    color: purple,
                  ),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await _editSiswa(item);
                    } else if (value == 'hapus') {
                      await _hapusSiswa(
                        item['id_siswa'] ?? item['id'],
                        nama,
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'hapus',
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // TOMBOL EDIT DAN HAPUS
  // ==========================================

  Widget _tombolAksi(
    Map<String, dynamic> item,
    String nama,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 35,
          ),
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.blue,
            size: 18,
          ),
          onPressed: () => _editSiswa(item),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 35,
          ),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 18,
          ),
          onPressed: () {
            _hapusSiswa(
              item['id_siswa'] ?? item['id'],
              nama,
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // NAVIGASI EDIT SISWA
  // ==========================================

  Future<void> _editSiswa(
    Map<String, dynamic> item,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahSiswaPage(
          siswaData: item,
        ),
      ),
    );

    if (!mounted) return;

    await _refreshSiswa();
  }

  // ==========================================
  // PAGINATION
  // ==========================================

  Widget _pagination(int totalItems) {
    final totalPages = (totalItems / _itemsPerPage)
        .ceil()
        .clamp(1, 9999);

    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Hal $_currentPage dari $totalPages ($totalItems siswa)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 20,
                    ),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 20,
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
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // TAMPILAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // AppBar halaman
      appBar: AppBar(
        title: const Text(
          'Data Siswa',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),

      // SafeArea menjaga konten tidak tertutup area sistem
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Lebar konten dibatasi agar nyaman di tablet dan desktop,
            // tetapi tetap mengikuti layar HP.
            final horizontalPadding =
                constraints.maxWidth < 400 ? 12.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 14,
                  ),
                  child: Column(
                    children: [
                      // Search dan sorting
                      _searchDanSort(),

                      const SizedBox(height: 10),

                      // Tombol tambah siswa
                      Align(
                        alignment: Alignment.centerRight,
                        child: _tombolTambah(),
                      ),

                      const SizedBox(height: 12),

                      // ==========================================
                      // LIST DATA SISWA
                      // ==========================================

                      Expanded(
                        child: FutureBuilder<
                            List<Map<String, dynamic>>>(
                          future: _futureSiswa,
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
                                child: Text(
                                  'Terjadi kesalahan: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }

                            final data = snapshot.data ?? [];

                            // Search dan sorting
                            final filtered = _prosesData(data);

                            // Jika tidak ada data
                            if (filtered.isEmpty) {
                              return RefreshIndicator(
                                color: purple,
                                onRefresh: _refreshSiswa,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: constraints.maxHeight * 0.45,
                                      child: Center(
                                        child: Text(
                                          _searchQuery.isEmpty
                                              ? 'Belum ada data siswa.'
                                              : 'Siswa tidak ditemukan.',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Menghitung pagination
                            final totalItems = filtered.length;

                            final totalPages =
                                (totalItems / _itemsPerPage)
                                    .ceil()
                                    .clamp(1, 9999);

                            // Menjaga halaman tetap valid
                            final safePage =
                                _currentPage.clamp(1, totalPages);

                            if (_currentPage != safePage) {
                              _currentPage = safePage;
                            }

                            final startIndex =
                                (safePage - 1) * _itemsPerPage;

                            final endIndex =
                                (startIndex + _itemsPerPage)
                                    .clamp(0, totalItems);

                            final paginatedList =
                                filtered.sublist(
                              startIndex,
                              endIndex,
                            );

                            return RefreshIndicator(
                              color: purple,
                              onRefresh: _refreshSiswa,
                              child: ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                itemCount: paginatedList.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      paginatedList[index];

                                  return _cardSiswa(item);
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      // ==========================================
                      // NAVIGASI PAGINATION
                      // ==========================================

                      FutureBuilder<
                          List<Map<String, dynamic>>>(
                        future: _futureSiswa,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final filtered =
                              _prosesData(snapshot.data!);

                          return _pagination(filtered.length);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}