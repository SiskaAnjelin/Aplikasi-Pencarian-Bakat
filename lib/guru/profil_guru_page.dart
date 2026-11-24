import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  static const Color purple = Color(0xFF56518D);
  static const Color red = Color(0xFFFF3838);

  late Future<Map<String, dynamic>?> _dataGuruFuture;

  @override
  void initState() {
    super.initState();
    _dataGuruFuture = _ambilDataGuru();
  }

  //ambil data guru dari supabase
  Future<Map<String, dynamic>?> _ambilDataGuru() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final data = await supabase
          .from('guru')
          .select(
            'nama_guru, nip, nama_sekolah, foto_profil, deskripsi',
          )
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return {
        ...data,
        'email': user.email ?? '-',
      };
    } catch (e) {
      debugPrint('Gagal mengambil data guru: $e');
      rethrow;
    }
  }

  //mengubah data bidang menjadi daftar
  List<String> _ambilBidang(dynamic deskripsi) {
    if (deskripsi == null ||
        deskripsi.toString().trim().isEmpty) {
      return [];
    }

    return deskripsi
        .toString()
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  //menghindari data kosong
  String _nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  //navigasi bottom bar
  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/dashboard_guru',
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/data_siswa',
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/riwayat_guru',
        );
        break;

      case 3:
        break;
    }
  }

  //konfirmasi keluar
  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
          style: TextStyle(fontSize: 13),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF00A878),
              side: const BorderSide(
                color: Color(0xFF00A878),
              ),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      try {
        //keluar dari akun supabase
        await Supabase.instance.client.auth.signOut();

        if (!mounted) return;

        //kembali ke halaman login
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal keluar: $e'),
          ),
        );
      }
    }
  }

  //memuat ulang data guru
  Future<void> _refreshData() async {
    setState(() {
      _dataGuruFuture = _ambilDataGuru();
    });

    try {
      await _dataGuruFuture;
    } catch (_) {
      //error ditampilkan oleh future builder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background samping kiri dan kanan hitam
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
              backgroundColor: Colors.white,

              //header halaman
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    'Profil Guru',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                ),
              ),

              //body profil guru
              body: FutureBuilder<Map<String, dynamic>?>(
                future: _dataGuruFuture,
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
                              size: 35,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Gagal mengambil data guru.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _refreshData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data;

                  if (data == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Data guru tidak ditemukan. '
                          'Periksa user_id pada tabel guru.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }

                  //mengambil data guru dari supabase
                  final nama = _nilai(data['nama_guru']);
                  final nip = _nilai(data['nip']);
                  final sekolah = _nilai(data['nama_sekolah']);
                  final email = _nilai(data['email']);
                  final deskripsi = data['deskripsi'];
                  final foto = data['foto_profil']?.toString();

                  //mengambil bidang keahlian dari deskripsi
                  final bidangList = _ambilBidang(deskripsi);

                  return RefreshIndicator(
                    color: purple,
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //profil guru
                          Row(
                            children: [
                              ClipOval(
                                child: foto != null &&
                                        foto.isNotEmpty
                                    ? Image.network(
                                        foto,
                                        width: 54,
                                        height: 54,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _fotoDefault();
                                        },
                                      )
                                    : _fotoDefault(),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      deskripsi == null ||
                                              deskripsi.toString().trim().isEmpty
                                          ? 'Guru Niskala'
                                          : deskripsi.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Divider(
                            color: Color(0xFFD0D0D0),
                            thickness: 1,
                          ),

                          const SizedBox(height: 8),

                          //bidang keahlian
                          const Text(
                            'Bidang Keahlian',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          if (bidangList.isEmpty)
                            const Text(
                              'Belum ada bidang keahlian.',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: bidangList.map((bidang) {
                                return _buildSkill(bidang);
                              }).toList(),
                            ),

                          const SizedBox(height: 12),

                          //kelola bidang keahlian
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/bidang-keahlian',
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              height: 38,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_note,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      'Kelola Bidang Keahlian',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          //data pribadi
                          const Text(
                            'Data Pribadi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _buildData('NIP', nip),
                          _buildData('Email', email),
                          _buildData('Sekolah', sekolah),

                          const SizedBox(height: 18),

                          //tombol keluar
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _konfirmasiKeluar(context);
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Keluar',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: red,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),

              //bottom navigation
              bottomNavigationBar: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFF0F0F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.home_outlined,
                        'Beranda',
                        0,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.people,
                        'Daftar Siswa',
                        1,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.history,
                        'Riwayat',
                        2,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.person,
                        'Profil',
                        3,
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //foto default jika belum ada foto
  Widget _fotoDefault() {
    return Container(
      width: 54,
      height: 54,
      color: const Color(0xFFE8E7FF),
      child: const Icon(
        Icons.person,
        size: 32,
        color: Color(0xFF56518D),
      ),
    );
  }

  //widget bidang keahlian dari supabase
  Widget _buildSkill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDCDCDC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //widget data pribadi
  Widget _buildData(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),

          const Text(
            ':',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //widget bottom navigation
  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
    bool active,
  ) {
    return InkWell(
      onTap: () {
        _onNavTap(context, index);
      },
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? purple : Colors.grey.shade700,
            ),

            const SizedBox(height: 3),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                color: active ? purple : Colors.black,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
