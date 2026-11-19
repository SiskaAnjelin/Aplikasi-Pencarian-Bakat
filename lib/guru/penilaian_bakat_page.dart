
import 'package:flutter/material.dart';

class PenilaianBakatPage extends StatefulWidget {
  final String? siswaName;
  final String? bakatName;

  const PenilaianBakatPage({
    super.key,
    this.siswaName,
    this.bakatName,
  });

  @override
  State<PenilaianBakatPage> createState() =>
      _PenilaianBakatPageState();
}

class _PenilaianBakatPageState extends State<PenilaianBakatPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);

  int _selectedTab = 0;

  double nilaiKreativitas = 85;
  double nilaiTeknik = 82;
  double nilaiKonsistensi = 90;

  final TextEditingController _rekomendasiController =
      TextEditingController();

  final List<Map<String, String>> _listSiswa = [
    {
      'nama': 'Naufal Zaidan',
      'bakat': 'Menyanyi',
      'kelas': 'XI RPL 1',
      'status': 'Dalam Proses',
    },
    {
      'nama': 'Alya Nayumi',
      'bakat': 'Menari',
      'kelas': 'XI RPL 2',
      'status': 'Dalam Proses',
    },
    {
      'nama': 'Rizky Maulana',
      'bakat': 'Coding',
      'kelas': 'X RPL 1',
      'status': 'Disetujui',
    },
    {
      'nama': 'Sinta Angelia',
      'bakat': 'Menggambar',
      'kelas': 'XI TKJ 1',
      'status': 'Disetujui',
    },
  ];

  @override
  void dispose() {
    _rekomendasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.siswaName != null) {
      return _buildForm();
    }

    return _buildList();
  }

  // ================= DAFTAR PENILAIAN =================

  Widget _buildList() {
    final filteredList = _selectedTab == 0
        ? _listSiswa
        : _selectedTab == 1
            ? _listSiswa
                .where((item) =>
                    item['status'] == 'Dalam Proses')
                .toList()
            : _listSiswa
                .where((item) =>
                    item['status'] == 'Disetujui')
                .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: darkPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Penilaian Bakat',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
            child: Row(
              children: [
                _buildTab('Semua', 0),
                const SizedBox(width: 6),
                _buildTab('Dalam Proses', 1),
                const SizedBox(width: 6),
                _buildTab('Disetujui', 2),
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada data penilaian',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final dalamProses =
                          item['status'] == 'Dalam Proses';

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
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    const Color(0xFFE8E7FF),
                                child: Text(
                                  item['nama']![0],
                                  style: const TextStyle(
                                    color: purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nama']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: darkPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['bakat']} · ${item['kelas']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: dalamProses
                                      ? Colors.orange.withOpacity(0.1)
                                      : Colors.green.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item['status']!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: dalamProses
                                        ? Colors.orange
                                        : Colors.green,
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

  // ================= TAB FILTER =================

  Widget _buildTab(String label, int index) {
    final selected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected ? purple : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? purple : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  // ================= FORM PENILAIAN =================

  Widget _buildForm() {
    final nama = widget.siswaName ?? 'Nama Siswa';
    final bakat = widget.bakatName ?? 'Bakat';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: darkPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Penilaian Bakat',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Siswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE8E7FF),
                    child: Text(
                      nama.isNotEmpty ? nama[0] : '?',
                      style: const TextStyle(
                        color: purple,
                        fontSize: 20,
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
                          nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: darkPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bakat,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Aspek Penilaian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 14),

            _buildSlider(
              title: 'Kreativitas',
              value: nilaiKreativitas,
              onChanged: (value) {
                setState(() {
                  nilaiKreativitas = value;
                });
              },
            ),

            const SizedBox(height: 12),

            _buildSlider(
              title: 'Teknik',
              value: nilaiTeknik,
              onChanged: (value) {
                setState(() {
                  nilaiTeknik = value;
                });
              },
            ),

            const SizedBox(height: 12),

            _buildSlider(
              title: 'Konsistensi',
              value: nilaiKonsistensi,
              onChanged: (value) {
                setState(() {
                  nilaiKonsistensi = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Rata-rata Nilai
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rata-rata Skor',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkPurple,
                    ),
                  ),
                  Text(
                    ((nilaiKreativitas +
                                nilaiTeknik +
                                nilaiKonsistensi) /
                            3)
                        .toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: purple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Catatan dan Rekomendasi Guru',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 9),

            TextField(
              controller: _rekomendasiController,
              maxLines: 4,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Tuliskan catatan atau rekomendasi...',
                hintStyle: const TextStyle(fontSize: 12),
                filled: true,
                fillColor: const Color(0xFFF8F9FC),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Tombol Tolak dan Setujui
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _selesaikanPenilaian(
                        'Bakat ditolak',
                        Colors.red,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: purple,
                      side: const BorderSide(color: purple),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'Tolak',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _selesaikanPenilaian(
                        'Bakat disetujui!',
                        Colors.green,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'Setujui',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= SLIDER =================

  Widget _buildSlider({
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: darkPurple,
              ),
            ),
            Text(
              value.toInt().toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            activeTrackColor: purple,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: purple,
            overlayColor: purple.withOpacity(0.12),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 7,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ================= AKSI PENILAIAN =================

  void _selesaikanPenilaian(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: warna,
      ),
    );

    Navigator.pop(context);
  }
}

// ================= HALAMAN RIWAYAT PENILAIAN =================

class PenilaianBakatRiwayatPage extends StatelessWidget {
  const PenilaianBakatRiwayatPage({super.key});

  static const Color purple = Color(0xFF6C5CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF29264F),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Penilaian',
          style: TextStyle(
            color: Color(0xFF29264F),
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          _RiwayatCard(
            title: 'Noufal Zaidan',
            subtitle: 'Lomba Komik FLS2N - Tingkat Provinsi',
            date: '20 Desember 2025',
          ),
          SizedBox(height: 12),
          _RiwayatCard(
            title: 'Noufal Zaidan',
            subtitle: 'Kompetisi Desain Grafis dan Kampanye Visual',
            date: '8 Januari 2026',
          ),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;

  const _RiwayatCard({
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF6C5CFF).withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFD3E3FD),
            child: Icon(
              Icons.person,
              size: 28,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8E6CF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
