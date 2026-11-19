
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

  // 8 KATEGORI BAKAT
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
        SizedBox(
          height: 38,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 9,
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            height: 680,
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      30, 12, 30, 20,
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
                                size: 19,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Tambah Bakat (Form)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: darkPurple,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

                        // NAMA SISWA
                        _buildInput(
                          label: 'Nama Siswa',
                          hint: 'Masukkan nama siswa',
                          controller: _namaSiswaController,
                        ),

                        const SizedBox(height: 5),

                        // KELAS
                        _buildInput(
                          label: 'Kelas',
                          hint: 'Masukkan kelas',
                          controller: _kelasController,
                        ),

                        const SizedBox(height: 5),

                        // NAMA BAKAT
                        _buildInput(
                          label: 'Nama Bakat',
                          hint: 'Masukkan nama bakat',
                          controller: _namaBakatController,
                        ),

                        const SizedBox(height: 5),

                        // KATEGORI
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 6),

                        SizedBox(
                          height: 40,
                          child: DropdownButtonFormField<String>(
                            value: _selectedKategori,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Pilih kategori',
                              hintStyle: const TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: purple,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Color(0xFF77718F),
                                  width: 0.9,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
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
                                    fontSize: 11,
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
                        ),

                        const SizedBox(height: 8),

                        // DESKRIPSI MANUAL
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 6),

                        TextFormField(
                          controller: _deskripsiController,
                          maxLines: 3,
                          minLines: 2,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Ceritakan sedikit tentang bakatmu',
                            hintStyle: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                            contentPadding: const EdgeInsets.all(13),
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

                        const SizedBox(height: 24),

                        // TOMBOL SIMPAN
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton(
                            onPressed:
                                _isSaving ? null : _simpanBakat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  purple.withOpacity(0.6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
