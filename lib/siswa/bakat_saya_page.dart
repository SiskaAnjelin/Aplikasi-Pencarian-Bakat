import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BakatSayaPage extends StatefulWidget {
  const BakatSayaPage({super.key});

  @override
  State<BakatSayaPage> createState() => _BakatSayaPageState();
}

class _BakatSayaPageState extends State<BakatSayaPage> {
  final supabase = Supabase.instance.client;

  int _selectedTab = 0;
  late Future<List<Map<String, dynamic>>> _bakatFuture;

  static const Color purple = Color(0xFF6C63FF);
  static const Color dark = Color(0xFF1A1A2E);
  static const Color background = Color(0xFFF8F9FC);

  @override
  void initState() {
    super.initState();
    _bakatFuture = _ambilBakatSaya();
  }

  // AMBIL DATA BAKAT SISWA ASLI DARI SUPABASE
  Future<List<Map<String, dynamic>>> _ambilBakatSaya() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final siswa = await supabase
          .from('siswa')
          .select('id_siswa')
          .eq('user_id', user.id)
          .maybeSingle();

      if (siswa == null) return [];

      final dataPengajuan = await supabase
          .from('pengajuan_bakat')
          .select(
            'id_pengajuan, status, tanggal_pengajuan, rekomendasi, '
            'bakat:id_bakat(nama_bakat, kategori, deskripsi)',
          )
          .eq('id_siswa', siswa['id_siswa'])
          .order('tanggal_pengajuan', ascending: false);

      final List<Map<String, dynamic>> hasil = [];

      for (var item in dataPengajuan) {
        final bakat = item['bakat'] as Map<String, dynamic>? ?? {};
        hasil.add({
          'nama': bakat['nama_bakat'] ?? 'Bakat',
          'kategori': bakat['kategori'] ?? 'Umum',
          'status': item['status'] ?? 'Menunggu',
          'deskripsi': bakat['deskripsi'] ?? '',
        });
      }

      return hasil;
    } catch (e) {
      debugPrint('Error ambil bakat saya: $e');
      return [];
    }
  }

  // REFRESH DATA
  Future<void> _refresh() async {
    setState(() {
      _bakatFuture = _ambilBakatSaya();
    });
    await _bakatFuture;
  }

  // FILTER BERDASARKAN TAB KATEGORI
  List<Map<String, dynamic>> _filterBakat(List<Map<String, dynamic>> list) {
    if (_selectedTab == 0) return list;
    final kategori = _selectedTab == 1 ? "Seni" : "Akademik";
    return list.where((b) {
      final kat = (b['kategori'] ?? '').toString().toLowerCase();
      return kat.contains(kategori.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: dark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bakat Saya",
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh, color: purple),
          ),
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bakatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: purple));
          }

          final allBakat = snapshot.data ?? [];
          final displayedBakat = _filterBakat(allBakat);

          return Column(
            children: [
              // TAB FILTER
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
                child: Row(
                  children: [
                    _buildTab("Semua", 0),
                    const SizedBox(width: 8),
                    _buildTab("Seni", 1),
                    const SizedBox(width: 8),
                    _buildTab("Akademik", 2),
                  ],
                ),
              ),

              // JUMLAH BAKAT
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${displayedBakat.length} Bakat Ditemukan",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ),

              // DAFTAR BAKAT
              Expanded(
                child: displayedBakat.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stars_outlined, size: 55, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            Text(
                              allBakat.isEmpty
                                  ? "Anda belum mengajukan bakat apapun.\nKlik tombol Tambah Bakat untuk memulai!"
                                  : "Tidak ada bakat pada kategori ini.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: purple,
                        onRefresh: _refresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: displayedBakat.length,
                          itemBuilder: (context, index) {
                            final bakat = displayedBakat[index];
                            return _buildCardBakat(bakat);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // TAB BUTTON
  Widget _buildTab(String title, int index) {
    final bool active = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? purple : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? purple : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : dark,
            ),
          ),
        ),
      ),
    );
  }

  // CARD BAKAT
  Widget _buildCardBakat(Map<String, dynamic> bakat) {
    final String nama = bakat['nama'] ?? 'Bakat';
    final String kategori = bakat['kategori'] ?? 'Umum';
    final String status = bakat['status'] ?? 'Menunggu';

    Color statusColor;
    Color statusBgColor;

    if (status.toLowerCase().contains('unggul') ||
        status.toLowerCase().contains('terima') ||
        status.toLowerCase().contains('setuju')) {
      statusColor = const Color(0xFF2E7D32);
      statusBgColor = const Color(0xFFE8F5E9);
    } else if (status.toLowerCase().contains('proses')) {
      statusColor = const Color(0xFFE65100);
      statusBgColor = const Color(0xFFFFF3E0);
    } else {
      statusColor = const Color(0xFF1565C0);
      statusBgColor = const Color(0xFFE3F2FD);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              kategori.toLowerCase().contains('seni')
                  ? Icons.palette_rounded
                  : Icons.school_rounded,
              color: purple,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kategori: $kategori',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}