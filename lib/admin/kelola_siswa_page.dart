import 'package:flutter/material.dart';
import 'tambah_siswa_page.dart';

class KelolaSiswaPage extends StatefulWidget {
  final bool standalone;
  const KelolaSiswaPage({super.key, this.standalone = false});

  @override
  State<KelolaSiswaPage> createState() => _KelolaSiswaPageState();
}

class _KelolaSiswaPageState extends State<KelolaSiswaPage> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _siswaList = [
    {'id': '1', 'name': 'Alya Hayani', 'kelas': 'XI IPA 1', 'jurusan': 'IPA'},
    {'id': '2', 'name': 'Naufal Zaidan', 'kelas': 'XI IPA 2', 'jurusan': 'IPA'},
    {'id': '3', 'name': 'Rizky Maulana', 'kelas': 'X IPS 1', 'jurusan': 'IPS'},
    {'id': '4', 'name': 'Sinta Amalia', 'kelas': 'XI IPA 1', 'jurusan': 'IPA'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filtered {
    if (_query.isEmpty) return _siswaList;
    return _siswaList
        .where((s) =>
            s['name']!.toLowerCase().contains(_query.toLowerCase()) ||
            s['kelas']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void _showDeleteDialog(Map<String, String> siswa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data Siswa', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        content: Text(
          'Yakin ingin menghapus data ${siswa['name']}?\nTindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 14, color: Color(0xFF636E72)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF636E72))),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _siswaList.removeWhere((s) => s['id'] == siswa['id']);
              });
              Navigator.pop(ctx);
              showDialog(
                context: context,
                builder: (ctx2) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B894).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: Color(0xFF00B894), size: 36),
                      ),
                      const SizedBox(height: 16),
                      const Text('Berhasil Dihapus!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Data siswa berhasil dihapus', style: TextStyle(fontSize: 13, color: Color(0xFF636E72))),
                    ],
                  ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx2),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Color(0xFFD63031), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: widget.standalone
          ? AppBar(
              title: const Text('Data Siswa'),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3436)),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahSiswaPage()),
          );
          if (result != null && result is Map<String, String>) {
            setState(() {
              _siswaList.add(result);
            });
          }
        },
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.standalone)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Siswa',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Cari siswa...',
                  hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFB2BEC3)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('Tidak ada data siswa', style: TextStyle(color: Color(0xFF636E72))),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final siswa = filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFF6C5CE7).withOpacity(0.12),
                                child: Text(
                                  siswa['name']![0],
                                  style: const TextStyle(
                                    color: Color(0xFF6C5CE7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      siswa['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xFF2D3436),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${siswa['kelas']} · ${siswa['jurusan']}',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TambahSiswaPage(siswa: siswa),
                                    ),
                                  );
                                  if (result != null && result is Map<String, String>) {
                                    setState(() {
                                      final i = _siswaList.indexWhere((s) => s['id'] == siswa['id']);
                                      if (i != -1) _siswaList[i] = result;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                color: const Color(0xFF6C5CE7),
                              ),
                              IconButton(
                                onPressed: () => _showDeleteDialog(siswa),
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: const Color(0xFFD63031),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}