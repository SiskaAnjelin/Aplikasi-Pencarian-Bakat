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
  final supabase = Supabase.instance.client;

  String _searchQuery = '';

  // Mengambil data guru dari Supabase
  late Future<List<Map<String, dynamic>>> _futureGuru;

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  // Memuat data guru
  void _loadGuru() {
    _futureGuru = supabase
        .from('guru')
        .select()
        .order('nama_guru', ascending: true);
  }

  // Refresh data guru
  Future<void> _refreshGuru() async {
    setState(() {
      _loadGuru();
    });

    await _futureGuru;
  }

  // Menghapus data guru
  Future<void> _hapusGuru(dynamic id, String nama) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Guru Juri'),
        content: Text('Yakin ingin menghapus data $nama?'),
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

      setState(() {
        _loadGuru();
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
          content: Text('Gagal menghapus guru: $e'),
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
                  'Guru Juri',
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

                    // PENCARIAN GURU
                    TextField(
                      onChanged: (v) {
                        setState(() {
                          _searchQuery = v;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari nama guru...',
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

                    // TOMBOL TAMBAH GURU
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TambahGuruPage(),
                            ),
                          );

                          if (!mounted) return;

                          _refreshGuru();
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 16,
                        ),
                        label: const Text(
                          'Tambah Guru Juri',
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

                    // MENAMPILKAN DATA GURU
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _futureGuru,
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
                                    'Gagal mengambil data guru.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextButton(
                                    onPressed: _refreshGuru,
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final data = snapshot.data ?? [];

                          // FILTER PENCARIAN
                          final filtered = data.where((item) {
                            final nama =
                                (item['nama_guru'] ?? item['nama'] ?? '')
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
                                    ? 'Belum ada data guru juri.'
                                    : 'Guru tidak ditemukan.',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }

                          // LIST GURU
                          return RefreshIndicator(
                            onRefresh: _refreshGuru,
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];

                                final nama =
                                    (item['nama_guru'] ?? item['nama'] ?? 'Guru')
                                        .toString();

                                final nip =
                                    (item['nip'] ?? '-').toString();

                                final sekolah =
                                    (item['bidang'] ?? item['nama_sekolah'] ?? '-')
                                        .toString();

                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                  ),
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
                                  child: ListTile(
                                    dense: true,

                                    // FOTO PROFIL GURU DARI SUPABASE
                                    leading: CircleAvatar(
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
                                                  : 'G',
                                              style: const TextStyle(
                                                color: Color(0xFF6C5CE7),
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            )
                                          : null,
                                    ),

                                    // IDENTITAS GURU
                                    title: Text(
                                      nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),

                                    subtitle: Text(
                                      '$sekolah • $nip',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    // TOMBOL HAPUS
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _hapusGuru(
                                          item['id'],
                                          nama,
                                        );
                                      },
                                    ),
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