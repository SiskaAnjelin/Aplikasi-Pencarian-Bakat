import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tambah_bakat_page.dart';
import 'detail_bakat_page.dart';

class DaftarBakatPage extends StatefulWidget {
  const DaftarBakatPage({super.key});

  @override
  State<DaftarBakatPage> createState() => _DaftarBakatPageState();
}

class TalentItem {
  final dynamic idBakat;
  final String title;
  final String status;
  final String category;
  final String deskripsi;
  final String gambar;

  TalentItem({
    required this.idBakat,
    required this.title,
    required this.status,
    required this.category,
    required this.deskripsi,
    required this.gambar,
  });
}

class _DaftarBakatPageState extends State<DaftarBakatPage> {
  static const Color primaryColor = Color(0xFF6C5CFF);
  static const Color darkColor = Color(0xFF202044);
  static const Color backgroundColor = Color(0xFFF8F9FC);

  final supabase = Supabase.instance.client;

  int _selectedCategoryIndex = 0;

  // ==========================================
  // VARIABEL SSP (SEARCH, SORT, PAGINATION)
  // ==========================================
  String _searchQuery = '';
  String _sortType = 'A-Z';
  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  late Future<List<TalentItem>> _talentsFuture;

  final List<String> categories = [
    'Semua',
    'Seni',
    'Akademik',
  ];

  @override
  void initState() {
    super.initState();
    _talentsFuture = _ambilDaftarBakat();
  }

