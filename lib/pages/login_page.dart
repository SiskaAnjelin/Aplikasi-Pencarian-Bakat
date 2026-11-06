
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool _obscurePassword = true;
  bool _isLoading = false;

  final Color purple = const Color(0xFF6C5CFF);
  final Color yellow = const Color(0xFFFFC857);
  final Color darkPurple = const Color(0xFF29264F);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  // LOGIN SUPABASE
=======
>>>>>>> origin/main
  Future<void> _handleLogin() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'Email dan password tidak boleh kosong!',
        Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
<<<<<<< HEAD
      // 1. Login melalui Supabase Authentication
      final authResponse = await supabase.auth.signInWithPassword(
=======
      final supabase = Supabase.instance.client;

      // Login Supabase Authentication
      final response = await supabase.auth.signInWithPassword(
>>>>>>> origin/main
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Akun tidak ditemukan.');
      }

      final userId = user.id;

<<<<<<< HEAD
      // 2. Cek user_id pada tabel siswa
=======
      // Debug UID akun
      debugPrint('UID LOGIN: $userId');
      debugPrint('EMAIL LOGIN: ${user.email}');

      String? dashboard;

      // Cek role Siswa
>>>>>>> origin/main
      final siswa = await supabase
          .from('siswa')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      debugPrint('DATA SISWA: $siswa');

      if (siswa != null) {
<<<<<<< HEAD
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard_siswa',
          (route) => false,
=======
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
>>>>>>> origin/main
        );
        return;
      }

      // 3. Cek user_id pada tabel guru
      final guru = await supabase
          .from('guru')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (guru != null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard_guru',
          (route) => false,
        );
        return;
      }

      // 4. Cek user_id pada tabel admin
      final admin = await supabase
          .from('admin')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (admin != null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard_admin',
          (route) => false,
        );
        return;
      }

      // 5. Jika user_id tidak ada di ketiga tabel role
      await supabase.auth.signOut();
      throw Exception(
        'Akun terdaftar di Auth, tetapi data profil role tidak ditemukan di database.',
      );

    } on AuthException catch (e) {
      _showMessage(
        'Login gagal: ${e.message}',
        Colors.red,
      );
    } on PostgrestException catch (e) {
      _showMessage(
        'Gagal mengambil data Supabase: ${e.message}',
        Colors.red,
      );
    } catch (e) {
<<<<<<< HEAD
      _showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        Colors.red,
=======
      debugPrint('ERROR LOGIN: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
>>>>>>> origin/main
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // NOTIFIKASI
  void _showMessage(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                // FORM LOGIN
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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

                                  // EMAIL
                                  TextField(
<<<<<<< HEAD
                                    controller: _usernameController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    textInputAction:
                                        TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.email,
                                    ],
=======
                                    controller: _emailController,
                                    keyboardType:
                                        TextInputType.emailAddress,
>>>>>>> origin/main
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
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
                                      enabledBorder:
                                          OutlineInputBorder(
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

                                  // PASSWORD
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction:
                                        TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    onSubmitted: (_) {
                                      if (!_isLoading) {
                                        _handleLogin();
                                      }
                                    },
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
                                      enabledBorder:
                                          OutlineInputBorder(
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

                                  // TOMBOL LOGIN
                                  SizedBox(
                                    width: double.infinity,
                                    height: 38,
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _handleLogin,
                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor: purple,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            purple.withOpacity(0.6),
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

                                  const SizedBox(height: 18),

                                  // HUBUNGI ADMIN
                                  Center(
                                    child: Wrap(
                                      alignment:
                                          WrapAlignment.center,
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
                                            fontWeight:
                                                FontWeight.bold,
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

                // LINGKARAN UNGU
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

                // BINTANG KUNING
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
