import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> with SingleTickerProviderStateMixin {
  BarcodeCapture? result;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation; // Untuk efek percikan
  late Animation<double> _lineAnimation; // Untuk garis naik-turun
  late Animation<Color?> _colorAnimation; // Untuk gradien border
  MobileScannerController controller = MobileScannerController();
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi animasi
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Animasi rotasi untuk efek percikan
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    // Animasi garis naik-turun
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Animasi warna gradien untuk border
    _colorAnimation = ColorTween(
      begin: const Color(0xFFFFA726), // Oranye
      end: const Color(0xFF6422FF), // Ungu
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login With QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6422FF), // Ungu
                Color(0xFFFFA726), // Oranye
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        actions: [
          // Tombol untuk toggle lampu senter
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                controller.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // MobileScanner untuk pemindaian
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              setState(() {
                result = capture;
              });
              if (result != null && result!.barcodes.isNotEmpty) {
                controller.stop(); // Hentikan kamera sementara
                _animationController.stop(); // Hentikan animasi sementara
                _handleQRCodeResult(result!.barcodes.first.rawValue);
              }
            },
          ),
          // Tulisan "Your account provider will display a QR Code" di bawah AppBar
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Your account provider will display a QR Code',
                style: TextStyle(
                  fontSize: 14, // Ukuran font kecil
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Kotak pemindaian dengan animasi
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  // Kotak pemindaian dengan border gradien
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _colorAnimation.value!,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: _colorAnimation.value!.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Garis naik-turun
                  AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _lineAnimation.value * 260, // Bergerak dari atas ke bawah
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: const Color(0xFFFFA726).withOpacity(0.8), // Garis oranye
                        ),
                      );
                    },
                  ),
                  // Efek percikan yang berputar
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Stack(
                          children: [
                            // Percikan di 4 sudut
                            _buildSparkle(0, 0),
                            _buildSparkle(300, 0),
                            _buildSparkle(0, 300),
                            _buildSparkle(300, 300),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Tombol "OR ENTER CODE MANUALLY"
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PinEntryScreen()),
                  );
                },
                child: const Text(
                  'OR ENTER CODE MANUALLY',
                  style: TextStyle(
                    fontSize: 14, // Ukuran font kecil
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk efek percikan
  Widget _buildSparkle(double left, double top) {
    return Positioned(
      left: left - 10,
      top: top - 10,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFA726).withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  void _handleQRCodeResult(String? code) {
    // Tampilkan SnackBar dengan hasil pemindaian
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          code ?? 'Tidak ada data',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6422FF), // Warna ungu
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Tutup',
          textColor: const Color(0xFFFFA726), // Warna oranye
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Lanjutkan pemindaian setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        result = null; // Reset hasil
      });
      controller.start(); // Lanjutkan pemindaian
      _animationController.repeat(); // Lanjutkan animasi
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

// Layar untuk input PIN
class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi animasi untuk tombol
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6422FF), // Ungu
              Color(0xFFFFA726), // Oranye
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon PIN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // Judul
                const Text(
                  'Masukkan PIN Anda',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                // Field input PIN
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Masukkan PIN',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFA726), // Warna oranye saat fokus
                        width: 2,
                      ),
                    ),
                  ),
                  autofocus: true, // Keyboard otomatis muncul
                ),
                const SizedBox(height: 30),
                // Tombol Login
                MouseRegion(
                  onEnter: (_) => _buttonAnimationController.forward(),
                  onExit: (_) => _buttonAnimationController.reverse(),
                  child: GestureDetector(
                    onTap: () {
                      String pin = _pinController.text;
                      if (pin.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'PIN: $pin',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF6422FF),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        Navigator.pop(context); // Kembali ke QRScreen
                        _pinController.clear(); // Reset input
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PIN tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _buttonScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonScaleAnimation.value,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6422FF),
                                  Color(0xFFFFA726),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol Kembali
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke QRScreen
                    _pinController.clear(); // Reset input
                  },
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _pinController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }
}