  // AMBIL DATA BAKAT DARI SUPABASE
  Future<List<TalentItem>> _ambilDaftarBakat() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login. Silakan login kembali.');
    }

    try {
      final siswaResponse = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa')
          .eq('user_id', user.id)
          .limit(2);

      if (siswaResponse.isEmpty) {
        throw Exception(
          'Data siswa tidak ditemukan. Periksa kolom user_id pada tabel siswa.',
        );
      }

      if (siswaResponse.length > 1) {
        throw Exception(
          'Ada lebih dari satu data siswa dengan user_id yang sama. '
          'Periksa data siswa di Supabase.',
        );
      }

      final siswa = siswaResponse.first;
      final idSiswa = siswa['id_siswa'];

      final bakatResponse = await supabase
          .from('bakat')
          .select('id_bakat, nama_bakat, kategori, deskripsi')
          .order('nama_bakat', ascending: true);

      final semuaBakat = List<Map<String, dynamic>>.from(bakatResponse);

      final pengajuanResponse = await supabase
          .from('pengajuan_bakat')
          .select('id_bakat, status')
          .eq('id_siswa', idSiswa);

      final pengajuan = List<Map<String, dynamic>>.from(pengajuanResponse);

      final Map<String, String> statusMap = {};
      for (final item in pengajuan) {
        final id = item['id_bakat']?.toString();
        if (id == null) continue;
        statusMap[id] = item['status']?.toString() ?? 'Menunggu';
      }

      final List<TalentItem> hasil = [];
      for (final bakat in semuaBakat) {
        final id = bakat['id_bakat'];
        if (id == null) continue;

        final nama = bakat['nama_bakat']?.toString() ?? 'Bakat';
        final idString = id.toString();

        hasil.add(
          TalentItem(
            idBakat: id,
            title: nama,
            status: statusMap[idString] ?? 'Belum diajukan',
            category: bakat['kategori']?.toString() ?? 'Lainnya',
            deskripsi: bakat['deskripsi']?.toString() ?? '',
            gambar: _getGambar(nama),
          ),
        );
      }

      return hasil;
    } catch (e) {
      rethrow;
    }
  }

  String _getGambar(String nama) {
    switch (nama.toLowerCase().trim()) {
      case 'menggambar':
        return 'assets/images/menggambar.jpg';
      case 'menyanyi':
        return 'assets/images/menyanyi.jpg';
      case 'menari':
        return 'assets/images/menari.jpeg';
      case 'dance':
        return 'assets/images/dance.jpeg';
      case 'desain grafis':
        return 'assets/images/desain_grafis.jpg';
      case 'fotografi':
        return 'assets/images/fotografi.jpg';
      case 'teater':
        return 'assets/images/teater.jpeg';
      case 'sains':
        return 'assets/images/sains.jpeg';
      case 'matematika':
        return 'assets/images/matematika.jpg';
      case 'coding':
        return 'assets/images/coding.jpg';
      case 'bahasa inggris':
        return 'assets/images/bahasa_inggris.jpg';
      case 'public speaking':
        return 'assets/images/public_speaking.jpg';
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'menunggu':
        return const Color(0xFFEF982B);
      case 'dalam proses':
        return const Color(0xFF5651C9);
      case 'disetujui':
        return const Color(0xFF239B62);
      case 'belum diajukan':
        return Colors.grey.shade600;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackground(String status) {
    switch (status.toLowerCase().trim()) {
      case 'menunggu':
        return const Color(0xFFFFF2DF);
      case 'dalam proses':
        return const Color(0xFFEAE9FF);
      case 'disetujui':
        return const Color(0xFFE5F7EC);
      case 'belum diajukan':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // ==========================================
  // FILTER KATEGORI, SEARCH & SORT
  // ==========================================
  List<TalentItem> _filterTalents(List<TalentItem> talents) {
    final res = talents.where((talent) {
      if (_selectedCategoryIndex != 0) {
        final selectedCategory =
            categories[_selectedCategoryIndex].toLowerCase().trim();
        if (talent.category.toLowerCase().trim() != selectedCategory) {
          return false;
        }
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!talent.title.toLowerCase().contains(q) &&
            !talent.category.toLowerCase().contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();

    if (_sortType == 'A-Z') {
      res.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (_sortType == 'Z-A') {
      res.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }

    return res;
  }

  Future<void> _bukaTambahBakat() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahBakatPage(),
      ),
    );
    if (!mounted) return;
    await _refreshData();
  }

  Future<void> _bukaDetailBakat(TalentItem talent) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DetailBakatPage(),
        settings: RouteSettings(
          arguments: {
            'id_bakat': talent.idBakat,
            'nama_bakat': talent.title,
            'kategori': talent.category,
            'deskripsi': talent.deskripsi,
            'status': talent.status,
            'gambar': talent.gambar,
          },
        ),
      ),
    );
    if (!mounted) return;
    await _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _talentsFuture = _ambilDaftarBakat();
    });
    await _talentsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 17, color: darkColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Bakat',
          style: TextStyle(color: darkColor, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: primaryColor),
            onPressed: _bukaTambahBakat,
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILTER KATEGORI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: List.generate(
                categories.length,
                (index) {
                  final selected = _selectedCategoryIndex == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                            _currentPage = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: selected ? primaryColor : const Color(0xFFEDEBFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : darkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // SEARCH & SORT BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) {
                      setState(() {
                        _searchQuery = v;
                        _currentPage = 1;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nama bakat...',
                      hintStyle: const TextStyle(fontSize: 12),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.sort_rounded, color: primaryColor),
                    tooltip: 'Urutkan Bakat',
                    initialValue: _sortType,
                    onSelected: (val) {
                      setState(() {
                        _sortType = val;
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
                            Text('Bakat A - Z'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Z-A',
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Bakat Z - A'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Daftar Bakat',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: darkColor),
            ),
          ),

          const SizedBox(height: 10),

          // DATA SUPABASE
          Expanded(
            child: FutureBuilder<List<TalentItem>>(
              future: _talentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (snapshot.hasError) {
                  return _errorWidget(snapshot.error.toString());
                }

                final talents = snapshot.data ?? [];
                final displayedTalents = _filterTalents(talents);

                if (talents.isEmpty) {
                  return _emptyWidget('Belum ada data bakat di database.');
                }

                if (displayedTalents.isEmpty) {
                  return _emptyWidget('Bakat tidak ditemukan.');
                }

                // PAGINATION SLICE
                final int totalItems = displayedTalents.length;
                final int totalPages = (totalItems / _itemsPerPage).ceil().clamp(1, 9999);
                if (_currentPage > totalPages) {
                  _currentPage = totalPages;
                }
                final int startIndex = (_currentPage - 1) * _itemsPerPage;
                final int endIndex = (startIndex + _itemsPerPage > totalItems)
                    ? totalItems
                    : startIndex + _itemsPerPage;
                final paginatedList = (startIndex < totalItems)
                    ? displayedTalents.sublist(startIndex, endIndex)
                    : <TalentItem>[];

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  color: primaryColor,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) {
                      return _buildTalentItem(paginatedList[index]);
                    },
                  ),
                );
              },
            ),
          ),

          // BAR NAVIGASI PAGINATION
          FutureBuilder<List<TalentItem>>(
            future: _talentsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              final displayed = _filterTalents(snapshot.data!);
              final count = displayed.length;
              final totalP = (count / _itemsPerPage).ceil().clamp(1, 9999);
              if (totalP <= 1) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hal $_currentPage dari $totalP ($count bakat)',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20),
                          onPressed: _currentPage > 1
                              ? () => setState(() => _currentPage--)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 20),
                          onPressed: _currentPage < totalP
                              ? () => setState(() => _currentPage++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 9,
        unselectedFontSize: 9,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard_siswa');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/detail_jadwal_siswa');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profil_siswa');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Bakat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 38, color: Colors.red),
            const SizedBox(height: 10),
            const Text(
              'Gagal mengambil data bakat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: darkColor),
            ),
            const SizedBox(height: 7),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWidget(String message) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _refreshData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.folder_open_outlined, size: 45, color: Colors.grey),
          const SizedBox(height: 10),
          Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: _bukaTambahBakat,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Tambah Bakat', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTalentItem(TalentItem talent) {
    final warnaStatus = _getStatusColor(talent.status);
    final backgroundStatus = _getStatusBackground(talent.status);

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => _bukaDetailBakat(talent),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
            ClipOval(
              child: talent.gambar.isNotEmpty
                  ? Image.asset(
                      talent.gambar,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _gambarDefault();
                      },
                    )
                  : _gambarDefault(),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    talent.category,
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: backgroundStatus,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      talent.status,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: warnaStatus,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 17, color: darkColor),
          ],
        ),
      ),
    );
  }

  Widget _gambarDefault() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: Color(0xFFEDEBFF),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.image_outlined, color: primaryColor, size: 24),
    );
  }
}