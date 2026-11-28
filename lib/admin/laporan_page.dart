import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LaporanPage extends StatefulWidget {
  final bool standalone;

  const LaporanPage({
    super.key,
    this.standalone = false,
  });

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  // Warna utama aplikasi
  static const Color primaryColor = Color(0xFF6C5CFF);
  static const Color lightPurple = Color(0xFFEDE9FF);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color background = Color(0xFFF8F9FE);

  // Koneksi Supabase
  final supabase = Supabase.instance.client;

  // Pengaturan tab dan download
  int selectedTab = 0;
  bool isDownloading = false;

  // Future untuk menyimpan data laporan
  late Future<List<Map<String, dynamic>>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _ambilData(0);
  }

  // MENGAMBIL DATA DARI SUPABASE
  Future<List<Map<String, dynamic>>> _ambilData(int index) async {
    if (index == 0) {
      final data = await supabase
          .from('siswa')
          .select('nama_siswa, kelas')
          .order('nama_siswa', ascending: true);

      return List<Map<String, dynamic>>.from(data);
    }

    if (index == 1) {
      final data = await supabase
          .from('guru')
          .select('nama_guru, nip, deskripsi, nama_sekolah')
          .order('nama_guru', ascending: true);

      return List<Map<String, dynamic>>.from(data);
    }

    final data = await supabase
        .from('jadwal_kegiatan')
        .select();

    return List<Map<String, dynamic>>.from(data);
  }

  // MENGGANTI TAB LAPORAN
  void _gantiTab(int index) {
    if (selectedTab == index) return;

    setState(() {
      selectedTab = index;
      _futureData = _ambilData(index);
    });
  }

  // REFRESH DATA
  Future<void> _refreshData() async {
    final futureBaru = _ambilData(selectedTab);

    setState(() {
      _futureData = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error ditampilkan melalui FutureBuilder.
    }
  }

  // MENGHINDARI DATA KOSONG
  String _nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  // MENGUBAH NAMA KOLOM MENJADI LABEL
  String _labelKolom(String key) {
    const labels = {
      'nama_siswa': 'Nama Siswa',
      'kelas': 'Kelas',
      'nama_guru': 'Nama Guru',
      'nip': 'NIP',
      'deskripsi': 'Deskripsi',
      'nama_sekolah': 'Sekolah',
      'nama_kegiatan': 'Nama Kegiatan',
      'tanggal': 'Tanggal',
      'waktu': 'Waktu',
      'jam': 'Jam',
      'jam_tampil': 'Jam Tampil',
      'tempat': 'Tempat',
      'ruangan': 'Ruangan',
      'guru_juri': 'Guru Juri',
      'status': 'Status',
    };

    if (labels.containsKey(key)) {
      return labels[key]!;
    }

    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((kata) {
          if (kata.isEmpty) return kata;
          return kata[0].toUpperCase() + kata.substring(1);
        })
        .join(' ');
  }

  // MENENTUKAN KOLOM SESUAI TAB
  List<String> _ambilKeys(
    int tab,
    List<Map<String, dynamic>> data,
  ) {
    if (tab == 0) {
      return [
        'nama_siswa',
        'kelas',
      ];
    }

    if (tab == 1) {
      return [
        'nama_guru',
        'nip',
        'deskripsi',
        'nama_sekolah',
      ];
    }

    if (data.isEmpty) return [];

    return data.first.keys.where((key) {
      final namaKolom = key.toLowerCase();

      // Menyembunyikan kolom yang tidak perlu ditampilkan
      if (namaKolom == 'id' ||
          namaKolom.startsWith('id_') ||
          namaKolom == 'user_id' ||
          namaKolom.contains('password') ||
          namaKolom.contains('username') ||
          namaKolom.contains('foto')) {
        return false;
      }

      return true;
    }).toList();
  }

  // MENENTUKAN JUDUL TABEL
  List<String> _ambilJudul(
    int tab,
    List<Map<String, dynamic>> data,
  ) {
    final keys = _ambilKeys(tab, data);

    return [
      'No',
      ...keys.map((key) => _labelKolom(key)),
    ];
  }

  // TEKS DALAM TABEL
  Widget _teksTabel(
    String value, {
    bool header = false,
  }) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: header ? 12 : 11,
        fontWeight: header ? FontWeight.bold : FontWeight.w500,
        color: header ? Colors.white : darkPurple,
        height: 1.4,
      ),
    );
  }

  // HEADER TABEL
  Widget _headerTabel(List<String> judul) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Row(
        children: judul.map((item) {
          return SizedBox(
            width: 125,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 5,
              ),
              child: _teksTabel(
                item,
                header: true,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ISI TABEL
  Widget _isiTabel(
    List<Map<String, dynamic>> data,
    List<String> keys,
  ) {
    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];

        return Container(
          decoration: BoxDecoration(
            color: index.isEven
                ? Colors.white
                : const Color(0xFFF9F8FF),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 0.7,
              ),
            ),
          ),
          child: Row(
            children: [
              // Nomor urut
              SizedBox(
                width: 125,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 5,
                  ),
                  child: _teksTabel('${index + 1}'),
                ),
              ),

              // Data setiap kolom
              ...keys.map((key) {
                return SizedBox(
                  width: 125,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 5,
                    ),
                    child: _teksTabel(_nilai(item[key])),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  // TABEL LAPORAN
  Widget _buildTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureData,
      builder: (context, snapshot) {
        // Tampilan loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
          );
        }

        // Tampilan ketika terjadi error
        if (snapshot.hasError) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gagal mengambil data',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data ?? [];

        // Tampilan ketika data kosong
        if (data.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  color: Colors.grey,
                  size: 48,
                ),
                SizedBox(height: 10),
                Text(
                  'Belum ada data laporan.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        final keys = _ambilKeys(selectedTab, data);
        final judul = _ambilJudul(selectedTab, data);

        // Tabel dapat digeser secara horizontal dan vertikal
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerTabel(judul),
                _isiTabel(data, keys),
              ],
            ),
          ),
        );
      },
    );
  }

  // DOWNLOAD DAN CETAK LAPORAN PDF
  Future<void> _unduhLaporan() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
    });

    try {
      final tabSaatIni = selectedTab;
      final data = await _futureData;

      if (!mounted) return;

      // Memeriksa apakah data tersedia
      if (data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Belum ada data untuk diunduh.'),
          ),
        );
        return;
      }

      final pdf = pw.Document();

      late String namaLaporan;
      late String namaFile;

      // Menentukan nama laporan
      if (tabSaatIni == 0) {
        namaLaporan = 'LAPORAN DATA PESERTA';
        namaFile = 'laporan_peserta.pdf';
      } else if (tabSaatIni == 1) {
        namaLaporan = 'LAPORAN DATA GURU JURI';
        namaFile = 'laporan_guru_juri.pdf';
      } else {
        namaLaporan = 'LAPORAN JADWAL KEGIATAN';
        namaFile = 'laporan_jadwal.pdf';
      }

      // Mengambil kolom laporan
      final keys = _ambilKeys(tabSaatIni, data);

      final judul = [
        'No',
        ...keys.map((key) => _labelKolom(key)),
      ];

      // Membuat isi baris PDF
      final List<List<String>> barisData = [];

      for (int i = 0; i < data.length; i++) {
        barisData.add([
          '${i + 1}',
          ...keys.map((key) => _nilai(data[i][key])),
        ]);
      }

      // Mengambil tanggal cetak
      final tanggalCetak = DateTime.now();

      final tanggal = [
        tanggalCetak.day.toString().padLeft(2, '0'),
        tanggalCetak.month.toString().padLeft(2, '0'),
        tanggalCetak.year.toString(),
      ].join('-');

      // Membuat halaman PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(35),
          build: (context) {
            return [
              // Nama aplikasi
              pw.Center(
                child: pw.Text(
                  'NISKALA',
                  style: pw.TextStyle(
                    fontSize: 27,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepPurple,
                  ),
                ),
              ),

              pw.SizedBox(height: 7),

              // Deskripsi aplikasi
              pw.Center(
                child: pw.Text(
                  'Aplikasi Pencarian dan Pengembangan Bakat Siswa',
                  style: const pw.TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Divider(
                color: PdfColors.deepPurple,
                thickness: 2,
              ),

              pw.SizedBox(height: 18),

              // Judul laporan
              pw.Center(
                child: pw.Text(
                  namaLaporan,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 22),

              // Informasi laporan
              pw.Text(
                'Tanggal cetak: $tanggal',
                style: const pw.TextStyle(fontSize: 11),
              ),

              pw.SizedBox(height: 5),

              pw.Text(
                'Jumlah data: ${data.length}',
                style: const pw.TextStyle(fontSize: 11),
              ),

              pw.SizedBox(height: 18),

              // Tabel PDF
              pw.TableHelper.fromTextArray(
                headers: judul,
                data: barisData,
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.deepPurple,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 10,
                ),
                cellAlignment: pw.Alignment.center,
                headerAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.all(9),
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
              ),

              pw.SizedBox(height: 28),

              // Footer PDF
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Laporan dibuat melalui aplikasi Niskala.',
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ];
          },
        ),
      );

      // Membuka fitur cetak atau simpan PDF
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: namaFile,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat laporan PDF: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  // TAMPILAN UTAMA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // Area aman layar
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Menyesuaikan padding berdasarkan lebar layar
            final double horizontalPadding =
                constraints.maxWidth < 400 ? 14 : 24;

            // Membatasi lebar konten agar tetap rapi di layar besar
            final double maxContentWidth =
                constraints.maxWidth > 1200
                    ? 1200
                    : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: maxContentWidth,
                height: constraints.maxHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER HALAMAN
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 22,
                              color: darkPurple,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 35,
                              minHeight: 35,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              'Laporan Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),

                      const SizedBox(height: 16),

                      // TAB LAPORAN
                      Row(
                        children: [
                          _tabButton('Peserta', 0),
                          const SizedBox(width: 7),
                          _tabButton('Guru Juri', 1),
                          const SizedBox(width: 7),
                          _tabButton('Jadwal', 2),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // JUDUL BAGIAN DAN TOMBOL REFRESH
                      Row(
                        children: [
                          const Icon(
                            Icons.table_chart_rounded,
                            color: primaryColor,
                            size: 19,
                          ),

                          const SizedBox(width: 7),

                          Expanded(
                            child: Text(
                              selectedTab == 0
                                  ? 'Data Peserta'
                                  : selectedTab == 1
                                      ? 'Data Guru Juri'
                                      : 'Data Jadwal Kegiatan',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: _refreshData,
                            tooltip: 'Refresh data',
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: primaryColor,
                              size: 21,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // AREA TABEL
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE8E5F5),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildTable(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // TOMBOL DOWNLOAD PDF
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 280,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: isDownloading
                                  ? null
                                  : _unduhLaporan,
                              icon: isDownloading
                                  ? const SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.download_rounded,
                                      size: 19,
                                    ),
                              label: Text(
                                isDownloading
                                    ? 'Memproses...'
                                    : 'Unduh Laporan PDF',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                disabledBackgroundColor:
                                    primaryColor.withOpacity(0.6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // TOMBOL TAB LAPORAN
  Widget _tabButton(String title, int index) {
    final bool active = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _gantiTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: 11,
            horizontal: 4,
          ),
          decoration: BoxDecoration(
            color: active ? primaryColor : lightPurple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : darkPurple,
            ),
          ),
        ),
      ),
    );
  }
}