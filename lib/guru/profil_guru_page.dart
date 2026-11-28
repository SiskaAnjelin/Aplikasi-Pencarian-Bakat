import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bidang_keahlian_page.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color green = Color(0xFF75C9A5);
  static const Color red = Color(0xFFF28B91);
  static const Color background = Color(0xFFF5F5FA);

  final supabase = Supabase.instance.client;

  late Future<Map<String, dynamic>?> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = ambilDataGuru();
  }

  // MENGAMBIL DATA GURU DARI SUPABASE
  Future<Map<String, dynamic>?> ambilDataGuru() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final data = await supabase
        .from('guru')
        .select(
          'nama_guru, nip, nama_sekolah, foto_profil, deskripsi',
        )
        .eq('user_id', user.id)
        .maybeSingle();

    debugPrint('UID GURU: ${user.id}');
    debugPrint('DATA GURU: $data');

    if (data == null) return null;

    return {
      ...data,
      'email': user.email,
    };
  }

  // REFRESH DATA PROFIL
  Future<void> refreshData() async {
    final future = ambilDataGuru();

    setState(() {
      dataFuture = future;
    });

    await future;
  }

  // MEMBUKA HALAMAN BIDANG KEAHLIAN
  Future<void> bukaBidangKeahlian(
    Map<String, dynamic> guru,
  ) async {
    final bidangAwal = ambilBidang(guru['deskripsi']);

    final hasil = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => BidangKeahlianPage(
          bidangAwal: bidangAwal,
        ),
      ),
    );

    if (!mounted) return;

    if (hasil != null) {
      setState(() {
        dataFuture = ambilDataGuru();
      });
    }
  }

  // MENGUBAH DATA MENJADI STRING
  String nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  // MENGAMBIL BIDANG KEAHLIAN
  List<String> ambilBidang(dynamic deskripsi) {
    if (deskripsi == null ||
        deskripsi.toString().trim().isEmpty) {
      return [];
    }

    return deskripsi
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // FOTO DEFAULT
  Widget fotoDefault() {
    return Container(
      color: lightPurple,
      child: const Icon(
        Icons.person,
        size: 38,
        color: purple,
      ),
    );
  }

  // FOTO PROFIL
  Widget fotoProfil(String? url) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: url != null && url.trim().isNotEmpty
            ? Image.network(
                url,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => fotoDefault(),
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
            : fotoDefault(),
      ),
    );
  }

  // ITEM BIDANG KEAHLIAN
  Widget bidangItem(String bidang) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 12,
            color: purple,
          ),
          const SizedBox(width: 5),
          Text(
            bidang,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkPurple,
            ),
          ),
        ],
      ),
    );
  }

  // INFORMASI PRIBADI
  Widget infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: purple,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // KONFIRMASI KELUAR
  Future<void> konfirmasiKeluar() async {
    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        actions: [
          SizedBox(
            width: 95,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (hasil == true) {
      try {
        await supabase.auth.signOut();

        if (!mounted) return;

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
            backgroundColor: red,
          ),
        );
      }
    }
  }

  // NAVIGASI BOTTOM NAVBAR
  void onNavTap(int index) {
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
        Navigator.pushReplacementNamed(
          context,
          '/penilaian_bakat',
        );
        break;

      case 4:
        // Tetap di halaman Profil Guru
        break;
    }
  }

  // ITEM BOTTOM NAVBAR
  Widget navItem(
    IconData icon,
    String title,
    int index,
    bool active,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => onNavTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? purple : Colors.grey.shade600,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                color: active ? purple : darkPurple,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          // Membatasi lebar konten pada layar besar, tanpa menetapkan
          // ukuran atau tinggi khusus seperti frame HP.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Scaffold(
              backgroundColor: background,
              body: FutureBuilder<Map<String, dynamic>?>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: purple),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Gagal mengambil data profil.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: refreshData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final guru = snapshot.data;

                  if (guru == null) {
                    return const Center(
                      child: Text(
                        'Data guru tidak ditemukan.',
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }

                  final nama = nilai(guru['nama_guru']);
                  final nip = nilai(guru['nip']);
                  final sekolah = nilai(guru['nama_sekolah']);
                  final email = nilai(guru['email']);
                  final foto = guru['foto_profil']?.toString();
                  final bidang = ambilBidang(guru['deskripsi']);

                  return RefreshIndicator(
                    color: purple,
                    onRefresh: refreshData,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        // HEADER
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: darkPurple,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Profil Guru',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // KARTU IDENTITAS
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              fotoProfil(foto),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: darkPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Guru Niskala',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: purple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.star_rounded,
                                color: yellow,
                                size: 27,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // BIDANG KEAHLIAN
                        const Text(
                          'Bidang Keahlian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (bidang.isEmpty)
                                const Text(
                                  'Belum ada bidang keahlian.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                )
                              else
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: bidang.map(bidangItem).toList(),
                                ),
                              const SizedBox(height: 14),
                              InkWell(
                                onTap: () => bukaBidangKeahlian(guru),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: purple,
                                    ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        'Kelola Bidang Keahlian',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: purple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: purple,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // INFORMASI PRIBADI
                        const Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              infoItem(
                                Icons.person_outline,
                                'Nama Lengkap',
                                nama,
                              ),
                              const Divider(height: 1),
                              infoItem(
                                Icons.badge_outlined,
                                'NIP',
                                nip,
                              ),
                              const Divider(height: 1),
                              infoItem(
                                Icons.email_outlined,
                                'Email Akun',
                                email,
                              ),
                              const Divider(height: 1),
                              infoItem(
                                Icons.school_outlined,
                                'Nama Sekolah',
                                sekolah,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // TOMBOL KELUAR
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: konfirmasiKeluar,
                            icon: const Icon(Icons.logout, size: 18),
                            label: const Text(
                              'Keluar dari Akun',
                              style: TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: red,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),

              // BOTTOM NAVBAR
              bottomNavigationBar: SafeArea(
                top: false,
                child: Container(
                  height: 64,
                  color: Colors.white,
                  child: Row(
                    children: [
                      navItem(Icons.home_outlined, 'Beranda', 0, false),
                      navItem(Icons.people_outline, 'Daftar Siswa', 1, false),
                      navItem(Icons.history, 'Riwayat', 2, false),
                      navItem(
                        Icons.assignment_outlined,
                        'Penilaian',
                        3,
                        false,
                      ),
                      navItem(Icons.person, 'Profil', 4, true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}