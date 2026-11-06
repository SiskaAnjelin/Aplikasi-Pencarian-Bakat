import 'package:flutter/material.dart';

class PenilaianBakatPage extends StatefulWidget {
  final String? siswaName;
  final String? bakatName;

  const PenilaianBakatPage({super.key, this.siswaName, this.bakatName});

  @override
  State<PenilaianBakatPage> createState() => _PenilaianBakatPageState();
}

class _PenilaianBakatPageState extends State<PenilaianBakatPage> {
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
                  ),
                ),
              ],
            ),
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
          ),
        ],
      ),
    );
  }
}