import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahSiswaPage extends StatefulWidget {
  final Map<String, dynamic>? siswaData;

  const TambahSiswaPage({
    super.key,
    this.siswaData,
  });

  @override
  State<TambahSiswaPage> createState() => _TambahSiswaPageState();
}

class _TambahSiswaPageState extends State<TambahSiswaPage> {
  // Warna utama aplikasi
  static const Color purple = Color(0xFF6C5CE7);
  static const Color background = Color(0xFFF8F9FE);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color green = Color(0xFF75C9A5);
  static const Color red = Color(0xFFF28B91);

  // Koneksi Supabase
  final supabase = Supabase.instance.client;

  // Controller input
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();

  // Data pilihan awal
  String _selectedKelas = 'X RPL A';
  String _selectedJurusan = 'RPL';

  bool _statusAktif = true;
  bool _isSaving = false;

  // Daftar jurusan
  final List<String> _jurusan = [
    'RPL',
    'TKJ',
    'ELIN',
    'METRO',
  ];

  // Daftar tingkat kelas
  final List<String> _tingkat = [
    'X',
    'XI',
    'XII',
  ];

  // Jumlah rombel berdasarkan jurusan
  List<String> get _rombel {
    if (_selectedJurusan == 'RPL' ||
        _selectedJurusan == 'TKJ') {
      return ['A', 'B', 'C', 'D'];
    }

    return ['A', 'B'];
  }

  // Membuat daftar kelas secara otomatis
  List<String> get _kelas {
    final List<String> hasil = [];

    for (final tingkat in _tingkat) {
      for (final rombel in _rombel) {
        hasil.add('$tingkat $_selectedJurusan $rombel');
      }
    }

    return hasil;
  }

  // Mengecek apakah halaman sedang dalam mode edit
  bool get isEdit => widget.siswaData != null;

  @override
  void initState() {
    super.initState();

    // Mengisi form jika sedang mengedit data
    if (isEdit) {
      final data = widget.siswaData!;

      _namaController.text =
          (data['nama_siswa'] ?? data['nama'] ?? '').toString();

      _noHpController.text =
          (data['no_hp'] ?? data['noHp'] ?? '').toString();

      _selectedJurusan =
          (data['jurusan'] ?? 'RPL').toString().toUpperCase();

      if (!_jurusan.contains(_selectedJurusan)) {
        _selectedJurusan = 'RPL';
      }

      _selectedKelas = _normalisasiKelas(
        (data['kelas'] ?? 'X RPL A').toString(),
      );

      _statusAktif = data['status_aktif'] == false ? false : true;
    }
  }

  // Menyesuaikan format kelas lama dan baru
  String _normalisasiKelas(String kelas) {
    final value = kelas.trim().toUpperCase();

    if (_kelas.contains(value)) {
      return value;
    }

    for (final tingkat in _tingkat) {
      if (value.startsWith(tingkat)) {
        final huruf = RegExp(r'[A-D]').allMatches(value).toList();

        final rombel = huruf.isNotEmpty
            ? huruf.last.group(0)!
            : 'A';

        final hasil = '$tingkat $_selectedJurusan $rombel';

        if (_kelas.contains(hasil)) {
          return hasil;
        }
      }
    }

    return 'X $_selectedJurusan A';
  }

