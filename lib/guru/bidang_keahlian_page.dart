
import 'package:flutter/material.dart';

class BidangKeahlianPage extends StatefulWidget {
  const BidangKeahlianPage({super.key});

  @override
  State<BidangKeahlianPage> createState() =>
      _BidangKeahlianPageState();
}

class _BidangKeahlianPageState extends State<BidangKeahlianPage> {
  final Color ungu = const Color(0xFF6C5CFF);
  final Color darkPurple = const Color(0xFF29264F);

  final List<Map<String, dynamic>> bidang = [
    {
      'nama': 'Desain',
      'icon': Icons.palette_outlined,
      'warna': Color(0xFFEDE9FF),
    },
    {
      'nama': 'Teater',
      'icon': Icons.theater_comedy_outlined,
      'warna': Color(0xFFFFE9E7),
    },
    {
      'nama': 'Seni Rupa',
      'icon': Icons.brush_outlined,
      'warna': Color(0xFFFFF1D6),
    },
    {
      'nama': 'Olahraga',
      'icon': Icons.sports_basketball_outlined,
      'warna': Color(0xFFE1F3FF),
    },
    {
      'nama': 'Teknologi',
      'icon': Icons.computer_outlined,
      'warna': Color(0xFFE4F5E9),
    },
    {
      'nama': 'Robotic',
      'icon': Icons.smart_toy_outlined,
      'warna': Color(0xFFFCE4F1),
    },
  ];

  final Set<String> terpilih = {'Desain', 'Teater'};

  void simpanBidang() {
    if (terpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu bidang keahlian!'),
        ),
      );
      return;
    }

    Navigator.pop(context, terpilih.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bidang Keahlian',
          style: TextStyle(
            color: darkPurple,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: darkPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.workspace_premium_outlined,
                            color: Color(0xFFFFC857),
                            size: 35,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Kenali Keahlianmu!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pilih bidang keahlian yang sesuai dengan kemampuan dan minatmu.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      'Pilih Bidang Keahlian',
                      style: TextStyle(
                        color: darkPurple,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Kamu bisa memilih lebih dari satu bidang.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 18),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bidang.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (context, index) {
                        final item = bidang[index];
                        final nama = item['nama'] as String;
                        final dipilih = terpilih.contains(nama);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              setState(() {
                                if (dipilih) {
                                  terpilih.remove(nama);
                                } else {
                                  terpilih.add(nama);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: dipilih
                                      ? ungu
                                      : Colors.grey.shade200,
                                  width: dipilih ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: item['warna'],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          item['icon'],
                                          color: darkPurple,
                                          size: 25,
                                        ),
                                      ),
                                      if (dipilih)
                                        Icon(
                                          Icons.check_circle,
                                          color: ungu,
                                          size: 21,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    nama,
                                    style: TextStyle(
                                      color: darkPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    Text(
                      '${terpilih.length} bidang dipilih',
                      style: TextStyle(
                        color: ungu,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: simpanBidang,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ungu,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Bidang Keahlian',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
