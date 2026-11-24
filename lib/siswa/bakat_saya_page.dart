import 'package:flutter/material.dart';

class BakatSayaPage extends StatefulWidget {
  const BakatSayaPage({super.key});

  @override
  State<BakatSayaPage> createState() => _BakatSayaPageState();
}

class _BakatSayaPageState extends State<BakatSayaPage> {
  int _selectedTab = 0;

  static const Color purple = Color(0xFF6C63FF);
  static const Color dark = Color(0xFF1A1A2E);
  static const Color background = Color(0xFFF8F9FC);

  // daftar bakat sementara
  final List<Map<String, dynamic>> _bakatList = [
    {
      "nama": "Coding",
      "kategori": "Akademik",
      "gambar": "coding.jpg",
      "status": "Dalam Proses",
    },
    {
      "nama": "Dance",
      "kategori": "Seni",
      "gambar": "dance.jpeg",
      "status": "Menunggu",
    },
    {
      "nama": "Fotografi",
      "kategori": "Seni",
      "gambar": "fotografi.jpg",
      "status": "Dalam Proses",
    },
    {
      "nama": "Matematika",
      "kategori": "Akademik",
      "gambar": "matematika.jpg",
      "status": "Menunggu",
    },
    {
      "nama": "Menari",
      "kategori": "Seni",
      "gambar": "menari.jpeg",
      "status": "Disetujui",
    },
    {
      "nama": "Menggambar",
      "kategori": "Seni",
      "gambar": "menggambar.jpg",
      "status": "Menunggu",
    },
    {
      "nama": "Menyanyi",
      "kategori": "Seni",
      "gambar": "menyanyi.jpg",
      "status": "Disetujui",
    },
    {
      "nama": "Sains",
      "kategori": "Akademik",
      "gambar": "sains.jpeg",
      "status": "Menunggu",
    },
    {
      "nama": "Teater",
      "kategori": "Seni",
      "gambar": "teater.jpeg",
      "status": "Disetujui",
    },
  ];

  // filter berdasarkan kategori
  List<Map<String, dynamic>> get _filteredBakat {
    if (_selectedTab == 0) {
      return _bakatList;
    }

    final kategori = _selectedTab == 1 ? "Seni" : "Akademik";

    return _bakatList
        .where((bakat) => bakat["kategori"] == kategori)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedBakat = _filteredBakat;

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
              color: background,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Scaffold(
              backgroundColor: background,

              // header halaman
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: dark,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "Bakat Saya",
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                centerTitle: false,
              ),

              // body halaman
              body: Column(
                children: [
                  // tab filter kategori
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
                    child: Row(
                      children: [
                        _buildTab("Semua", 0),
                        const SizedBox(width: 8),
                        _buildTab("Seni", 1),
                        const SizedBox(width: 8),
                        _buildTab("Akademik", 2),
                      ],
                    ),
                  ),

                  // jumlah bakat
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${displayedBakat.length} Bakat Ditemukan",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  // daftar bakat
                  Expanded(
                    child: displayedBakat.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada bakat pada kategori ini",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            itemCount: displayedBakat.length,
                            itemBuilder: (context, index) {
                              return _buildBakatItem(
                                displayedBakat[index],
                              );
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

  // tombol filter kategori
  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? purple : const Color(0xFFEDEBFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : dark,
            ),
          ),
        ),
      ),
    );
  }

  // item daftar bakat
  Widget _buildBakatItem(Map<String, dynamic> bakat) {
    final String status = bakat["status"]?.toString() ?? "Menunggu";

    Color warnaStatus;
    Color backgroundStatus;

    // warna berdasarkan status
    switch (status) {
      case "Disetujui":
        warnaStatus = const Color(0xFF239B62);
        backgroundStatus = const Color(0xFFE5F7EC);
        break;

      case "Dalam Proses":
        warnaStatus = const Color(0xFF5651C9);
        backgroundStatus = const Color(0xFFEAE9FF);
        break;

      case "Menunggu":
        warnaStatus = const Color(0xFFEF982B);
        backgroundStatus = const Color(0xFFFFF2DF);
        break;

      default:
        warnaStatus = Colors.grey;
        backgroundStatus = Colors.grey.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // gambar bakat
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              "assets/images/${bakat["gambar"]}",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFEDEBFF),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 22,
                    color: purple,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          // nama dan kategori bakat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bakat["nama"]?.toString() ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  bakat["kategori"]?.toString() ?? "-",
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          // status pengajuan
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: backgroundStatus,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: warnaStatus,
              ),
            ),
          ),

          const SizedBox(width: 3),

          const Icon(
            Icons.chevron_right,
            size: 16,
            color: dark,
          ),
        ],
      ),
    );
  }
}
