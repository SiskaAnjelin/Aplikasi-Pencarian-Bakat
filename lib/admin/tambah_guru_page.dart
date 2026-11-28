import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahGuruPage extends StatefulWidget {
  final Map<String, dynamic>? guruData;

  const TambahGuruPage({
    super.key,
    this.guruData,
  });

  @override
  State<TambahGuruPage> createState() => _TambahGuruPageState();
}

class _TambahGuruPageState extends State<TambahGuruPage> {
  // Warna utama aplikasi
  static const Color purple = Color(0xFF6C5CE7);
  static const Color background = Color(0xFFF8F9FE);
  static const Color darkPurple = Color(0xFF29264F);

  // Controller untuk input
  final _namaController = TextEditingController();
  final _nipController = TextEditingController();

  // Koneksi Supabase
  final supabase = Supabase.instance.client;

  // Data pilihan bidang guru
  String _selectedBidang = 'Guru Seni';

  bool _isSaving = false;

  final List<String> _bidangList = [
    'Guru Seni',
    'Guru RPL',
    'Guru Musik/Vokal',
    'Guru Teater/Drama',
    'Guru Bahasa Indonesia',
  ];

  // Mengecek mode tambah atau edit
  bool get isEdit => widget.guruData != null;

  @override
  void initState() {
    super.initState();

    // Mengisi data ketika halaman digunakan untuk edit
    if (isEdit) {
      final data = widget.guruData!;

      _namaController.text =
          (data['nama_guru'] ?? data['nama'] ?? '').toString();

      _nipController.text =
          (data['nip'] ?? '').toString();

      final bidang = (data['bidang'] ?? 'Guru Seni').toString();

      if (_bidangList.contains(bidang)) {
        _selectedBidang = bidang;
      }
    }
  }

  // Menampilkan pesan kepada pengguna
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  // Menyimpan atau memperbarui data guru ke Supabase
  Future<void> _saveGuru() async {
    final nama = _namaController.text.trim();

    // Validasi nama guru
    if (nama.isEmpty) {
      _showMessage('Nama guru wajib diisi!', Colors.red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Data guru yang akan disimpan
      final dataGuru = {
        'nama_guru': nama,
        'nip': _nipController.text.trim().isEmpty
            ? '-'
            : _nipController.text.trim(),
        'bidang': _selectedBidang,
      };

      if (isEdit) {
        // Mengambil ID guru untuk proses update
        final id = widget.guruData!['id'];

        if (id == null) {
          throw Exception('ID guru tidak ditemukan.');
        }

        // Memperbarui data guru
        await supabase
            .from('guru')
            .update(dataGuru)
            .eq('id', id);
      } else {
        // Menambahkan data guru baru
        await supabase
            .from('guru')
            .insert(dataGuru);
      }

      if (!mounted) return;

      // Pesan berhasil
      _showMessage(
        isEdit
            ? 'Data guru berhasil diperbarui!'
            : 'Guru berhasil ditambahkan!',
        Colors.green,
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      // Pesan jika terjadi kesalahan
      _showMessage(
        'Gagal menyimpan data guru: $e',
        Colors.red,
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  // Dekorasi input teks
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: purple,
          width: 1.5,
        ),
      ),
    );
  }

  // Widget label input
  Widget _label(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: darkPurple,
        ),
      ),
    );
  }

  // Widget dropdown bidang guru
  Widget _dropdownBidang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBidang,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: purple,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: darkPurple,
          ),
          items: _bidangList.map((bidang) {
            return DropdownMenuItem<String>(
              value: bidang,
              child: Text(bidang),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedBidang = value;
              });
            }
          },
        ),
      ),
    );
  }

  // Membersihkan controller
  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    super.dispose();
  }

  // Tampilan utama halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // Area aman layar
      body: SafeArea(
        child: Column(
          children: [
            // AppBar halaman
            Container(
              width: double.infinity,
              color: Colors.white,
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: darkPurple,
                    size: 20,
                  ),
                ),
                title: Text(
                  isEdit ? 'Edit Guru Juri' : 'Tambah Guru Juri',
                  style: const TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Konten halaman responsif
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Mengatur lebar maksimal konten
                  final double contentWidth =
                      constraints.maxWidth > 700
                          ? 600
                          : constraints.maxWidth;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 22,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Informasi halaman
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school_rounded,
                                    color: purple,
                                    size: 27,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      isEdit
                                          ? 'Perbarui informasi data guru.'
                                          : 'Lengkapi informasi guru baru.',
                                      style: const TextStyle(
                                        color: darkPurple,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Input nama guru
                            _label('Nama Guru *'),
                            TextField(
                              controller: _namaController,
                              textCapitalization:
                                  TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              decoration: _inputDecoration(
                                'Contoh: Pak Saiful, S.Pd',
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Input NIP atau NUPTK
                            _label('NIP / NUPTK'),
                            TextField(
                              controller: _nipController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14),
                              decoration: _inputDecoration(
                                'Contoh: 198203112005011002',
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Pilihan bidang guru
                            _label('Bidang *'),
                            _dropdownBidang(),

                            const SizedBox(height: 32),

                            // Tombol simpan data
                            SizedBox(
                              width: double.infinity,
                              height: 49,
                              child: ElevatedButton(
                                onPressed:
                                    _isSaving ? null : _saveGuru,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: purple,
                                  disabledBackgroundColor:
                                      purple.withOpacity(0.6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 21,
                                        height: 21,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isEdit
                                                ? Icons.save_rounded
                                                : Icons.person_add_alt_1_rounded,
                                            size: 19,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            isEdit
                                                ? 'Simpan Perubahan'
                                                : 'Simpan',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}