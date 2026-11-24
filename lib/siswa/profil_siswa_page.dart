
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilSiswaPage extends StatefulWidget {
  const ProfilSiswaPage({super.key});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {
  static const Color primaryColor = Color(0xFF6C5CFF);

  late Future<Map<String, dynamic>?> _dataSiswaFuture;

  @override
  void initState() {
    super.initState();
    _dataSiswaFuture = _ambilDataSiswa();
  }

  // ambil data siswa dari supabase
  Future<Map<String, dynamic>?> _ambilDataSiswa() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await supabase
        .from('siswa')
        .select('id_siswa, nama_siswa, kelas, user_id, foto_profil')
        .eq('user_id', user.id)
        .maybeSingle();

    debugPrint('EMAIL PROFIL: ${user.email}');
    debugPrint('UID PROFIL: ${user.id}');
    debugPrint('DATA PROFIL SISWA: $data');
    debugPrint('FOTO PROFIL: ${data?['foto_profil']}');

    return data;
  }

  // widget foto profil siswa
  Widget _fotoProfil(String? url) {
    if (url == null || url.trim().isEmpty) {
      return const CircleAvatar(
        radius: 26,
        backgroundColor: Color(0xFFD3E3FD),
        child: Icon(
          Icons.person,
          size: 30,
          color: primaryColor,
        ),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: const Color(0xFFD3E3FD),
      child: ClipOval(
        child: Image.network(
          url,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 30,
              color: primaryColor,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // konfirmasi keluar
  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3F50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (hasil == true) {
      try {
        // keluar dari supabase auth
        await Supabase.instance.client.auth.signOut();

        if (!mounted) return;

        // kembali ke halaman login
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal keluar dari akun: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 320,
          height: 680,
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,

            // body
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // header
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 26,
                                    minHeight: 26,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  'Profil Siswa',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // foto dan identitas siswa
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: FutureBuilder<Map<String, dynamic>?>(
                                future: _dataSiswaFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 55,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return const Text(
                                      'Gagal mengambil data profil',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                      ),
                                    );
                                  }

                                  final siswa = snapshot.data;

                                  if (siswa == null) {
                                    return const Text(
                                      'Data siswa tidak ditemukan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                      ),
                                    );
                                  }

                                  final nama =
                                      siswa['nama_siswa'] ?? 'Nama siswa';

                                  final kelas =
                                      siswa['kelas'] ?? 'Kelas belum tersedia';

                                  final foto =
                                      siswa['foto_profil']?.toString();

                                  return Row(
                                    children: [
                                      _fotoProfil(foto),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nama.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            kelas.toString(),
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 29),

                            // menu profil
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                  width: 0.8,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Column(
                                children: [
                                  _buildMenuItem(
                                    icon: Icons.person,
                                    title: 'Data Pribadi',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.class_outlined,
                                    title: 'Kelas',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.calendar_today_outlined,
                                    title: 'Bakat',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.settings_outlined,
                                    title: 'Detail jadwal',
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail_jadwal_siswa',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 27),

                            // tombol keluar
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _konfirmasiKeluar(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFFF3F50),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        size: 15,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // bottom navigation
            bottomNavigationBar: Container(
              height: 55,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    title: 'Beranda',
                    active: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/dashboard_siswa',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.library_books_outlined,
                    title: 'Bakat',
                    active: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/daftar_bakat',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.more_horiz_rounded,
                    title: 'Detail',
                    active: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail_jadwal_siswa',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    title: 'Profil',
                    active: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget menu profil
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 37,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        leading: Icon(
          icon,
          size: 18,
          color: Colors.black87,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 10,
          color: Colors.black87,
        ),
        onTap: onTap,
      ),
    );
  }

  // widget bottom navigation
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? primaryColor : Colors.black87,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 8,
                color: Colors.black,
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
