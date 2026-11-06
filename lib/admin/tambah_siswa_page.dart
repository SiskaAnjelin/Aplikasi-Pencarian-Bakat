import 'package:flutter/material.dart';

class TambahSiswaPage extends StatefulWidget {
  final Map<String, String>? siswa;

  const TambahSiswaPage({super.key, this.siswa});

  @override
  State<TambahSiswaPage> createState() => _TambahSiswaPageState();
}

class _TambahSiswaPageState extends State<TambahSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _kelasController;
  String? _selectedJurusan;

  final List<String> _jurusanList = ['IPA', 'IPS', 'Bahasa'];

  bool get isEdit => widget.siswa != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.siswa?['name'] ?? '');
    _kelasController = TextEditingController(text: widget.siswa?['kelas'] ?? '');
    _selectedJurusan = widget.siswa?['jurusan'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedJurusan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jurusan'), backgroundColor: Color(0xFFD63031)),
      );
      return;
    }

    final data = {
      'id': widget.siswa?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'kelas': _kelasController.text.trim(),
      'jurusan': _selectedJurusan!,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
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
            Text(
              isEdit ? 'Data Berhasil Diubah!' : 'Siswa Berhasil Ditambahkan!',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, data);
              },
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
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Siswa' : 'Tambah Data Siswa'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama Siswa *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D3436)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 1.5),
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Kelas *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D3436)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _kelasController,
                decoration: InputDecoration(
                  hintText: 'Contoh: XI IPA 1',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 1.5),
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Kelas wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Jurusan *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D3436)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedJurusan,
                    isExpanded: true,
                    hint: const Text('Pilih jurusan', style: TextStyle(color: Color(0xFFB2BEC3))),
                    items: _jurusanList
                        .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedJurusan = v),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Simpan Perubahan' : 'Tambah',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}