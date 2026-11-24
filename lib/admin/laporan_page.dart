
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
  static const Color primaryColor = Color(0xFF6C5CFF);
  static const Color lightPurple = Color(0xFFEDE9FF);
  static const Color darkPurple = Color(0xFF29264F);

  final supabase = Supabase.instance.client;

  int selectedTab = 0;
  bool isDownloading = false;

  late Future<List<Map<String, dynamic>>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _ambilData(0);
  }

  //ambil data laporan dari supabase
  Future<List<Map<String, dynamic>>> _ambilData(int index) async {
    //ambil data peserta dari tabel siswa
    if (index == 0) {
      final data = await supabase
          .from('siswa')
          .select('nama_siswa, kelas')
          .order('nama_siswa', ascending: true);

      return List<Map<String, dynamic>>.from(data);
    }

    //ambil data guru dari tabel guru
    if (index == 1) {
      final data = await supabase
          .from('guru')
          .select('nama_guru, nip, deskripsi, nama_sekolah')
          .order('nama_guru', ascending: true);

      return List<Map<String, dynamic>>.from(data);
    }

    //ambil semua data jadwal kegiatan
    final data = await supabase
        .from('jadwal_kegiatan')
        .select();

    return List<Map<String, dynamic>>.from(data);
  }

  //ganti tab laporan
  void _gantiTab(int index) {
    if (selectedTab == index) return;

    setState(() {
      selectedTab = index;
      _futureData = _ambilData(index);
    });
  }

  //menghindari data kosong
  String _nilai(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  //mengubah nama kolom menjadi judul
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

  //mengambil kolom sesuai tab
  List<String> _ambilKeys(
    int tab,
    List<Map<String, dynamic>> data,
  ) {
    //kolom laporan peserta
    if (tab == 0) {
      return [
        'nama_siswa',
        'kelas',
      ];
    }

    //kolom laporan guru juri
    if (tab == 1) {
      return [
        'nama_guru',
        'nip',
        'deskripsi',
        'nama_sekolah',
      ];
    }

    //kolom laporan jadwal secara dinamis
    if (data.isEmpty) return [];

    return data.first.keys.where((key) {
      final namaKolom = key.toLowerCase();

      //sembunyikan id dan data sensitif
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

  //membuat judul tabel
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

  //mengatur tampilan teks tabel
  Widget _teksTabel(
    String value, {
    bool header = false,
  }) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: header ? 9 : 8,
        fontWeight: header ? FontWeight.bold : FontWeight.normal,
        color: header ? Colors.white : darkPurple,
      ),
    );
  }

  //membuat header tabel
  Widget _headerTabel(List<String> judul) {
    return Container(
      color: primaryColor,
      child: Row(
        children: judul.map((item) {
          return SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 3,
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

  //membuat isi tabel
  Widget _isiTabel(
    List<Map<String, dynamic>> data,
    List<String> keys,
  ) {
    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 3,
                  ),
                  child: _teksTabel('${index + 1}'),
                ),
              ),

              ...keys.map((key) {
                return SizedBox(
                  width: 110,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 3,
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

  //menampilkan tabel sesuai tab
  Widget _buildTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gagal mengambil data',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureData = _ambilData(selectedTab);
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  color: Colors.grey,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada data laporan.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        final keys = _ambilKeys(selectedTab, data);
        final judul = _ambilJudul(selectedTab, data);

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

  //membuat dan mengunduh laporan pdf
  Future<void> _unduhLaporan() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
    });

    try {
      final tabSaatIni = selectedTab;
      final data = await _futureData;

      if (!mounted) return;

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

      //nama laporan peserta
      if (tabSaatIni == 0) {
        namaLaporan = 'LAPORAN DATA PESERTA';
        namaFile = 'laporan_peserta.pdf';
      }

      //nama laporan guru juri
      else if (tabSaatIni == 1) {
        namaLaporan = 'LAPORAN DATA GURU JURI';
        namaFile = 'laporan_guru_juri.pdf';
      }

      //nama laporan jadwal
      else {
        namaLaporan = 'LAPORAN JADWAL KEGIATAN';
        namaFile = 'laporan_jadwal.pdf';
      }

      final keys = _ambilKeys(tabSaatIni, data);

      final judul = [
        'No',
        ...keys.map((key) => _labelKolom(key)),
      ];

      //menyiapkan baris data pdf
      final List<List<String>> barisData = [];

      for (int i = 0; i < data.length; i++) {
        barisData.add([
          '${i + 1}',
          ...keys.map((key) => _nilai(data[i][key])),
        ]);
      }

      final tanggalCetak = DateTime.now();

      final tanggal = [
        tanggalCetak.day.toString().padLeft(2, '0'),
        tanggalCetak.month.toString().padLeft(2, '0'),
        tanggalCetak.year.toString(),
      ].join('-');

      //membuat halaman pdf
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(35),
          build: (context) {
            return [
              pw.Center(
                child: pw.Text(
                  'NISKALA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepPurple,
                  ),
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Center(
                child: pw.Text(
                  'Aplikasi Pencarian dan Pengembangan Bakat Siswa',
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),

              pw.SizedBox(height: 18),

              pw.Divider(
                color: PdfColors.deepPurple,
                thickness: 2,
              ),

              pw.SizedBox(height: 15),

              pw.Center(
                child: pw.Text(
                  namaLaporan,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Tanggal cetak: $tanggal',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'Jumlah data: ${data.length}',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.SizedBox(height: 15),

              //tabel data pdf
              pw.TableHelper.fromTextArray(
                headers: judul,
                data: barisData,
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.deepPurple,
                ),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 9,
                ),
                cellAlignment: pw.Alignment.center,
                headerAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.all(8),
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
              ),

              pw.SizedBox(height: 25),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Laporan dibuat melalui aplikasi Niskala.',
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ),
                ),
              ),
            ];
          },
        ),
      );

      //membuka pilihan cetak atau simpan pdf
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background samping kiri dan kanan hitam
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 390,
            ),
            child: Container(
              //halaman laporan putih di tengah
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header halaman
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: darkPurple,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'Laporan Data',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: Colors.grey.shade300,
                    height: 1,
                  ),

                  const SizedBox(height: 12),

                  //tab laporan
                  Row(
                    children: [
                      _tabButton('Peserta', 0),
                      const SizedBox(width: 5),
                      _tabButton('Guru Juri', 1),
                      const SizedBox(width: 5),
                      _tabButton('Jadwal', 2),
                    ],
                  ),

                  const SizedBox(height: 28),

                  //tabel laporan
                  Expanded(
                    child: _buildTable(),
                  ),

                  const SizedBox(height: 12),

                  //tombol unduh laporan pdf
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: isDownloading ? null : _unduhLaporan,
                        icon: isDownloading
                            ? const SizedBox(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.download,
                                size: 14,
                              ),
                        label: Text(
                          isDownloading
                              ? 'Memproses...'
                              : 'Unduh Laporan',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //tampilan tombol tab
  Widget _tabButton(String title, int index) {
    final bool active = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _gantiTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? primaryColor : lightPurple,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : darkPurple,
            ),
          ),
        ),
      ),
    );
  }
}
