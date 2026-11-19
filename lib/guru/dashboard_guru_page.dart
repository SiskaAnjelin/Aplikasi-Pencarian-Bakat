
import 'package:flutter/material.dart';

class DashboardGuruPage extends StatelessWidget {
  const DashboardGuruPage({super.key});

  static const Color purple = Color(0xFF7062F5);
  static const Color darkPurple = Color(0xFF29264F);
  static const Color yellow = Color(0xFFFFC857);
  static const Color lightPurple = Color(0xFFB8A5FF);

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

              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        18, 22, 18, 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // HEADER
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dashboard Guru',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context, '/login',
                                  );
                                },
                                child: const Icon(
                                  Icons.logout,
                                  color: purple,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // SAPAAN
                          const Text(
                            'Selamat Datang,',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 3),

                          const Text(
                            'Pak Aris!',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Berikut ringkasan data siswa dan\n'
                            'perkembangan bakat.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // STATISTIK
                          Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  Icons.people_alt_outlined,
                                  '120',
                                  'Total Siswa',
                                  purple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statCard(
                                  Icons.star_outline,
                                  '20',
                                  'Bakat Aktif',
                                  yellow,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statCard(
                                  Icons.calendar_month_outlined,
                                  '8',
                                  'Kegiatan',
                                  lightPurple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          // POTENSI TERBARU
                          const Text(
                            'Potensi Terbaru',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _studentCard(
                            'A',
                            'Alya Nasmi',
                            'XI RPL 2',
                            'Public Speaking',
                            const Color(0xFFFFD9E6),
                          ),

                          const SizedBox(height: 10),

                          _studentCard(
                            'S',
                            'Siska Anjelin',
                            'XII RPL B',
                            'Fotografi',
                            const Color(0xFFE3DDFF),
                          ),

                          const SizedBox(height: 10),

                          _studentCard(
                            'N',
                            'Noufal',
                            'XI RPL 1',
                            'Desain Grafis',
                            const Color(0xFFFFE9C2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // BOTTOM NAVBAR
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        _navItem(
                          Icons.home_filled,
                          'Beranda',
                          true,
                          () {},
                        ),
                        _navItem(
                          Icons.people_alt_outlined,
                          'Data Siswa',
                          false,
                          () {
                            Navigator.pushNamed(
                              context, '/data_siswa',
                            );
                          },
                        ),
                        _navItem(
                          Icons.history,
                          'Riwayat',
                          false,
                          () {
                            Navigator.pushNamed(
                              context, '/riwayat',
                            );
                          },
                        ),
                        _navItem(
                          Icons.assignment_outlined,
                          'Penilaian',
                          false,
                          () {
                            Navigator.pushNamed(
                              context, '/penilaian_bakat',
                            );
                          },
                        ),
                        _navItem(
                          Icons.person_outline,
                          'Profil',
                          false,
                          () {
                            Navigator.pushNamed(
                              context, '/profil_guru',
                            );
                          },
                        ),
                      ],
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

  // STATISTIK CARD
  Widget _statCard(
    IconData icon,
    String number,
    String label,
    Color color,
  ) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SISWA CARD
  Widget _studentCard(
    String initial,
    String name,
    String kelas,
    String talent,
    Color avatarColor,
  ) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: avatarColor,
            child: Text(
              initial,
              style: const TextStyle(
                color: darkPurple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kelas,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 4),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                talent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFFB77900),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAV ITEM
  Widget _navItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: active ? purple : Colors.grey.shade400,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 9,
                color: active ? purple : Colors.grey.shade400,
                fontWeight:
                    active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
