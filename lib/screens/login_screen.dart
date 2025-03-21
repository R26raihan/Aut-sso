import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background tetap clean (putih)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Ikon Autentikasi (Gembok)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFA726), // Oranye terang
                        Color(0xFF6422FF), // Ungu tua
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock, // Ikon gembok
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // Judul (warna hitam)
                const Text(
                  'Login to SSO Authenticator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Warna hitam
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Field Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF6422FF), // Ikon ungu
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFA726), // Border oranye saat fokus
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Field Password
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF6422FF), // Ikon ungu
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFA726), // Border oranye saat fokus
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Row untuk Tombol Login dan Tombol Sidik Jari
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Login
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.main);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6422FF), // Tombol ungu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Tombol Login dengan Sidik Jari
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika untuk login dengan sidik jari
                          // Untuk saat ini, kita arahkan ke halaman utama
                          Navigator.pushReplacementNamed(context, AppRoutes.main);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726), // Tombol oranye
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.all(0), // Hilangkan padding default
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Keterangan Syarat dan Ketentuan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Dengan login, Anda telah mengetahui dan menyetujui syarat dan ketentuan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
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