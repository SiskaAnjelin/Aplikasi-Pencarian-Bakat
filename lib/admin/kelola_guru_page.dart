import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_guru_page.dart';

class KelolaGuruPage extends StatefulWidget {
  final bool standalone;

  const KelolaGuruPage({
    super.key,
    this.standalone = false,
  });

  @override
  State<KelolaGuruPage> createState() => _KelolaGuruPageState();
}

class _KelolaGuruPageState extends State<KelolaGuruPage> {
  // ==========================================
  // KONEKSI SUPABASE
  // ==========================================

  final supabase = Supabase.instance.client;

  // ==========================================
  // VARIABEL SEARCH, SORT, DAN PAGINATION
  // ==========================================

  String _searchQuery = '';
  String _sortType = 'A-Z';

  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  late Future<List<Map<String, dynamic>>> _futureGuru;

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color purple = Color(0xFF6C5CE7);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color background = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  // ==========================================
  // MENGAMBIL DATA GURU DARI SUPABASE
  // ==========================================

  void _loadGuru() {
    _futureGuru = supabase
        .from('guru')
        .select()
        .order('nama_guru', ascending: true);
  }

  // ==========================================
  // REFRESH DATA GURU
  // ==========================================

  Future<void> _refreshGuru() async {
    setState(() {
      _loadGuru();
    });

    try {
      await _futureGuru;
    } catch (e) {
      debugPrint('Gagal refresh data guru: $e');
    }
  }

  // ==========================================
  // MENGHAPUS DATA GURU
  // ==========================================

  Future<void> _hapusGuru(dynamic id, String nama) async {
    if (id == null) return;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Hapus Guru Juri',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus guru juri $nama?',
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
          .from('guru')
          .delete()
          .eq('id', id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Guru $nama berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );

      await _refreshGuru();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus guru: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================
  // FOTO PROFIL GURU
  // ==========================================

  Widget _buildFotoProfil(String? fotoUrl, String nama) {
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
        child: fotoUrl != null && fotoUrl.trim().isNotEmpty
            ? Image.network(
                fotoUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fotoDefault(nama),
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
            : _fotoDefault(nama),
      ),
    );
  }

  // ==========================================
  // FOTO DEFAULT BERUPA INISIAL NAMA
  // ==========================================

