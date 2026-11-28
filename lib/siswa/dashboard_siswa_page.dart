import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardSiswaPage extends StatefulWidget {
  const DashboardSiswaPage({super.key});

  @override
  State<DashboardSiswaPage> createState() => _DashboardSiswaPageState();
}

class _DashboardSiswaPageState extends State<DashboardSiswaPage> {
  static const Color purple = Color(0xFF7062F5);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color lightPurple = Color(0xFFB8A5FF);

  int _currentIndex = 0;

  late Future<Map<String, dynamic>?> _dataSiswaFuture;

  @override
  void initState() {
    super.initState();
    _dataSiswaFuture = _ambilDataSiswa();
  }

  // ambil data siswa & bakat asli dari supabase
  Future<Map<String, dynamic>?> _ambilDataSiswa() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final data = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa, kelas, user_id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null) return null;

      // Ambil daftar pengajuan bakat milik siswa dari Supabase
      final pengajuanList = await supabase
          .from('pengajuan_bakat')
          .select('id_pengajuan, status, rekomendasi, bakat:id_bakat(nama_bakat, kategori)')
          .eq('id_siswa', data['id_siswa'])
          .order('tanggal_pengajuan', ascending: false);

      int totalUnggul = 0;
      int totalPotensial = 0;

      for (final item in pengajuanList) {
        final st = (item['status'] ?? '').toString().toLowerCase();
        final rek = (item['rekomendasi'] ?? '').toString().toLowerCase();
        if (st.contains('unggul') || rek.contains('unggul')) {
          totalUnggul++;
        } else if (st.contains('potensial') ||
            rek.contains('potensial') ||
            st.contains('pending') ||
            st.contains('menunggu') ||
            st.contains('proses')) {
          totalPotensial++;
        }
      }

      return {
        ...data,
        'bakat_list': pengajuanList,
        'total_bakat': pengajuanList.length,
        'total_unggul': totalUnggul,
        'total_potensial': totalPotensial,
      };
    } catch (e) {
      debugPrint('Gagal mengambil data siswa: $e');
      rethrow;
    }
  }

  // navigasi bottom bar
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/daftar_bakat');
        break;
      case 2:
        Navigator.pushNamed(context, '/detail_jadwal_siswa');
        break;
      case 3:
        Navigator.pushNamed(context, '/profil_siswa');
        break;
    }
  }

  // menuju halaman tambah bakat & auto refresh saat kembali
  void _keTambahBakat() async {
    await Navigator.pushNamed(context, '/tambah_bakat');
    if (mounted) {
      setState(() {
        _dataSiswaFuture = _ambilDataSiswa();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Siswa',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  FutureBuilder<Map<String, dynamic>?>(
                    future: _dataSiswaFuture,
                    builder: (context, snapshot) {
                      String nama = 'Siswa';

                      if (snapshot.hasData && snapshot.data != null) {
                        nama = snapshot.data!['nama_siswa'] ?? 'Siswa';
                      }

                      if (snapshot.hasError) {
                        nama = 'Siswa';
                      }

                      return Text(
                        '$nama!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Saatnya eksplorasi bakat dan\n'
                    'kembangkan potensi terbaikmu.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // tombol tambah bakat
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _keTambahBakat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 19),
                          SizedBox(width: 7),
                          Text(
                            'Tambah Bakat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // statistik & daftar bakat asli dari Supabase
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _dataSiswaFuture,
                    builder: (context, snapshot) {
                      final totalBakat = snapshot.data?['total_bakat'] ?? 0;
                      final totalUnggul = snapshot.data?['total_unggul'] ?? 0;
                      final totalPotensial = snapshot.data?['total_potensial'] ?? 0;
                      final List<dynamic> bakatList = snapshot.data?['bakat_list'] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // statistik bakat
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  Icons.star_outline,
                                  '$totalBakat',
                                  'Total Bakat',
                                  purple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statCard(
                                  Icons.emoji_events_outlined,
                                  '$totalUnggul',
                                  'Bakat Unggul',
                                  yellow,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statCard(
                                  Icons.trending_up,
                                  '$totalPotensial',
                                  'Potensial',
                                  lightPurple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          // judul bakat saya
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bakat Saya',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/bakat_saya');
                                },
                                child: const Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          if (snapshot.connectionState == ConnectionState.waiting)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(color: purple),
                              ),
                            )
                          else if (bakatList.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Text(
                                'Belum ada bakat diajukan.\nKlik tombol "Tambah Bakat" di atas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            )
                          else
                            ...bakatList.take(3).map((item) {
                              final bakat = item['bakat'] as Map<String, dynamic>? ?? {};
                              final nama = bakat['nama_bakat']?.toString() ?? 'Bakat';
                              final kategori = bakat['kategori']?.toString() ?? 'Umum';
                              final status = item['status']?.toString() ?? 'Menunggu';

                              IconData iconBakat = Icons.star_rounded;
                              Color warnaBakat = purple;
                              if (kategori.toLowerCase().contains('seni')) {
                                iconBakat = Icons.palette_rounded;
                                warnaBakat = const Color(0xFFFFB74D);
                              } else if (kategori.toLowerCase().contains('teknologi')) {
                                iconBakat = Icons.code_rounded;
                                warnaBakat = const Color(0xFF3D78D8);
                              } else if (kategori.toLowerCase().contains('olahraga')) {
                                iconBakat = Icons.sports_soccer_rounded;
                                warnaBakat = const Color(0xFF4CAF50);
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildBakatCard(
                                  iconBakat,
                                  nama,
                                  kategori,
                                  status,
                                  warnaBakat,
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // bottom navigation
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_filled, 'Beranda', 0),
                _navItem(Icons.library_books_outlined, 'Bakat', 1),
                _navItem(Icons.more_horiz_rounded, 'Detail', 2),
                _navItem(Icons.person_outline, 'Profil', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // kartu statistik
  Widget _statCard(IconData icon, String number, String label, Color color) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 19),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // kartu bakat saya
  Widget _buildBakatCard(
    IconData icon,
    String nama,
    String kategori,
    String status,
    Color warna,
  ) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: warna.withOpacity(0.15),
            child: Icon(icon, color: warna, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  'Kategori: $kategori',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0D5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFFB77900),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // item bottom navigation
  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: active ? purple : Colors.grey.shade400,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 9,
                color: active ? purple : Colors.grey.shade400,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}