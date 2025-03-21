import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; // Import local_auth
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
  bool _isLoading = false; // State untuk loading

  // Inisialisasi LocalAuthentication
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk autentikasi sidik jari
  Future<bool> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Periksa apakah perangkat mendukung biometrik
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perangkat ini tidak mendukung autentikasi biometrik. Silakan gunakan login manual.'),
          ),
        );
        return false;
      }

      // Periksa biometrik yang tersedia
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      print('Available biometrics: $availableBiometrics'); // Debugging

      if (availableBiometrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada biometrik yang tersedia. Silakan daftarkan biometrik di pengaturan perangkat.'),
          ),
        );
        return false;
      }

      // Periksa apakah ada biometrik yang bisa digunakan
      bool hasBiometric = availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak);

      if (!hasBiometric) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada biometrik yang kompatibel. Silakan daftarkan sidik jari atau gunakan login manual.'),
          ),
        );
        return false;
      }

      // Lakukan autentikasi
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Gunakan sidik jari untuk login ke SSO Authenticator',
        options: const AuthenticationOptions(
          biometricOnly: true, // Hanya izinkan biometrik
          stickyAuth: true, // Tetap aktif meskipun aplikasi di-background
          useErrorDialogs: true, // Gunakan dialog error bawaan sistem
        ),
      );

      if (authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autentikasi biometrik berhasil')),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Autentikasi Gagal'),
            content: const Text('Autentikasi sidik jari gagal. Apakah Anda ingin mencoba lagi atau menggunakan login manual?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _authenticateWithBiometrics(); // Coba lagi
                },
                child: const Text('Coba Lagi'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Login Manual'),
              ),
            ],
          ),
        );
      }

      return authenticated;
    } catch (e) {
      print('Error during biometric authentication: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                        onPressed: _isLoading
                            ? null // Nonaktifkan tombol saat loading
                            : () async {
                                bool isAuthenticated = await _authenticateWithBiometrics();
                                if (isAuthenticated) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.main);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726), // Tombol oranye
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.all(0), // Hilangkan padding default
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(
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