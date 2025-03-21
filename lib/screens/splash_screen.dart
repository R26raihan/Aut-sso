import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
// Import file theme kamu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animasi
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Delay 3 detik lalu navigasi ke Login Screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFA726), // Oranye terang
              Color(0xFF6422FF), // Ungu tua
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Icons (Dekorasi)
              Positioned(
                top: -50,
                left: -50,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Icon(
                    Icons.shield,
                    size: 150,
                    color: Colors.white10,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                right: -60,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Icon(
                    Icons.verified_user,
                    size: 180,
                    color: Colors.white10,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: -30,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Icon(
                    Icons.security,
                    size: 120,
                    color: Colors.white10,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: -20,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Icon(
                    Icons.lock_clock,
                    size: 130,
                    color: Colors.white10,
                  ),
                ),
              ),

              // Main Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon Utama
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Aplikasi
                  const Text(
                    'SSO Authenticator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 20),

                  // Loader / Indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}