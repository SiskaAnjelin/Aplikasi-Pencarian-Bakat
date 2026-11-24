
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_bakat_page.dart';

class DaftarBakatPage extends StatefulWidget {
  const DaftarBakatPage({super.key});

  @override
  State<DaftarBakatPage> createState() => _DaftarBakatPageState();
}

class TalentItem {
  final String title;
  final String status;
  final String category;
  final String deskripsi;
  final String gambar;

  TalentItem({
    required this.title,
    required this.status,
    required this.category,
    required this.deskripsi,
    required this.gambar,
  });
}

class _DaftarBakatPageState extends State<DaftarBakatPage> {
  int _selectedCategoryIndex = 0;

  late Future<List<TalentItem>> _talentsFuture;

  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color darkColor = Color(0xFF1A1A2E);

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

  // mengambil data pengajuan bakat dari supabase
  Future<List<TalentItem>> _ambilDaftarBakat() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    // mengambil id siswa berdasarkan akun login
    final siswa = await supabase
        .from('siswa')
        .select('id_siswa')
        .eq('user_id', user.id)
        .maybeSingle();

    if (siswa == null) return [];

    final idSiswa = siswa['id_siswa'];

    debugPrint('UID LOGIN: ${user.id}');
    debugPrint('ID SISWA: $idSiswa');

    // mengambil pengajuan bakat siswa
    final pengajuan = await supabase
        .from('pengajuan_bakat')
        .select('id_bakat, status')
        .eq('id_siswa', idSiswa);

    debugPrint('DATA PENGAJUAN: $pengajuan');

    if (pengajuan.isEmpty) return [];

    // mengambil id bakat
    final idBakatList = pengajuan
        .map((item) => item['id_bakat'])
        .where((id) => id != null)
        .toSet()
        .toList();

    if (idBakatList.isEmpty) return [];

    // mengambil detail bakat
    final dataBakat = await supabase
        .from('bakat')
        .select('id_bakat, nama_bakat, deskripsi, kategori')
        .inFilter('id_bakat', idBakatList);

    debugPrint('DATA BAKAT: $dataBakat');

    // mencocokkan id bakat
    final Map<String, dynamic> bakatById = {
      for (final item in dataBakat)
        item['id_bakat'].toString(): item,
    };

    final List<TalentItem> hasil = [];

    for (final item in pengajuan) {
      final idBakat = item['id_bakat']?.toString();

      if (idBakat == null) continue;

      final bakat = bakatById[idBakat];

      if (bakat == null) continue;

      final nama = bakat['nama_bakat']?.toString() ?? 'Bakat';
      final kategori = bakat['kategori']?.toString() ?? 'Lainnya';
      final status = item['status']?.toString() ?? 'Menunggu';
      final deskripsi = bakat['deskripsi']?.toString() ?? '';

      hasil.add(
        TalentItem(
          title: nama,
          status: status,
          category: kategori,
          deskripsi: deskripsi,
          gambar: _getGambar(nama),
        ),
      );
    }

    return hasil;
  }

  // menentukan gambar berdasarkan nama bakat
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

  // menentukan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'menunggu':
        return const Color(0xFFEF982B);

      case 'dalam proses':
        return const Color(0xFF5651C9);

      case 'disetujui':
        return const Color(0xFF239B62);

      default:
        return Colors.grey;
    }
  }

  // menentukan warna latar status
  Color _getStatusBackground(String status) {
    switch (status.toLowerCase().trim()) {
      case 'menunggu':
        return const Color(0xFFFFF2DF);

      case 'dalam proses':
        return const Color(0xFFEAE9FF);

      case 'disetujui':
        return const Color(0xFFE5F7EC);

      default:
        return Colors.grey.shade100;
    }
  }

  // filter kategori bakat
  List<TalentItem> _filterTalents(List<TalentItem> talents) {
    if (_selectedCategoryIndex == 0) {
      return talents;
    }

    final selectedCategory = categories[_selectedCategoryIndex];

    return talents.where((talent) {
      return talent.category.toLowerCase() ==
          selectedCategory.toLowerCase();
    }).toList();
  }

  // membuka halaman tambah bakat
  Future<void> _bukaTambahBakat() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahBakatPage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _talentsFuture = _ambilDaftarBakat();
    });
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
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FC),

              // header halaman
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 17,
                    color: darkColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Daftar Bakat',
                  style: TextStyle(
                    color: darkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: primaryColor,
                    ),
                    onPressed: _bukaTambahBakat,
                  ),
                ],
              ),

              // body halaman
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // filter kategori
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: List.generate(
                        categories.length,
                        (index) {
                          final isSelected =
                              _selectedCategoryIndex == index;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : const Color(0xFFEDEBFF),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    categories[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : darkColor,
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

                  // judul daftar bakat
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Daftar Bakat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202044),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // daftar bakat dari supabase
                  Expanded(
                    child: FutureBuilder<List<TalentItem>>(
                      future: _talentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          debugPrint(
                            'ERROR BAKAT: ${snapshot.error}',
                          );

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 35,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Gagal mengambil data bakat',
                                  style: TextStyle(fontSize: 11),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _talentsFuture =
                                          _ambilDaftarBakat();
                                    });
                                  },
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        }

                        final talents = snapshot.data ?? [];
                        final displayedTalents =
                            _filterTalents(talents);

                        if (talents.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Belum ada pengajuan bakat',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (displayedTalents.isEmpty) {
                          return const Center(
                            child: Text(
                              'Belum ada bakat dalam kategori ini',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: displayedTalents.length,
                          itemBuilder: (context, index) {
                            final talent = displayedTalents[index];

                            return _buildTalentItem(talent);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // navigasi bawah
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
                    Navigator.pushReplacementNamed(
                      context,
                      '/dashboard_siswa',
                    );
                  } else if (index == 2) {
                    Navigator.pushNamed(
                      context,
                      '/detail_bakat',
                    );
                  } else if (index == 3) {
                    Navigator.pushNamed(
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
            ),
          ),
        ),
      ),
    );
  }

  // tampilan item bakat menggunakan gambar
  Widget _buildTalentItem(TalentItem talent) {
    final warnaStatus = _getStatusColor(talent.status);
    final backgroundStatus = _getStatusBackground(talent.status);

    return Container(
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
          // foto bakat
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

          // nama dan kategori bakat
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
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),

                // status pengajuan
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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

          const Icon(
            Icons.chevron_right,
            size: 17,
            color: darkColor,
          ),
        ],
      ),
    );
  }

  // gambar pengganti jika foto tidak ditemukan
  Widget _gambarDefault() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: Color(0xFFEDEBFF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.image_outlined,
        color: primaryColor,
        size: 24,
      ),
    );
  }
}