  // Menampilkan pesan informasi
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  // Menyimpan atau memperbarui data siswa ke Supabase
  Future<void> _saveToSupabase() async {
    final nama = _namaController.text.trim();

    // Validasi nama siswa
    if (nama.isEmpty) {
      _showMessage('Nama siswa wajib diisi!', red);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Data yang akan dikirim ke Supabase
      final payload = {
        'nama_siswa': nama,
        'kelas': _selectedKelas,
        'jurusan': _selectedJurusan,
        'no_hp': _noHpController.text.trim(),
        'status_aktif': _statusAktif,
      };

      if (isEdit) {
        final data = widget.siswaData!;

        // Update berdasarkan ID siswa
        if (data['id_siswa'] != null) {
          await supabase
              .from('siswa')
              .update(payload)
              .eq('id_siswa', data['id_siswa']);
        } else if (data['id'] != null) {
          await supabase
              .from('siswa')
              .update(payload)
              .eq('id', data['id']);
        } else {
          throw Exception('ID siswa tidak ditemukan.');
        }
      } else {
        // Menambahkan data siswa baru
        await supabase
            .from('siswa')
            .insert(payload);
      }

      if (!mounted) return;

      _showMessage(
        isEdit
            ? 'Data siswa berhasil diperbarui!'
            : 'Data siswa berhasil ditambahkan!',
        green,
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showMessage('Gagal menyimpan data: $e', red);

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
        horizontal: 14,
        vertical: 14,
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
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: darkPurple,
        ),
      ),
    );
  }

  // Widget dropdown
  Widget _dropdown(
    List<String> items,
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(currentValue)
              ? currentValue
              : items.first,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: purple,
          ),
          style: const TextStyle(
            fontSize: 13,
            color: darkPurple,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Widget status siswa
  Widget _statusSiswa() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // Ikon status
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _statusAktif
                  ? green.withOpacity(0.15)
                  : red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: _statusAktif ? green : red,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          // Informasi status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Siswa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _statusAktif ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(
                    fontSize: 11,
                    color: _statusAktif ? green : red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Switch status
          Switch(
            value: _statusAktif,
            activeColor: purple,
            onChanged: (value) {
              setState(() {
                _statusAktif = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Membersihkan controller ketika halaman ditutup
  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
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
                    size: 19,
                  ),
                ),
                title: Text(
                  isEdit ? 'Edit Data Siswa' : 'Tambah Data Siswa',
                  style: const TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Isi halaman yang responsif dan dapat di-scroll
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Membatasi lebar konten pada layar besar
                  final double contentWidth =
                      constraints.maxWidth > 700
                          ? 650
                          : constraints.maxWidth;

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
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
                              padding: const EdgeInsets.all(14),
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
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isEdit
                                          ? 'Perbarui informasi data siswa.'
                                          : 'Lengkapi informasi siswa baru.',
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

                            const SizedBox(height: 20),

                            // Input nama siswa
                            _label('Nama Siswa *'),
                            TextField(
                              controller: _namaController,
                              textCapitalization:
                                  TextCapitalization.words,
                              style: const TextStyle(fontSize: 14),
                              decoration: _inputDecoration(
                                'Contoh: Alya Nasmi',
                              ),
                            ),

                            const SizedBox(height: 17),

                            // Input nomor HP
                            _label('Nomor HP / WhatsApp'),
                            TextField(
                              controller: _noHpController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 14),
                              decoration: _inputDecoration(
                                'Contoh: 08123456789',
                              ),
                            ),

                            const SizedBox(height: 17),

                            // Dropdown jurusan
                            _label('Jurusan *'),
                            _dropdown(
                              _jurusan,
                              _selectedJurusan,
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedJurusan = value;

                                    // Menyesuaikan kelas saat jurusan berubah
                                    final bagianKelas =
                                        _selectedKelas.split(' ');

                                    final tingkat =
                                        bagianKelas.isNotEmpty
                                            ? bagianKelas.first
                                            : 'X';

                                    _selectedKelas =
                                        '$tingkat $_selectedJurusan A';
                                  });
                                }
                              },
                            ),

                            const SizedBox(height: 17),

                            // Dropdown kelas
                            _label('Kelas *'),
                            _dropdown(
                              _kelas,
                              _selectedKelas,
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedKelas = value;
                                  });
                                }
                              },
                            ),

                            const SizedBox(height: 22),

                            // Pengaturan status siswa
                            _statusSiswa(),

                            const SizedBox(height: 28),

                            // Tombol simpan
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isSaving
                                    ? null
                                    : _saveToSupabase,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: purple,
                                  disabledBackgroundColor:
                                      purple.withOpacity(0.6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
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
                                                : 'Simpan Data Siswa',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 18),
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