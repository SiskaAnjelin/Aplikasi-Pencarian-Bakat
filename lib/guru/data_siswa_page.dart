
import 'package:flutter/material.dart';
import 'detail_bakat_page.dart';

class DataSiswaPage extends StatefulWidget {
  const DataSiswaPage({super.key});

  @override
  State<DataSiswaPage> createState() => _DataSiswaPageState();
}

class _DataSiswaPageState extends State<DataSiswaPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  final List<Map<String, String>> _siswaList = [
    {
      "nama": "Alya Nasmi Rahma Putri",
      "kelas": "XI RPL 1",
      "bakat": "Menari",
    },
    {
      "nama": "Siska Anjelin",
      "kelas": "XII RPL B",
      "bakat": "Desain Grafis",
    },
    {
      "nama": "Noufal Zaidan Althaat Syaifudin",
      "kelas": "XI TKJ 1",
      "bakat": "Coding",
    },
    {
      "nama": "Nadya Ulya Putriniar",
      "kelas": "XII TKJ 1",
      "bakat": "Menggambar",
    },
    {
      "nama": "Gabriel Joshua Andika Putra",
      "kelas": "XI RPL 2",
      "bakat": "Bermain Musik",
    },
    {
      "nama": "Adhon Panca Wardoyo Utomo",
      "kelas": "XII TKJ 2",
      "bakat": "Olahraga",
    },
    {
      "nama": "Feriska Agustina Fitria",
      "kelas": "XI TKJ 2",
      "bakat": "Menyanyi",
    },
    {
      "nama": "Syeilfi Aprilliani",
      "kelas": "XII RPL 1",
      "bakat": "Menulis",
    },
  ];

  // Filter dan urutkan siswa berdasarkan abjad
  List<Map<String, String>> get _filteredSiswa {
    List<Map<String, String>> hasil = _siswaList.where((siswa) {
      final nama = siswa["nama"]!.toLowerCase();
      final kelas = siswa["kelas"]!.toLowerCase();
      final bakat = siswa["bakat"]!.toLowerCase();

      return nama.contains(_searchQuery) ||
          kelas.contains(_searchQuery) ||
          bakat.contains(_searchQuery);
    }).toList();

    hasil.sort(
      (a, b) => a["nama"]!
          .toLowerCase()
          .compareTo(b["nama"]!.toLowerCase()),
    );

    return hasil;
  }

  // Membuka halaman detail bakat sesuai siswa yang dipilih
  void _bukaDetailSiswa(Map<String, String> siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBakatGuruPage(
          siswaName: siswa["nama"]!,
          kelas: siswa["kelas"]!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FC),

              // APP BAR
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Color(0xFF1A1A2E),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "Data Siswa",
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),

              // BODY
              body: Column(
                children: [
                  // SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      16,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery =
                                value.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText:
                              "Cari nama, kelas, atau bakat...",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // JUMLAH SISWA
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${_filteredSiswa.length} siswa ditemukan",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LIST SISWA
                  Expanded(
                    child: _filteredSiswa.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 55,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Siswa tidak ditemukan",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Coba gunakan kata kunci lain",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            itemCount: _filteredSiswa.length,
                            itemBuilder: (context, index) {
                              final siswa =
                                  _filteredSiswa[index];

                              return _buildSiswaCard(siswa);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // CARD SISWA
  Widget _buildSiswaCard(Map<String, String> siswa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _bukaDetailSiswa(siswa);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // AVATAR
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE8E7FF),
                  child: Text(
                    siswa["nama"]![0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // NAMA DAN KELAS
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        siswa["nama"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        siswa["kelas"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // LABEL BAKAT
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      siswa["bakat"]!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
