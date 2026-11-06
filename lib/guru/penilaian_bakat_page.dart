<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PenilaianBakatPage extends StatefulWidget {
  const PenilaianBakatPage({super.key});
=======
import 'package:flutter/material.dart';

class PenilaianBakatPage extends StatefulWidget {
  final String? siswaName;
  final String? bakatName;

  const PenilaianBakatPage({super.key, this.siswaName, this.bakatName});
>>>>>>> origin/main

  @override
  State<PenilaianBakatPage> createState() => _PenilaianBakatPageState();
}

class _PenilaianBakatPageState extends State<PenilaianBakatPage> {
<<<<<<< HEAD
  // Status tab aktif: true untuk "Form Penilaian", false untuk "Riwayat"
  bool isFormPenilaian = true;

  // Nilai slider untuk aspek penilaian
  double nilaiKomposisi = 85;
  double nilaiTeknik = 82;
  double nilaiDetail = 90;

  final Color primaryColor = const Color(0xFF6C63FF); // Ungu khas tombol & slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Tombol Back & Judul
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Penilaian Bakat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PROFIL SISWA (Foto & Informasi Singkat)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFD3E3FD),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      size: 36,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Noufal Zaidan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'XII RPL B • Seni',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // TOGGLE TAB (Form Penilaian & Riwayat)
              Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E7), // Abu-abu latar tab
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFormPenilaian = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFormPenilaian ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isFormPenilaian
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Form Penilaian',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isFormPenilaian ? primaryColor : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFormPenilaian = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isFormPenilaian ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: !isFormPenilaian
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Riwayat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !isFormPenilaian ? primaryColor : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ASPEK PENILAIAN JUDUL
              const Text(
                'Aspek Penilaian',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // SLIDER 1: Komposisi & Tata Letak
              _buildAssessmentSlider(
                title: 'Komposisi & Tata Letak',
                value: nilaiKomposisi,
                onChanged: (val) {
                  setState(() {
                    nilaiKomposisi = val;
                  });
                },
              ),

              const SizedBox(height: 16),

              // SLIDER 2: Teknik Gambar
              _buildAssessmentSlider(
                title: 'Teknik Gambar',
                value: nilaiTeknik,
                onChanged: (val) {
                  setState(() {
                    nilaiTeknik = val;
                  });
                },
              ),

              const SizedBox(height: 16),

              // SLIDER 3: Detail & Kerapian
              _buildAssessmentSlider(
                title: 'Detail & Kerapian',
                value: nilaiDetail,
                onChanged: (val) {
                  setState(() {
                    nilaiDetail = val;
                  });
                },
              ),

              const SizedBox(height: 28),

              // KOTAK CATATAN GURU
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Catatan Guru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kerapian dan detail karya sangat luar biasa! Tingkatkan terus latihan pada teknik pewarnaan agar komposisi visual terasa lebih hidup dan seimbang.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // TOMBOL SIMPAN PENILAIAN
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Aksi simpan penilaian
                  },
                  child: const Text(
                    'Simpan Penilaian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET KUSTOM UNTUK SLIDER PENILAIAN
  Widget _buildAssessmentSlider({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              value.toInt().toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: primaryColor,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: primaryColor,
            overlayColor: primaryColor.withOpacity(0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class PenilaianBakatRiwayatPage extends StatefulWidget {
  const PenilaianBakatRiwayatPage({super.key});

  @override
  State<PenilaianBakatRiwayatPage> createState() => _PenilaianBakatRiwayatPageState();
}

class _PenilaianBakatRiwayatPageState extends State<PenilaianBakatRiwayatPage> {
  // Status tab aktif: false karena saat ini tab "Riwayat" yang dipilih
  bool isFormPenilaian = false;

  final Color primaryColor = const Color(0xFF6C63FF); // Ungu khas tombol & tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Tombol Back & Judul
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Penilaian Bakat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PROFIL SISWA (Foto & Informasi Singkat)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFD3E3FD),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      size: 36,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Noufal Zaidan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'XII RPL B • Seni',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // TOGGLE TAB (Form Penilaian & Riwayat - Riwayat Aktif)
              Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E7), // Abu-abu latar tab
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFormPenilaian = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFormPenilaian ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isFormPenilaian
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Form Penilaian',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isFormPenilaian ? primaryColor : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFormPenilaian = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isFormPenilaian ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: !isFormPenilaian
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Riwayat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !isFormPenilaian ? primaryColor : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // KARTU RIWAYAT 1
              _buildHistoryCard(
                title: 'Noufal Zaidan',
                subtitle: 'Lomba Komik FLS2N\n- Tingkat Provinsi',
                date: '20 Desember 2025',
                status: 'Selesai',
              ),

              const SizedBox(height: 16),

              // KARTU RIWAYAT 2
              _buildHistoryCard(
                title: 'Noufal Zaidan',
                subtitle: 'Kompetisi Desain Grafis\n& Kampanye Visual',
                date: '8 Januari 2026',
                status: 'Selesai',
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET KARTU RIWAYAT
  Widget _buildHistoryCard({
    required String title,
    required String subtitle,
    required String date,
    required String status,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.5), // Garis pinggir ungu lembut
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto Profil di dalam Kartu
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFD3E3FD),
            child: Icon(
              CupertinoIcons.person_fill,
              size: 32,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          // Informasi Kegiatan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                // Badge Selesai warna hijau
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8E6CF), // Hijau pastel
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
=======
  int _selectedTab = 0;
  double _kreativitas = 70;
  double _teknik = 75;
  double _konsistensi = 80;
  final _rekomendasiController = TextEditingController();

  final List<Map<String, String>> _list = [
    {'nama': 'Naufal Zaidan', 'bakat': 'Menyanyi', 'kelas': 'XI RPL 1', 'status': 'Pending'},
    {'nama': 'Alya Nayumi', 'bakat': 'Menari', 'kelas': 'XI RPL 2', 'status': 'Pending'},
    {'nama': 'Rizky Maulana', 'bakat': 'Coding', 'kelas': 'X RPL 1', 'status': 'Disetujui'},
    {'nama': 'Sinta Angelia', 'bakat': 'Menggambar', 'kelas': 'XI TKJ 1', 'status': 'Disetujui'},
  ];

  @override
  void dispose() {
    _rekomendasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.siswaName != null) return _buildForm();
    return _buildList();
  }

  Widget _buildList() {
    final filtered = _selectedTab == 0
        ? _list
        : _selectedTab == 1
            ? _list.where((e) => e['status'] == 'Pending').toList()
            : _list.where((e) => e['status'] == 'Disetujui').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Penilaian Bakat',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                _tab('Semua', 0),
                const SizedBox(width: 8),
                _tab('Pending', 1),
                const SizedBox(width: 8),
                _tab('Disetujui', 2),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final item = filtered[i];
                final pending = item['status'] == 'Pending';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PenilaianBakatPage(
                          siswaName: item['nama'],
                          bakatName: item['bakat'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFE8E7FF),
                          child: Text(item['nama']![0],
                              style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['nama']!,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1A1A2E))),
                              const SizedBox(height: 2),
                              Text('${item['bakat']} · ${item['kelas']}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: pending
                                ? const Color(0xFFFF9800).withOpacity(0.1)
                                : const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item['status']!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: pending ? const Color(0xFFFF9800) : const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Penilaian Bakat',
            style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFE8E7FF),
                    child: Text(widget.siswaName![0],
                        style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.siswaName!,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF1A1A2E))),
                      Text(widget.bakatName ?? 'Bakat', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Aspek Penilaian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 16),
            _slider('Kreativitas', _kreativitas, (v) => setState(() => _kreativitas = v)),
            _slider('Teknik', _teknik, (v) => setState(() => _teknik = v)),
            _slider('Konsistensi', _konsistensi, (v) => setState(() => _konsistensi = v)),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rata-rata Skor', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    ((_kreativitas + _teknik + _konsistensi) / 3).toStringAsFixed(0),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Rekomendasi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _rekomendasiController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Berikan rekomendasi...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bakat ditolak'), backgroundColor: Colors.red),
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bakat disetujui!'), backgroundColor: Color(0xFF4CAF50)),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Setujui'),
>>>>>>> origin/main
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
=======
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, int index) {
    final selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF6C63FF) : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : Colors.grey[600])),
      ),
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(value.toStringAsFixed(0),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C63FF), fontSize: 16)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6C63FF),
              inactiveTrackColor: const Color(0xFF6C63FF).withOpacity(0.15),
              thumbColor: const Color(0xFF6C63FF),
              trackHeight: 6,
            ),
            child: Slider(value: value, min: 0, max: 100, divisions: 20, onChanged: onChanged),
>>>>>>> origin/main
          ),
        ],
      ),
    );
  }
}