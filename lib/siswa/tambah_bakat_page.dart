import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahBakatPage extends StatefulWidget {
  const TambahBakatPage({super.key});

  @override
  State<TambahBakatPage> createState() => _TambahBakatPageState();
}

class _TambahBakatPageState extends State<TambahBakatPage> {
  final supabase = Supabase.instance.client;

  String? _selectedBakatId;

  List<Map<String, dynamic>> _daftarBakat = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ambilDataBakat();
  }

  // Mengambil daftar bakat dari Supabase
  Future<void> _ambilDataBakat() async {
    try {
      final data = await supabase
          .from('bakat')
          .select('id_bakat, nama_bakat, deskripsi')
          .order('nama_bakat');

      if (!mounted) return;

      setState(() {
        _daftarBakat = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data bakat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Deskripsi bakat yang dipilih
  String get _deskripsiBakat {
    final bakat = _daftarBakat.firstWhere(
      (item) => item['id_bakat'].toString() == _selectedBakatId,
      orElse: () => {},
    );

    return bakat['deskripsi']?.toString() ?? '';
  }

  // Menyimpan pengajuan ke Supabase
  Future<void> _simpanBakat() async {
    if (_selectedBakatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih bakat terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Memeriksa akun yang sedang login
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('Silakan login terlebih dahulu.');
      }

      // Mengambil ID siswa berdasarkan user_id
      final siswa = await supabase
          .from('siswa')
          .select('id_siswa, nama_siswa')
          .eq('user_id', user.id)
          .maybeSingle();

      if (siswa == null) {
        throw Exception(
          'Data siswa tidak ditemukan. Hubungi admin.',
        );
      }

      // Menyimpan pengajuan bakat
      await supabase.from('pengajuan_bakat').insert({
        'id_siswa': siswa['id_siswa'],
        'id_bakat': _selectedBakatId,
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
          content: Text('Gagal mengirim pengajuan: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambah Bakat',
          style: TextStyle(
            color: Color(0xFF202044),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C5CFF),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Bakat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedBakatId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: 'Pilih bakat yang kamu minati',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF6C5CFF),
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: _daftarBakat.map((bakat) {
                      return DropdownMenuItem<String>(
                        value: bakat['id_bakat'].toString(),
                        child: Text(
                          bakat['nama_bakat'].toString(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBakatId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Text(
                      _selectedBakatId == null
                          ? 'Deskripsi bakat akan muncul di sini.'
                          : _deskripsiBakat,
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedBakatId == null
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isSaving || _daftarBakat.isEmpty
                          ? null
                          : _simpanBakat,
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
