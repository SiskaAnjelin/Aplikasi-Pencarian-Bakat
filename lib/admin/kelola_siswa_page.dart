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
  final supabase = Supabase.instance.client;

  String _searchQuery = '';

  // Menyimpan proses pengambilan data siswa
  late Future<List<Map<String, dynamic>>> _futureSiswa;

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  // Mengambil data siswa dari Supabase
  void _loadSiswa() {
    _futureSiswa = supabase
        .from('siswa')
        .select()
        .order('nama_siswa', ascending: true);
  }

  // Memuat ulang data siswa
  Future<void> _refreshSiswa() async {
    setState(() {
      _loadSiswa();
    });

    await _futureSiswa;
  }

  // Menghapus data siswa dari Supabase
  Future<void> _hapusSiswa(dynamic id, String nama) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data Siswa'),
        content: Text(
          'Yakin ingin menghapus data $nama?',
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

      setState(() {
        _loadSiswa();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nama berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            height: 680,
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FE),

              // APP BAR
              appBar: AppBar(
                title: const Text(
                  'Data Siswa',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [

                    // PENCARIAN SISWA
                    TextField(
                      onChanged: (v) {
                        setState(() {
                          _searchQuery = v;
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
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
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TOMBOL TAMBAH SISWA
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const TambahSiswaPage(),
                            ),
                          );

                          if (!mounted) return;

                          _refreshSiswa();
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 16,
                        ),
                        label: const Text(
                          'Tambah Siswa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // MENAMPILKAN DATA SISWA DARI SUPABASE
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _futureSiswa,
                        builder: (context, snapshot) {

                          // LOADING
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6C5CE7),
                              ),
                            );
                          }

                          // ERROR
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Gagal mengambil data siswa.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextButton(
                                    onPressed: _refreshSiswa,
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final data = snapshot.data ?? [];

                          // FILTER PENCARIAN NAMA
                          final filtered = data.where((item) {
                            final nama =
                                (item['nama_siswa'] ?? item['nama'] ?? '')
                                    .toString()
                                    .toLowerCase();

                            return nama.contains(
                              _searchQuery.toLowerCase(),
                            );
                          }).toList();

                          // DATA KOSONG
                          if (filtered.isEmpty) {
                            return Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? 'Belum ada data siswa.'
                                    : 'Siswa tidak ditemukan.',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }

                          // LIST DATA SISWA
                          return RefreshIndicator(
                            onRefresh: _refreshSiswa,
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];

                                final nama =
                                    (item['nama_siswa'] ?? item['nama'] ?? 'Siswa')
                                        .toString();

                                final kelas =
                                    (item['kelas'] ?? '-').toString();

                                final jurusan =
                                    (item['jurusan'] ?? '-').toString();

                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.03),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [

                                      // FOTO PROFIL SISWA DARI SUPABASE
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor:
                                            const Color(0xFFEDE9FF),
                                        backgroundImage:
                                            item['foto_profil'] != null &&
                                                    item['foto_profil']
                                                        .toString()
                                                        .isNotEmpty
                                                ? NetworkImage(
                                                    item['foto_profil']
                                                        .toString(),
                                                  )
                                                : null,
                                        child: item['foto_profil'] == null ||
                                                item['foto_profil']
                                                    .toString()
                                                    .isEmpty
                                            ? Text(
                                                nama.isNotEmpty
                                                    ? nama[0].toUpperCase()
                                                    : 'S',
                                                style: const TextStyle(
                                                  color: Color(0xFF6C5CE7),
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              )
                                            : null,
                                      ),

                                      const SizedBox(width: 10),

                                      // IDENTITAS SISWA
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nama,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              '$kelas • $jurusan',
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // TOMBOL EDIT SISWA
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  TambahSiswaPage(
                                                siswaData: item,
                                              ),
                                            ),
                                          );

                                          if (!mounted) return;

                                          _refreshSiswa();
                                        },
                                      ),

                                      // TOMBOL HAPUS SISWA
                                      IconButton(
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
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
}