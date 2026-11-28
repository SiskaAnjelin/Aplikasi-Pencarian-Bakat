import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman profil siswa menggunakan StatefulWidget
// karena mengambil data secara dinamis dari Supabase.
class ProfilSiswaPage extends StatefulWidget {
  const ProfilSiswaPage({super.key});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {

  // Warna utama aplikasi.
  static const Color purple = Color(0xFF6C5CFF);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color green = Color(0xFF75C9A5);
  static const Color red = Color(0xFFF28B91);
  static const Color background = Color(0xFFF5F5FA);

  // Menyimpan Future untuk mengambil data siswa.
  late Future<Map<String, dynamic>?> dataFuture;

  @override
  void initState() {
    super.initState();

    // Mengambil data siswa ketika halaman pertama kali dibuka.
    dataFuture = ambilDataSiswa();
  }

  // =====================================
  // MENGAMBIL DATA SISWA DARI SUPABASE
  // =====================================

  Future<Map<String, dynamic>?> ambilDataSiswa() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // Memeriksa apakah ada pengguna yang sedang login.
    if (user == null) return null;

    // Mengambil data siswa berdasarkan user_id.
    final data = await supabase
        .from('siswa')
        .select('id_siswa, nama_siswa, kelas, foto_profil')
        .eq('user_id', user.id)
        .maybeSingle();

    debugPrint('UID SISWA: ${user.id}');
    debugPrint('DATA SISWA: $data');

    return data;
  }

