import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import './notif/notif_screen.dart'; // Impor NotifScreen
import './article_screen.dart'; // Impor ArticleScreen
import '../QR/add_account.dart'; // Impor AddAccountScreen
import 'package:flutter/services.dart'; // Untuk fungsi copy
import '../Activity/account_setting/account_setting.dart'; // Impor AccountSettingScreen
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String? pin; // Tambahkan parameter pin untuk menampilkan SnackBar

  const HomeScreen({super.key, this.pin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _notificationCount = 3; // Jumlah notifikasi awal
  final PageController _pageController = PageController(); // Controller untuk PageView
  int _currentPage = 0; // Menyimpan indeks banner yang aktif
  List<String> _authCodes = ['352437', '353377', '553535']; // Kode awal
  double _timerProgress = 1.0; // Progress timer (1.0 = 60 detik)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Listener untuk memperbarui indeks banner saat digeser
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    // Timer untuk memperbarui kode setiap 1 menit
    _startTimer();

    // Tampilkan SnackBar jika pin tidak null
    if (widget.pin != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login dengan PIN berhasil'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timerProgress -= 1 / 60; // Kurangi progress setiap detik (60 detik total)
        if (_timerProgress <= 0) {
          // Reset timer dan buat kode baru
          _timerProgress = 1.0;
          _generateNewCodes();
        }
      });
    });
  }

  void _generateNewCodes() {
    setState(() {
      _authCodes = List.generate(3, (_) {
        // Generate kode 6 digit acak
        return (Random().nextInt(900000) + 100000).toString();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Data untuk banner tentang keamanan akun
    final List<Map<String, dynamic>> banners = [
      {
        'icon': Icons.lock,
        'title': 'Use Strong Passwords',
        'description': 'Combine letters, numbers, and symbols for better security.',
      },
      {
        'icon': Icons.verified_user,
        'title': 'Enable 2FA',
        'description': 'Add an extra layer of protection with two-factor authentication.',
      },
      {
        'icon': Icons.warning,
        'title': 'Avoid Phishing',
        'description': 'Be cautious of suspicious emails and links.',
      },
      {
        'icon': Icons.update,
        'title': 'Regular Updates',
        'description': 'Keep your password updated and monitor activity.',
      },
      {
        'icon': Icons.visibility_off,
        'title': 'Hide Sensitive Info',
        'description': 'Never share your password or personal details.',
      },
    ];

    // Data untuk authenticator code
    final List<Map<String, dynamic>> authApps = [
      {
        'icon': Icons.lock,
        'name': 'PLN IAM Mobile',
        'username': 'felicia.reid@pin.co.id',
        'code': _authCodes[0],
      },
      {
        'icon': Icons.security,
        'name': 'Komando',
        'username': 'kenzi.lawson@pin.co.id',
        'code': _authCodes[1],
      },
      {
        'icon': Icons.power,
        'name': 'PLN AMS Korporat',
        'username': 'felicia.reid@pin.co.id',
        'code': _authCodes[2],
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar sebagai bagian dari konten yang discroll
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6422FF), // Ungu
                    Color(0xFFFFA726), // Oranye
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Ikon Profil
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Color(0xFF6422FF), // Warna ungu untuk ikon
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Nama dan Email Karyawan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Brooklyn Simmons', // Nama karyawan
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis, // Mencegah overflow teks
                            ),
                            SizedBox(height: 2),
                            Text(
                              'brooklyn.simmons@pin.co.id', // Email karyawan
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis, // Mencegah overflow teks
                            ),
                          ],
                        ),
                      ),
                      // Ikon Lonceng Notifikasi
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              // Navigasi ke NotifScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotifScreen()),
                              ).then((_) {
                                // Reset jumlah notifikasi setelah kembali dari NotifScreen
                                setState(() {
                                  _notificationCount = 0;
                                });
                              });
                            },
                          ),
                          // Badge notifikasi (hanya muncul jika ada notifikasi)
                          if (_notificationCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFA726), // Warna oranye untuk badge
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_notificationCount', // Jumlah notifikasi
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Elemen "Secure Your Account" di bawah AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  // Navigasi ke ArticleScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArticleScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Secure Your Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6422FF), // Warna ungu
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF6422FF), // Warna ungu
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            // Banner horizontal dengan indikator posisi
            SizedBox(
              height: 170, // Tinggi banner + indikator
              child: Column(
                children: [
                  // Banner
                  SizedBox(
                    height: 150, // Tinggi banner
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigasi ke ArticleScreen saat banner diklik
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ArticleScreen()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: 250, // Lebar setiap banner
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6422FF), // Ungu
                                    Color(0xFFFFA726), // Oranye
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Ikon
                                    Icon(
                                      banner['icon'] as IconData,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    const SizedBox(width: 10),
                                    // Judul dan Deskripsi
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            banner['title'] as String,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            banner['description'] as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Indikator posisi (dots) dengan animasi
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 12 : 8,
                          height: _currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color(0xFF6422FF) // Dot aktif: ungu
                                : const Color(0xFFFFA726).withOpacity(0.5), // Dot tidak aktif: oranye
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Teks "Authenticator Code" di bawah banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Authenticator Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6422FF), // Warna ungu
                    ),
                  ),
                ],
              ),
            ),
            // Authenticator Code
            ListView.builder(
              shrinkWrap: true, // Membuat ListView mengikuti ukuran konten
              physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView
              padding: const EdgeInsets.all(16.0),
              itemCount: authApps.length,
              itemBuilder: (context, index) {
                final app = authApps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Ikon aplikasi
                        Icon(
                          app['icon'] as IconData,
                          color: const Color(0xFF6422FF), // Warna ungu
                          size: 40,
                        ),
                        const SizedBox(width: 15),
                        // Nama aplikasi, username, dan kode
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6422FF), // Warna ungu
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                app['username'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  // Kode 6 digit
                                  Text(
                                    app['code'] as String,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 5.0,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Timer countdown
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      value: _timerProgress,
                                      strokeWidth: 3,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFFA726), // Warna oranye
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Tombol salin
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Color(0xFF6422FF), // Warna ungu
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // Salin kode ke clipboard
                                      Clipboard.setData(ClipboardData(text: app['code'] as String));
                                      // Tampilkan snackbar
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Code copied to clipboard'),
                                          backgroundColor: const Color(0xFF6422FF),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                  // Tombol tanda titik tiga (menu)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF6422FF), // Warna ungu
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // Navigasi ke AccountSettingScreen dengan data akun
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AccountSettingScreen(
                                            appName: app['name'] as String,
                                            username: app['username'] as String,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Tombol "Add Account" tanpa background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  // Navigasi ke AddAccountScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddAccountScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: const Color(0xFF6422FF), // Warna ungu untuk ikon
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Add Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // Warna abu-abu untuk teks
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Jarak tambahan di bagian bawah
          ],
        ),
      ),
    );
  }
}