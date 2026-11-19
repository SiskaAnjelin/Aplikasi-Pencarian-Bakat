
import 'package:flutter/material.dart';

class ProfilGuruPage extends StatelessWidget {
  const ProfilGuruPage({super.key});

  static const Color purple = Color(0xFF56518D);
  static const Color red = Color(0xFFFF3838);

  // NAVIGASI BOTTOM BAR
  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/dashboard_guru',
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/data_siswa',
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/riwayat_guru',
        );
        break;

      case 3:
        // Sudah berada di halaman profil
        break;
    }
  }

  // KONFIRMASI KELUAR
  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && context.mounted) {
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

              // HEADER
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Profil Guru',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                ),
              ),

              // BODY
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PROFIL GURU
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/foto pak aris.jpg',
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 54,
                                height: 54,
                                color: const Color(0xFFE8E7FF),
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Color(0xFF6C63FF),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pak Aris',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Guru Penguji • Akademi',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Divider(
                      color: Color(0xFFD0D0D0),
                      thickness: 1,
                    ),

                    const SizedBox(height: 8),

                    // BIDANG KEAHLIAN
                    const Text(
                      'Bidang Keahlian',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _buildSkill('Coding'),
                        const SizedBox(width: 10),
                        _buildSkill('Seni'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // KELOLA BIDANG
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/bidang-keahlian',
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 38,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit_note,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                'Kelola Bidang Keahlian',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DATA PRIBADI
                    const Text(
                      'Data Pribadi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildData('NIP', '098765432123'),
                    _buildData('Email', 'arisdigital@gmail.com'),
                    _buildData('Alamat', 'Jl. Bandung Timur'),
                    _buildData('No. Hp', '0890987567'),

                    const SizedBox(height: 18),

                    // TOMBOL KELUAR
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _konfirmasiKeluar(context);
                          },
                          icon: const Icon(
                            Icons.logout,
                            size: 16,
                          ),
                          label: const Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),

              // BOTTOM NAVIGATION
              bottomNavigationBar: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFF0F0F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.home_outlined,
                        'Beranda',
                        0,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.people,
                        'Daftar Siswa',
                        1,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.history,
                        'Riwayat',
                        2,
                        false,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        Icons.person,
                        'Profil',
                        3,
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET LABEL BIDANG
  static Widget _buildSkill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDCDCDC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // WIDGET DATA PRIBADI
  static Widget _buildData(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET BOTTOM NAVIGATION
  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
    bool active,
  ) {
    return InkWell(
      onTap: () {
        _onNavTap(context, index);
      },
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? purple : Colors.grey.shade700,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                color: active ? purple : Colors.black,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
