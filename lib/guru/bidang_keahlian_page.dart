import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BidangKeahlianPage extends StatefulWidget {
  final List<String> bidangAwal;

  const BidangKeahlianPage({
    super.key,
    this.bidangAwal = const [],
  });

  @override
  State<BidangKeahlianPage> createState() =>
      _BidangKeahlianPageState();
}

class _BidangKeahlianPageState extends State<BidangKeahlianPage> {
  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color ungu = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color lightPurple = Color(0xFFEDEBFF);
  static const Color background = Color(0xFFF7F6FC);

  // ==========================================
  // SUPABASE DAN VARIABEL
  // ==========================================

  final supabase = Supabase.instance.client;

  late Set<String> terpilih;

  bool sedangMenyimpan = false;

  // ==========================================
  // DAFTAR BIDANG KEAHLIAN
  // ==========================================

  final List<Map<String, dynamic>> bidang = [
    {
      'nama': 'Desain',
      'icon': Icons.palette_outlined,
      'warna': const Color(0xFFEDE9FF),
    },
    {
      'nama': 'Teater',
      'icon': Icons.theater_comedy_outlined,
      'warna': const Color(0xFFFFE9E7),
    },
    {
      'nama': 'Seni Rupa',
      'icon': Icons.brush_outlined,
      'warna': const Color(0xFFFFF1D6),
    },
    {
      'nama': 'Olahraga',
      'icon': Icons.sports_basketball_outlined,
      'warna': const Color(0xFFE1F3FF),
    },
    {
      'nama': 'Teknologi',
      'icon': Icons.computer_outlined,
      'warna': const Color(0xFFE4F5E9),
    },
    {
      'nama': 'Robotic',
      'icon': Icons.smart_toy_outlined,
      'warna': const Color(0xFFFCE4F1),
    },
  ];

  @override
  void initState() {
    super.initState();

    // Mengambil pilihan bidang yang sebelumnya tersimpan.
    terpilih = widget.bidangAwal.toSet();
  }

  // ==========================================
  // MEMILIH ATAU MEMBATALKAN BIDANG
  // ==========================================

  void pilihBidang(String nama) {
    setState(() {
      if (terpilih.contains(nama)) {
        terpilih.remove(nama);
      } else {
        terpilih.add(nama);
      }
    });
  }

  // ==========================================
  // MENYIMPAN BIDANG KEAHLIAN KE SUPABASE
  // ==========================================

  Future<void> simpanBidang() async {
    // Memastikan minimal ada satu bidang dipilih.
    if (terpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih minimal satu bidang keahlian!',
          ),
        ),
      );
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Pengguna belum login.');
      }

      // Mengubah Set menjadi List.
      final daftarBidang = terpilih.toList();

      // Menggabungkan daftar bidang menjadi teks.
      final deskripsi = daftarBidang.join(', ');

      // Memperbarui data guru di Supabase.
      await supabase
          .from('guru')
          .update({
            'deskripsi': deskripsi,
          })
          .eq('user_id', user.id);

      debugPrint('UID GURU: ${user.id}');
      debugPrint('BIDANG TERSIMPAN: $deskripsi');

      if (!mounted) return;

      // Menampilkan notifikasi berhasil.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bidang keahlian berhasil disimpan!',
          ),
          backgroundColor: Color(0xFF75C9A5),
        ),
      );

      // Kembali ke Profil Guru dengan daftar bidang terbaru.
      Navigator.pop(context, daftarBidang);
    } catch (e) {
      debugPrint('ERROR SIMPAN BIDANG: $e');

      if (!mounted) return;

      // Menampilkan notifikasi gagal.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan bidang: $e',
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMenyimpan = false;
        });
      }
    }
  }

  // ==========================================
  // KARTU INFORMASI
  // ==========================================

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkPurple,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: Color(0xFFFFC857),
            size: 32,
          ),

          const SizedBox(height: 12),

          const Text(
            'Kenali Keahlianmu!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Pilih bidang keahlian sesuai kemampuan dan minatmu.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // JUDUL BAGIAN PILIH BIDANG
  // ==========================================

  Widget _buildSectionTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Bidang Keahlian',
          style: TextStyle(
            color: darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Kamu bisa memilih lebih dari satu bidang.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // KARTU PILIHAN BIDANG
  // ==========================================

  Widget _buildBidangCard(
    Map<String, dynamic> item,
  ) {
    final nama = item['nama'] as String;
    final icon = item['icon'] as IconData;
    final warna = item['warna'] as Color;

    final dipilih = terpilih.contains(nama);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: sedangMenyimpan
            ? null
            : () => pilihBidang(nama),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dipilih
                  ? ungu
                  : Colors.grey.shade200,
              width: dipilih ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ikon dan tanda pilihan.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: warna,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: darkPurple,
                      size: 25,
                    ),
                  ),

                  if (dipilih)
                    const Icon(
                      Icons.check_circle,
                      color: ungu,
                      size: 21,
                    )
                  else
                    Icon(
                      Icons.circle_outlined,
                      color: Colors.grey.shade300,
                      size: 21,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Nama bidang.
              Text(
                nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: darkPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // GRID PILIHAN BIDANG
  // ==========================================

  Widget _buildBidangGrid(double lebar) {
    // Menyesuaikan jumlah kolom berdasarkan lebar layar.
    int jumlahKolom;

    if (lebar >= 850) {
      jumlahKolom = 4;
    } else if (lebar >= 550) {
      jumlahKolom = 3;
    } else {
      jumlahKolom = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bidang.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: jumlahKolom,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: lebar < 360 ? 1.05 : 1.15,
      ),
      itemBuilder: (context, index) {
        return _buildBidangCard(bidang[index]);
      },
    );
  }

  // ==========================================
  // JUMLAH BIDANG YANG DIPILIH
  // ==========================================

  Widget _buildJumlahPilihan() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: ungu,
            size: 18,
          ),

          const SizedBox(width: 8),

          Text(
            '${terpilih.length} bidang dipilih',
            style: const TextStyle(
              color: ungu,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOMBOL SIMPAN
  // ==========================================

  Widget _buildTombolSimpan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: sedangMenyimpan
                    ? null
                    : simpanBidang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ungu,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      ungu.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: sedangMenyimpan
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan Bidang Keahlian',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BUILD HALAMAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // HEADER HALAMAN.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkPurple,
            size: 22,
          ),
          onPressed: sedangMenyimpan
              ? null
              : () => Navigator.pop(context),
        ),
        title: const Text(
          'Bidang Keahlian',
          style: TextStyle(
            color: darkPurple,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // KONTEN HALAMAN.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Area konten yang dapat di-scroll.
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        // Membatasi lebar konten pada layar besar.
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kartu informasi.
                            _buildInfoCard(),

                            const SizedBox(height: 24),

                            // Judul pilihan bidang.
                            _buildSectionTitle(),

                            const SizedBox(height: 16),

                            // Grid bidang keahlian responsif.
                            _buildBidangGrid(
                              constraints.maxWidth > 900
                                  ? 900
                                  : constraints.maxWidth,
                            ),

                            const SizedBox(height: 18),

                            // Jumlah bidang terpilih.
                            _buildJumlahPilihan(),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Tombol simpan selalu berada di bawah.
                _buildTombolSimpan(),
              ],
            );
          },
        ),
      ),
    );
  }
}