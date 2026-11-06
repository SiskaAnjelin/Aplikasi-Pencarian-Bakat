import 'package:flutter/material.dart';

class LaporanPage extends StatefulWidget {
  final bool standalone;
  const LaporanPage({super.key, this.standalone = false});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String _periode = 'Bulan Ini';
  String _tab = 'Bakat';

  final List<Map<String, dynamic>> _distribusi = [
    {'kategori': 'Seni', 'jumlah': 5, 'persen': 33},
    {'kategori': 'Akademik', 'jumlah': 4, 'persen': 27},
    {'kategori': 'Teknologi', 'jumlah': 3, 'persen': 20},
    {'kategori': 'Olahraga', 'jumlah': 2, 'persen': 13},
    {'kategori': 'Soft Skill', 'jumlah': 1, 'persen': 7},
  ];

  final List<Map<String, dynamic>> _rekapSiswa = [
    {'name': 'Sinta Amalia', 'kelas': 'XI IPA 1', 'skor': 91},
    {'name': 'Naufal Zaidan', 'kelas': 'XI IPA 1', 'skor': 85},
    {'name': 'Alya Hayani', 'kelas': 'XI IPA 2', 'skor': 78},
    {'name': 'Rizky Maulana', 'kelas': 'X IPS 1', 'skor': 72},
  ];

  void _exportLaporan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            const Text(
              'Laporan Berhasil Diexport!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'File laporan telah disimpan',
              style: TextStyle(fontSize: 13, color: Color(0xFF636E72)),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: widget.standalone
          ? AppBar(
              title: const Text('Laporan Data'),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3436)),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.standalone)
                const Text(
                  'Laporan Data',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                ),
              if (!widget.standalone) const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Bulan Ini', 'Semester', 'Tahun Ini'].map((p) {
                    final selected = _periode == p;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _periode = p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF6C5CE7) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? const Color(0xFF6C5CE7) : const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Text(
                            p,
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFF636E72),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _reportCard('Total Siswa', '4', const Color(0xFF6C5CE7))),
                  const SizedBox(width: 12),
                  Expanded(child: _reportCard('Total Bakat', '15', const Color(0xFFFDCB6E))),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = 'Bakat'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tab == 'Bakat' ? const Color(0xFF6C5CE7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _tab == 'Bakat' ? const Color(0xFF6C5CE7) : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Distribusi Bakat',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: _tab == 'Bakat' ? Colors.white : const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = 'Siswa'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tab == 'Siswa' ? const Color(0xFF6C5CE7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _tab == 'Siswa' ? const Color(0xFF6C5CE7) : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Rekap Siswa',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: _tab == 'Siswa' ? Colors.white : const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: _tab == 'Bakat' ? _buildBakatTable() : _buildSiswaTable(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exportLaporan,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Laporan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reportCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF636E72))),
        ],
      ),
    );
  }

  Widget _buildBakatTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Distribusi Bakat per Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              Expanded(flex: 1, child: Text('Jumlah', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              Expanded(flex: 1, child: Text('%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ..._distribusi.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(e['kategori'], style: const TextStyle(fontSize: 13))),
                Expanded(
                  flex: 1,
                  child: Text('${e['jumlah']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('${e['persen']}%', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF6C5CE7), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSiswaTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rekap Skor Siswa', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              Expanded(flex: 2, child: Text('Kelas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              Expanded(flex: 1, child: Text('Skor', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ..._rekapSiswa.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(e['name'], style: const TextStyle(fontSize: 13))),
                Expanded(flex: 2, child: Text(e['kelas'], style: const TextStyle(fontSize: 13, color: Color(0xFF636E72)))),
                Expanded(
                  flex: 1,
                  child: Text('${e['skor']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7))),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}