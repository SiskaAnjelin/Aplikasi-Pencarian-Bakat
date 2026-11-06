
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final Color purple = const Color(0xFF6C5CFF);
  final Color yellow = const Color(0xFFFFC857);
  final Color darkPurple = const Color(0xFF29264F);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan Password tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // Login Supabase Authentication
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        throw Exception('Pengguna tidak ditemukan!');
      }

      final userId = user.id;

      // Debug UID akun
      debugPrint('UID LOGIN: $userId');
      debugPrint('EMAIL LOGIN: ${user.email}');

      String? dashboard;

      // Cek role Siswa
      final siswa = await supabase
          .from('siswa')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      debugPrint('DATA SISWA: $siswa');

      if (siswa != null) {
        dashboard = '/dashboard_siswa';
      } else {
        // Cek role Guru
        final guru = await supabase
            .from('guru')
            .select('user_id')
            .eq('user_id', userId)
            .maybeSingle();

        debugPrint('DATA GURU: $guru');

        if (guru != null) {
          dashboard = '/dashboard_guru';
        } else {
          // Cek role Admin menggunakan id_admin
          final admin = await supabase
              .from('admin')
              .select('id_admin')
              .eq('id_admin', userId)
              .maybeSingle();

          debugPrint('DATA ADMIN: $admin');

          if (admin != null) {
            dashboard = '/dashboard_admin';
          }
        }
      }

      if (!mounted) return;

      if (dashboard != null) {
        debugPrint('DASHBOARD: $dashboard');

        Navigator.pushReplacementNamed(
          context,
          dashboard,
        );
      } else {
        await supabase.auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Akun belum terdaftar sebagai Siswa, Guru, atau Admin!',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('ERROR LOGIN: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: darkPurple,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    'Silakan masuk dengan akun\n'
                                    'yang telah terdaftar!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: darkPurple,
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  // Email
                                  TextField(
                                    controller: _emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        size: 16,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: darkPurple,
                                          width: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Password
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 16,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: darkPurple,
                                          width: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Tombol Login
                                  SizedBox(
                                    width: double.infinity,
                                    height: 38,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: purple,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  const SizedBox(height: 12),

                                  // Hubungi Admin
                                  Center(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          'Belum punya akun atau lupa password?',
                                          style: TextStyle(
                                            color: darkPurple,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const Text(
                                          'Hubungi Admin',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Lingkaran ungu kanan atas
                Positioned(
                  top: 15,
                  right: -35,
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Bintang kuning kiri bawah
                Positioned(
                  bottom: 115,
                  left: 25,
                  child: Icon(
                    Icons.star_rounded,
                    size: 35,
                    color: yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
