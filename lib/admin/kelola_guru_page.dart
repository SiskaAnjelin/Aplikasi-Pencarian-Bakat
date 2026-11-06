import 'package:flutter/material.dart';
import 'tambah_guru_page.dart';

class KelolaGuruPage extends StatefulWidget {
  final bool standalone;
  const KelolaGuruPage({super.key, this.standalone = false});

  @override
  State<KelolaGuruPage> createState() => _KelolaGuruPageState();
}

class _KelolaGuruPageState extends State<KelolaGuruPage> {
  final List<Map<String, String>> _guruList = [
    {'id': '1', 'name': 'Naufal Zaidan', 'bidang': 'Seni & Olahraga', 'nip': '1987654321'},
    {'id': '2', 'name': 'Pak Arif', 'bidang': 'Teknologi', 'nip': '1987654322'},
    {'id': '3', 'name': 'Bu Sari', 'bidang': 'Musik', 'nip': '1987654323'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: widget.standalone
          ? AppBar(
              title: const Text('Data Guru'),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3436)),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahGuruPage()),
          );
          if (result != null && result is Map<String, String>) {
            setState(() => _guruList.add(result));
          }
        },
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.standalone)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Guru',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _guruList.length,
                itemBuilder: (context, index) {
                  final guru = _guruList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF00B894).withOpacity(0.12),
                          child: Text(
                            guru['name']![0],
                            style: const TextStyle(
                              color: Color(0xFF00B894),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guru['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${guru['bidang']} · NIP ${guru['nip']}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF636E72)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TambahGuruPage(guru: guru),
                              ),
                            );
                            if (result != null && result is Map<String, String>) {
                              setState(() {
                                final i = _guruList.indexWhere((g) => g['id'] == guru['id']);
                                if (i != -1) _guruList[i] = result;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          color: const Color(0xFF6C5CE7),
                        ),
                      ],
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