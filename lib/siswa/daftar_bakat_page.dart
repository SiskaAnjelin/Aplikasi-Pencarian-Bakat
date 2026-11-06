import 'package:flutter/material.dart';

class DaftarBakatPage extends StatefulWidget {
  const DaftarBakatPage({super.key});

  @override
  State<DaftarBakatPage> createState() => _DaftarBakatPageState();
}

class TalentItem {
  final String title;
  final String status;
  final String category;
  final IconData icon;
  final Color statusColor;

  TalentItem({
    required this.title,
    required this.status,
    required this.category,
    required this.icon,
    required this.statusColor,
  });
}

class _DaftarBakatPageState extends State<DaftarBakatPage> {
  int _selectedCategoryIndex = 0;

  final List<String> categories = [
    'Semua',
    'Seni',
    'Akademik',
  ];

  // Data sementara daftar bakat
  final List<TalentItem> talents = [
    TalentItem(
      title: 'Menggambar',
      status: 'Berkembang',
      category: 'Seni',
      icon: Icons.draw_outlined,
      statusColor: Colors.orange,
    ),
    TalentItem(
      title: 'Menyanyi',
      status: 'Potensial',
      category: 'Seni',
      icon: Icons.music_note,
      statusColor: Colors.amber,
    ),
    TalentItem(
      title: 'Menari',
      status: 'Berkembang',
      category: 'Seni',
      icon: Icons.theater_comedy,
      statusColor: Colors.orange,
    ),
    TalentItem(
      title: 'Desain Grafis',
      status: 'Meningkat',
      category: 'Seni',
      icon: Icons.palette_outlined,
      statusColor: Colors.blue,
    ),
    TalentItem(
      title: 'Matematika',
      status: 'Meningkat',
      category: 'Akademik',
      icon: Icons.calculate_outlined,
      statusColor: Colors.blue,
    ),
    TalentItem(
      title: 'Coding',
      status: 'Potensial',
      category: 'Akademik',
      icon: Icons.code,
      statusColor: Colors.amber,
    ),
    TalentItem(
      title: 'Bahasa Inggris',
      status: 'Berkembang',
      category: 'Akademik',
      icon: Icons.language,
      statusColor: Colors.orange,
    ),
    TalentItem(
      title: 'Public Speaking',
      status: 'Meningkat',
      category: 'Akademik',
      icon: Icons.record_voice_over_outlined,
      statusColor: Colors.blue,
    ),
  ];

  List<TalentItem> get filteredTalents {
    if (_selectedCategoryIndex == 0) {
      return talents;
    }

    String selectedCategory = categories[_selectedCategoryIndex];

    return talents
        .where((talent) => talent.category == selectedCategory)
        .toList();
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
          'Bakat Saya',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter kategori
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected =
                      _selectedCategoryIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6C63FF),
                      backgroundColor: const Color(0xFFEFEFF9),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6C63FF),
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Judul daftar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Daftar Bakat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202044),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Daftar bakat
          Expanded(
            child: filteredTalents.isEmpty
                ? const Center(
                    child: Text('Belum ada data bakat'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: filteredTalents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final talent = filteredTalents[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail_bakat',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Ikon bakat
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFEFF9),
                                  borderRadius:
                                      BorderRadius.circular(13),
                                ),
                                child: Icon(
                                  talent.icon,
                                  color: const Color(0xFF6C63FF),
                                  size: 27,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Nama dan kategori
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      talent.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      talent.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: talent.statusColor
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        talent.status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: talent.statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                color: Colors.black45,
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

      // Navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/dashboard_siswa',
            );
          } else if (index == 2) {
            Navigator.pushNamed(
              context,
              '/detail_bakat',
            );
          } else if (index == 3) {
            Navigator.pushNamed(
              context,
              '/profil_siswa',
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Bakat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}