  // Mengubah data kosong menjadi tanda strip.
  String nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }
    return value.toString();
  }

  // =====================================
  // FOTO PROFIL SISWA
  // =====================================

  // Menampilkan foto profil dari URL Supabase.
  Widget fotoProfil(String? url) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: url != null && url.trim().isNotEmpty
            ? Image.network(
                url,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,

                // Menampilkan foto default jika gambar gagal dimuat.
                errorBuilder: (_, __, ___) => fotoDefault(),

                // Menampilkan loading ketika foto sedang dimuat.
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

  // Foto default jika siswa belum memiliki foto profil.
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

  // =====================================
  // KOMPONEN INFORMASI PRIBADI
  // =====================================

  // Membuat satu baris informasi berupa ikon, judul, dan isi.
  Widget infoItem(IconData icon, String title, String value) {
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
            child: Icon(icon, color: purple, size: 19),
          ),

          const SizedBox(width: 12),

          // Expanded memberikan ruang fleksibel untuk teks.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
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

  // =====================================
  // KOMPONEN MENU PROFIL
  // =====================================

  // Membuat menu yang dapat ditekan untuk berpindah halaman.
  Widget menuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),

      // Ikon menu.
      leading: Icon(icon, color: purple, size: 20),

      // Judul menu.
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: darkPurple,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Ikon panah di sebelah kanan.
      trailing: const Icon(
        Icons.chevron_right,
        color: purple,
        size: 20,
      ),

      // Menjalankan fungsi ketika menu ditekan.
      onTap: onTap,
    );
  }

  // =====================================
  // KONFIRMASI KELUAR DARI AKUN
  // =====================================

  Future<void> konfirmasiKeluar() async {
    // Menampilkan dialog konfirmasi sebelum logout.
    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        // Judul dialog.
        title: const Text(
          'Konfirmasi Keluar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),

        // Isi dialog.
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),

        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 20),

        // Tombol batal dan keluar.
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
                  fontSize: 12,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Jika pengguna memilih keluar, jalankan logout.
    if (hasil == true) {
      try {
        await Supabase.instance.client.auth.signOut();

        if (!mounted) return;

        // Mengarahkan pengguna kembali ke halaman login.
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;

        // Menampilkan pesan jika logout gagal.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal keluar: $e'),
            backgroundColor: red,
          ),
        );
      }
    }
  }

  // =====================================
  // KOMPONEN BOTTOM NAVIGATION
  // =====================================

  // Membuat item navigasi bagian bawah.
  Widget navItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? purple : Colors.grey.shade600,
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(
                fontSize: 10,
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

  // =====================================
  // REFRESH DATA PROFIL
  // =====================================

  // Mengambil ulang data ketika pengguna melakukan refresh.
  Future<void> refreshData() async {
    final future = ambilDataSiswa();

    setState(() {
      dataFuture = future;
    });

    await future;
  }

  // =====================================
  // TAMPILAN UTAMA PROFIL SISWA
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background memenuhi seluruh layar.
      backgroundColor: background,

      // SafeArea menyesuaikan konten dengan area aman perangkat.
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: dataFuture,
          builder: (context, snapshot) {

            // Tampilan ketika data sedang dimuat.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: purple),
              );
            }

            // Tampilan ketika pengambilan data mengalami kesalahan.
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
                      TextButton(
                        onPressed: refreshData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Mengambil hasil data siswa.
            final siswa = snapshot.data;

            // Tampilan jika data siswa tidak ditemukan.
            if (siswa == null) {
              return const Center(
                child: Text(
                  'Data siswa tidak ditemukan.',
                  style: TextStyle(fontSize: 14),
                ),
              );
            }

            // Mengambil informasi siswa dari Supabase.
            final nama = nilai(siswa['nama_siswa']);
            final kelas = nilai(siswa['kelas']);
            final foto = siswa['foto_profil']?.toString();

            // RefreshIndicator memungkinkan pengguna menarik layar ke bawah.
            return RefreshIndicator(
              color: purple,
              onRefresh: refreshData,

              // ListView membuat konten bisa di-scroll.
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                // Jarak konten dari tepi layar.
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),

                children: [

                  // HEADER HALAMAN
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: darkPurple,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Text(
                        'Profil Siswa',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // KARTU IDENTITAS SISWA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Foto profil siswa.
                        fotoProfil(foto),

                        const SizedBox(width: 14),

                        // Informasi nama dan kelas.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Label kelas siswa.
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  kelas,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Ikon dekorasi bintang.
                        const Icon(
                          Icons.star_rounded,
                          color: yellow,
                          size: 27,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // JUDUL INFORMASI PRIBADI
                  const Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // KARTU INFORMASI PRIBADI
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        // Informasi nama lengkap.
                        infoItem(
                          Icons.person_outline,
                          'Nama Lengkap',
                          nama,
                        ),

                        const Divider(height: 1),

                        // Informasi kelas.
                        infoItem(
                          Icons.school_outlined,
                          'Kelas',
                          kelas,
                        ),

                        const Divider(height: 1),

                        // Informasi email akun.
                        infoItem(
                          Icons.email_outlined,
                          'Email Akun',
                          nilai(
                            Supabase.instance.client.auth.currentUser?.email,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // JUDUL PENGATURAN PROFIL
                  const Text(
                    'Pengaturan Profil',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // KARTU MENU PENGATURAN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        // Menu menuju halaman daftar bakat.
                        menuItem(
                          Icons.auto_awesome_outlined,
                          'Bakat Saya',
                          () {
                            Navigator.pushNamed(
                              context,
                              '/daftar_bakat',
                            );
                          },
                        ),

                        const Divider(height: 1, indent: 45),

                        // Menu menuju halaman detail jadwal.
                        menuItem(
                          Icons.calendar_month_outlined,
                          'Detail Jadwal',
                          () {
                            Navigator.pushNamed(
                              context,
                              '/detail_jadwal_siswa',
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TOMBOL KELUAR AKUN
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: konfirmasiKeluar,
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text(
                        'Keluar dari Akun',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  ),

                  // Jarak tambahan di bawah konten.
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 62,
          color: Colors.white,
          child: Row(
            children: [

              // Navigasi ke dashboard siswa.
              navItem(
                Icons.home_outlined,
                'Beranda',
                () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard_siswa',
                  );
                },
              ),

              // Navigasi ke daftar bakat.
              navItem(
                Icons.library_books_outlined,
                'Bakat',
                () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/daftar_bakat',
                  );
                },
              ),

              // Navigasi ke detail jadwal.
              navItem(
                Icons.calendar_month_outlined,
                'Detail',
                () {
                  Navigator.pushNamed(
                    context,
                    '/detail_jadwal_siswa',
                  );
                },
              ),

              // Halaman profil sedang aktif.
              navItem(
                Icons.person,
                'Profil',
                () {},
                active: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}