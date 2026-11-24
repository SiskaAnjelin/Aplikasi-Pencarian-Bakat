import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Palet Warna Aplikasi Niskala ---
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primarySoft = Color(0xFFEEF2FF);
  static const Color secondary = Color(0xFFFBBF24);
  static const Color background = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color danger = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
}

// --- Model Siswa ---
class Siswa {
  String id;
  String nama;
  String kelas;
  String jurusan;
  String noHp;
  bool tampil;

  Siswa({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.jurusan,
    required this.noHp,
    this.tampil = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'kelas': kelas,
    'jurusan': jurusan,
    'noHp': noHp,
    'tampil': tampil,
  };

  factory Siswa.fromMap(Map<String, dynamic> map) => Siswa(
    id: map['id'] ?? '',
    nama: map['nama'] ?? '',
    kelas: map['kelas'] ?? '',
    jurusan: map['jurusan'] ?? '',
    noHp: map['noHp'] ?? '',
    tampil: map['tampil'] ?? true,
  );
}

// --- Model Guru Juri ---
class GuruJuri {
  String id;
  String nama;
  String nip;
  String bidang;

  GuruJuri({
    required this.id,
    required this.nama,
    required this.nip,
    required this.bidang,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'nip': nip,
    'bidang': bidang,
  };

  factory GuruJuri.fromMap(Map<String, dynamic> map) => GuruJuri(
    id: map['id'] ?? '',
    nama: map['nama'] ?? '',
    nip: map['nip'] ?? '',
    bidang: map['bidang'] ?? '',
  );
}

// --- Model Jadwal ---
class Jadwal {
  String id;
  String judul;
  String tanggal;
  String jam;
  String kelas;
  String ruangan;
  String siswa;
  String guruJuri;
  String deskripsi;
  String status;

  Jadwal({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.kelas,
    required this.ruangan,
    required this.siswa,
    required this.guruJuri,
    required this.deskripsi,
    this.status = "Terdaftar",
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'judul': judul,
    'tanggal': tanggal,
    'jam': jam,
    'kelas': kelas,
    'ruangan': ruangan,
    'siswa': siswa,
    'guruJuri': guruJuri,
    'deskripsi': deskripsi,
    'status': status,
  };

  factory Jadwal.fromMap(Map<String, dynamic> map) => Jadwal(
    id: map['id'] ?? '',
    judul: map['judul'] ?? '',
    tanggal: map['tanggal'] ?? '',
    jam: map['jam'] ?? '',
    kelas: map['kelas'] ?? '',
    ruangan: map['ruangan'] ?? '',
    siswa: map['siswa'] ?? '',
    guruJuri: map['guruJuri'] ?? '',
    deskripsi: map['deskripsi'] ?? '',
    status: map['status'] ?? 'Terdaftar',
  );
}

// --- Service Penyimpanan Nyata di HP Pengguna (KOSONG AWALNYA) ---
class StorageService {
  static List<Siswa> listSiswa = [];
  static List<GuruJuri> listGuru = [];
  static List<Jadwal> listJadwal = [];

  // Panggil fungsi ini saat pertama kali aplikasi dibuka
  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Siswa
    final siswaJson = prefs.getString('data_siswa');
    if (siswaJson != null) {
      final List decoded = jsonDecode(siswaJson);
      listSiswa = decoded.map((e) => Siswa.fromMap(e)).toList();
    }

    // Load Guru
    final guruJson = prefs.getString('data_guru');
    if (guruJson != null) {
      final List decoded = jsonDecode(guruJson);
      listGuru = decoded.map((e) => GuruJuri.fromMap(e)).toList();
    }

    // Load Jadwal
    final jadwalJson = prefs.getString('data_jadwal');
    if (jadwalJson != null) {
      final List decoded = jsonDecode(jadwalJson);
      listJadwal = decoded.map((e) => Jadwal.fromMap(e)).toList();
    }
  }

  // Simpan data Siswa secara permanen
  static Future<void> saveSiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(listSiswa.map((e) => e.toMap()).toList());
    await prefs.setString('data_siswa', jsonString);
  }

  // Simpan data Guru secara permanen
  static Future<void> saveGuru() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(listGuru.map((e) => e.toMap()).toList());
    await prefs.setString('data_guru', jsonString);
  }

  // Simpan data Jadwal secara permanen
  static Future<void> saveJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(listJadwal.map((e) => e.toMap()).toList());
    await prefs.setString('data_jadwal', jsonString);
  }
}