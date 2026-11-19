
import 'package:flutter/material.dart';

class ProfilSiswaPage extends StatelessWidget {
  const ProfilSiswaPage({super.key});

  final Color primaryColor = const Color(0xFF6C5CFF);

  // KONFIRMASI KELUAR
  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(
                  color: Color(0xFF6C5CFF),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3F50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (hasil == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 320,
          height: 680,
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,

            // BODY
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  constraints: const BoxConstraints(
                                    minWidth: 26,
                                    minHeight: 26,
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  'Profil Siswa',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // FOTO DAN IDENTITAS SISWA
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Color(0xFFD3E3FD),
                                    backgroundImage: AssetImage(
                                      'assets/images/foto alya.jpeg',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alya Nasmi',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'XII RPL B',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 29),

                            // MENU PROFIL
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                  width: 0.8,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Column(
                                children: [
                                  _buildMenuItem(
                                    icon: Icons.person,
                                    title: 'Data Pribadi',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.class_outlined,
                                    title: 'Kelas',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.calendar_today_outlined,
                                    title: 'Bakat',
                                    onTap: () {},
                                  ),
                                  _buildMenuItem(
                                    icon: Icons.settings_outlined,
                                    title: 'Detail jadwal',
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail_jadwal_siswa',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 27),

                            // TOMBOL KELUAR
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _konfirmasiKeluar(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFFF3F50),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        size: 15,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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

            // BOTTOM NAVIGATION
            bottomNavigationBar: Container(
              height: 55,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    title: 'Beranda',
                    active: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/dashboard_siswa',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.library_books_outlined,
                    title: 'Bakat',
                    active: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/daftar_bakat',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.more_horiz_rounded,
                    title: 'Detail',
                    active: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail_jadwal_siswa',
                      );
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.person,
                    title: 'Profil',
                    active: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET MENU PROFIL
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 37,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        leading: Icon(
          icon,
          size: 18,
          color: Colors.black87,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 10,
          color: Colors.black87,
        ),
        onTap: onTap,
      ),
    );
  }

  // WIDGET BOTTOM NAVIGATION
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? primaryColor : Colors.black87,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 8,
                color: Colors.black,
                fontWeight: active
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
