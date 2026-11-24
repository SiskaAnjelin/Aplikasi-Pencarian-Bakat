import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahSiswaPage extends StatefulWidget {
  final Map<String, dynamic>? siswaData; // Jika ada -> Edit Mode, jika null -> Tambah Mode

  const TambahSiswaPage({super.key, this.siswaData});

  @override
  State<TambahSiswaPage> createState() => _TambahSiswaPageState();
}

class _TambahSiswaPageState extends State<TambahSiswaPage> {
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  String _selectedKelas = 'X RPL B';
  String _selectedJurusan = 'RPL';
  bool _tampilAcara = true;
  bool _isSaving = false;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.siswaData != null) {
      _namaController.text = widget.siswaData!['nama_siswa'] ?? widget.siswaData!['nama'] ?? '';
      _noHpController.text = widget.siswaData!['no_hp'] ?? widget.siswaData!['noHp'] ?? '';
      _selectedKelas = widget.siswaData!['kelas'] ?? 'X RPL B';
      _selectedJurusan = widget.siswaData!['jurusan'] ?? 'RPL';
      _tampilAcara = widget.siswaData!['tampil'] ?? true;
    }
  }

  Future<void> _saveToSupabase() async {
    final nama = _namaController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama siswa wajib diisi!')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final payload = {
        'nama_siswa': nama,
        'kelas': _selectedKelas,
        'jurusan': _selectedJurusan,
        'no_hp': _noHpController.text.trim(),
        'tampil': _tampilAcara,
      };

      if (widget.siswaData != null) {
        // UPDATE
        final idSiswa = widget.siswaData!['id_siswa'] ?? widget.siswaData!['id'];
        await supabase.from('siswa').update(payload).eq('id_siswa', idSiswa);
      } else {
        // INSERT
        await supabase.from('siswa').insert(payload);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.siswaData != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Siswa' : 'Tambah Data Siswa', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Siswa *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: _inputDecoration('Contoh: Alya Nasmi'),
            ),
            const SizedBox(height: 16),

            const Text('Nomor HP / WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _noHpController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('Contoh: 08123456789'),
            ),
            const SizedBox(height: 16),

            const Text('Kelas *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            _dropdown(['X RPL A', 'X RPL B', 'XI RPL A', 'XI RPL B', 'XII RPL', 'X DKV A', 'XI DKV B'], _selectedKelas, (v) => setState(() => _selectedKelas = v!)),
            const SizedBox(height: 16),

            const Text('Jurusan *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            _dropdown(['RPL', 'DKV', 'AKL', 'TJKT'], _selectedJurusan, (v) => setState(() => _selectedJurusan = v!)),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tampilkan di Acara', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Switch(
                  value: _tampilAcara,
                  activeColor: const Color(0xFF6C5CE7),
                  onChanged: (v) => setState(() => _tampilAcara = v),
                ),
              ],
            ),
            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveToSupabase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }

  Widget _dropdown(List<String> items, String currentVal, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(currentVal) ? currentVal : items.first,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}