  Widget _fotoDefault(String nama) {
    final String inisial =
        nama.isNotEmpty ? nama[0].toUpperCase() : 'G';

    return Container(
      color: lightPurple,
      alignment: Alignment.center,
      child: Text(
        inisial,
        style: const TextStyle(
          color: purple,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  // ==========================================
  // SEARCH DAN SORTING DATA GURU
  // ==========================================

  List<Map<String, dynamic>> _prosesData(
    List<Map<String, dynamic>> data,
  ) {
    // Mencari guru berdasarkan nama
    final filtered = data.where((item) {
      final nama = (
        item['nama_guru'] ?? item['nama'] ?? ''
      ).toString().toLowerCase();

      return nama.contains(_searchQuery.toLowerCase());
    }).toList();

    // Mengurutkan nama guru
    filtered.sort((a, b) {
      final namaA = (
        a['nama_guru'] ?? a['nama'] ?? ''
      ).toString().toLowerCase();

      final namaB = (
        b['nama_guru'] ?? b['nama'] ?? ''
      ).toString().toLowerCase();

      if (_sortType == 'A-Z') {
        return namaA.compareTo(namaB);
      }

      return namaB.compareTo(namaA);
    });

    return filtered;
  }

  // ==========================================
  // SEARCH DAN SORTING BAR
  // ==========================================

  Widget _searchDanSort() {
    return Row(
      children: [
        // Kolom pencarian
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _currentPage = 1;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari nama guru...',
              hintStyle: const TextStyle(fontSize: 12),
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

        // Menu sorting
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
            tooltip: 'Urutkan Guru',
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
  // TOMBOL TAMBAH GURU
  // ==========================================

  Widget _tombolTambah() {
    return ElevatedButton.icon(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TambahGuruPage(),
          ),
        );

        if (!mounted) return;

        await _refreshGuru();
      },
      icon: const Icon(
        Icons.add,
        size: 18,
      ),
      label: const Text(
        'Tambah Guru',
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
  // CARD DATA GURU
  // ==========================================

  Widget _cardGuru(Map<String, dynamic> item) {
    final nama = (
      item['nama_guru'] ?? item['nama'] ?? 'Guru'
    ).toString();

    final nip = (item['nip'] ?? '-').toString();
    final email = (item['email'] ?? '-').toString();

    final bidangKeahlian =
        (item['deskripsi'] ?? 'Juri Bakat').toString();

    final foto = item['foto_profil']?.toString();

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

      // LayoutBuilder menyesuaikan card dengan lebar yang tersedia
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 380;

          return Row(
            children: [
              // Foto guru
              _buildFotoProfil(foto, nama),

              const SizedBox(width: 12),

              // Informasi guru
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
                      'NIP: $nip',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Bidang: $bidangKeahlian',
                      maxLines: 2,
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

              // Tombol aksi menyesuaikan lebar layar
              if (isNarrow)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert,
                    color: purple,
                  ),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await _editGuru(item);
                    } else if (value == 'hapus') {
                      await _hapusGuru(
                        item['id'],
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
                )
              else
                _tombolAksi(item, nama),
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
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.blue,
            size: 19,
          ),
          onPressed: () => _editGuru(item),
        ),

        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 19,
          ),
          onPressed: () {
            _hapusGuru(item['id'], nama);
          },
        ),
      ],
    );
  }

  // ==========================================
  // NAVIGASI EDIT GURU
  // ==========================================

  Future<void> _editGuru(
    Map<String, dynamic> item,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahGuruPage(
          guruData: item,
        ),
      ),
    );

    if (!mounted) return;

    await _refreshGuru();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informasi halaman
          Flexible(
            child: Text(
              'Hal $_currentPage dari $totalPages ($totalItems guru)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),

          // Tombol halaman sebelumnya dan berikutnya
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
          'Guru Juri',
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

      // SafeArea menjaga tampilan dari area sistem HP
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Padding menyesuaikan lebar layar
            final horizontalPadding =
                constraints.maxWidth < 400 ? 12.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                // Membatasi lebar konten pada layar besar
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

                      // Tombol tambah guru
                      Align(
                        alignment: Alignment.centerRight,
                        child: _tombolTambah(),
                      ),

                      const SizedBox(height: 12),

                      // ==========================================
                      // LIST DATA GURU
                      // ==========================================

                      Expanded(
                        child: FutureBuilder<
                            List<Map<String, dynamic>>>(
                          future: _futureGuru,
                          builder: (context, snapshot) {
                            // Tampilan loading
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: purple,
                                ),
                              );
                            }

                            // Tampilan error
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

                            // Jika data guru kosong
                            if (filtered.isEmpty) {
                              return RefreshIndicator(
                                onRefresh: _refreshGuru,
                                color: purple,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: constraints.maxHeight * 0.45,
                                      child: Center(
                                        child: Text(
                                          _searchQuery.isEmpty
                                              ? 'Belum ada data guru juri.'
                                              : 'Guru tidak ditemukan.',
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

                            // Menghitung jumlah halaman
                            final totalItems = filtered.length;

                            final totalPages =
                                (totalItems / _itemsPerPage)
                                    .ceil()
                                    .clamp(1, 9999);

                            // Memastikan halaman tetap valid
                            final safePage =
                                _currentPage.clamp(1, totalPages);

                            if (_currentPage != safePage) {
                              _currentPage = safePage;
                            }

                            // Menghitung data yang ditampilkan
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

                            // List guru dengan fitur refresh
                            return RefreshIndicator(
                              onRefresh: _refreshGuru,
                              color: purple,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                itemCount: paginatedList.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      paginatedList[index];

                                  return _cardGuru(item);
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
                        future: _futureGuru,
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