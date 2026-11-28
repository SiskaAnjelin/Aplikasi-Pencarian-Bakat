import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahBakatPage extends StatefulWidget {
  const TambahBakatPage({super.key});

  @override
  State<TambahBakatPage> createState() => _TambahBakatPageState();
}

class _TambahBakatPageState extends State<TambahBakatPage> {
  static const Color purple = Color(0xFF6C5CFF);
  static const Color darkPurple = Color(0xFF29264F);

  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaSiswaController =
      TextEditingController();

  final TextEditingController _kelasController =
      TextEditingController();

  final TextEditingController _namaBakatController =
      TextEditingController();

  final TextEditingController _deskripsiController =
      TextEditingController();

  String? _selectedKategori;
  bool _isSaving = false;

  final List<String> _kategoriList = [
    'Seni',
    'Olahraga',
    'Musik',
    'Akademik',
    'Teknologi',
    'Bahasa',
    'Multimedia',
    'Coding',
  ];

  @override
  void dispose() {
    _namaSiswaController.dispose();
    _kelasController.dispose();
    _namaBakatController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // SIMPAN DATA BAKAT
  Future<void> _simpanBakat() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kategori bakat!'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Silakan login terlebih dahulu.');
      }

      // MENGAMBIL ID SISWA
      final siswa = await supabase
          .from('siswa')
          .select('id_siswa')
          .eq('user_id', user.id)
          .maybeSingle();

      if (siswa == null) {
        throw Exception('Data siswa tidak ditemukan.');
      }

      // MENAMBAHKAN DATA BAKAT
      final bakat = await supabase
          .from('bakat')
          .insert({
            'nama_bakat': _namaBakatController.text.trim(),
            'kategori': _selectedKategori,
            'deskripsi': _deskripsiController.text.trim(),
          })
          .select('id_bakat')
          .single();

      // MENYIMPAN PENGAJUAN SISWA
      await supabase.from('pengajuan_bakat').insert({
        'id_siswa': siswa['id_siswa'],
        'id_bakat': bakat['id_bakat'],
        'status': 'pending',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan bakat berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan bakat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // INPUT FORM
  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Color(0xFF77718F),
                width: 0.8,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: purple,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Bagian ini wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Padding menyesuaikan lebar layar
              final horizontalPadding =
                  constraints.maxWidth > 600 ? 40.0 : 24.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    // Membatasi lebar form pada layar besar,
                    // tetapi tetap fleksibel pada layar kecil.
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Tambah Bakat (Form)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // NAMA SISWA
                        _buildInput(
                          label: 'Nama Siswa',
                          hint: 'Masukkan nama siswa',
                          controller: _namaSiswaController,
                        ),

                        const SizedBox(height: 18),

                        // KELAS
                        _buildInput(
                          label: 'Kelas',
                          hint: 'Masukkan kelas',
                          controller: _kelasController,
                        ),

                        const SizedBox(height: 18),

                        // NAMA BAKAT
                        _buildInput(
                          label: 'Nama Bakat',
                          hint: 'Masukkan nama bakat',
                          controller: _namaBakatController,
                        ),

                        const SizedBox(height: 18),

                        // KATEGORI
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                          value: _selectedKategori,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pilih kategori',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: purple,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF77718F),
                                width: 0.9,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: purple,
                                width: 1.2,
                              ),
                            ),
                          ),
                          items: _kategoriList.map((kategori) {
                            return DropdownMenuItem<String>(
                              value: kategori,
                              child: Text(
                                kategori,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedKategori = value;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // DESKRIPSI
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _deskripsiController,
                          maxLines: 4,
                          minLines: 2,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Ceritakan sedikit tentang bakatmu',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF77718F),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF77718F),
                                width: 0.8,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: purple,
                                width: 1.2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Deskripsi wajib diisi';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        // TOMBOL SIMPAN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isSaving ? null : _simpanBakat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  purple.withOpacity(0.6),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}