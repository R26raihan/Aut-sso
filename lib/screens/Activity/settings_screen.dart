import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'dart:io'; // Untuk menangani file gambar
import '../Activity/setting_account/employed_detail.dart'; // Pastikan path ini benar
import '../Activity/passwordandnotification/changepassword.dart'; // Impor halaman Change Password
import '../Activity/passwordandnotification/notificationsetting.dart'; // Impor halaman Notification Setting
import '../Activity//ortherinformtion/bantuan.dart';
import '../Activity/ortherinformtion/kebijakan.dart';
import '../Activity/ortherinformtion/panduanaplikasi.dart';
import '../Activity/ortherinformtion/syarat_dan_ketentuan.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController; // Controller untuk nomor telepon
  String? _profileImagePath; // Untuk menyimpan path gambar profil
  final ImagePicker _picker = ImagePicker(); // Untuk memilih gambar

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData(); // Memuat data pengguna saat inisialisasi
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Memuat data pengguna dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('user_email') ?? 'brooklyn.simmons@pin.co.id';
      _phoneController.text = prefs.getString('user_phone') ?? '+62 812-3456-7890';
      _profileImagePath = prefs.getString('profile_image_path');
    });
  }

  // Menyimpan data pengguna ke SharedPreferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_phone', _phoneController.text);
    if (_profileImagePath != null) {
      await prefs.setString('profile_image_path', _profileImagePath!);
    }
    // Tampilkan SnackBar untuk konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Color(0xFF6422FF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
      _saveUserData(); // Simpan path gambar ke SharedPreferences
    }
  }

  // Menampilkan dialog untuk mengedit informasi pribadi
  void _showEditDialog(BuildContext context) {
    TextEditingController tempEmailController = TextEditingController(text: _emailController.text);
    TextEditingController tempPhoneController = TextEditingController(text: _phoneController.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Edit Personal Information',
            style: TextStyle(
              color: Color(0xFF6422FF),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tempPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(color: Color(0xFF6422FF), fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF6422FF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tempEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Color(0xFF6422FF), fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF6422FF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _emailController.text = tempEmailController.text;
                  _phoneController.text = tempPhoneController.text;
                });
                _saveUserData(); // Simpan perubahan ke SharedPreferences
                Navigator.of(context).pop(); // Tutup dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6422FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar Kustom
            Container(
              height: 200, // Tinggi AppBar disesuaikan agar cukup untuk nama dan jabatan
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
                  bottomLeft: Radius.circular(30), // Lengkungan bawah kiri
                  bottomRight: Radius.circular(30), // Lengkungan bawah kanan
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 50, // Posisi CircleAvatar
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40, // Radius CircleAvatar
                              backgroundColor: Colors.white,
                              backgroundImage: _profileImagePath != null
                                  ? FileImage(File(_profileImagePath!))
                                  : null,
                              child: _profileImagePath == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 40, // Ukuran ikon
                                      color: Color(0xFF6422FF),
                                    )
                                  : null,
                            ),
                            // Tombol pensil untuk mengganti foto profil
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF6422FF),
                                  size: 20, // Ukuran ikon pensil
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // Jarak antara foto dan nama
                        // Registered Name
                        FutureBuilder<String>(
                          future: SharedPreferences.getInstance().then(
                            (prefs) => prefs.getString('registered_name') ?? 'Brooklyn Simmons',
                          ),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Brooklyn Simmons',
                              style: const TextStyle(
                                fontSize: 16, // Ukuran font untuk nama
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4), // Jarak antara nama dan jabatan
                        // Jabatan
                        FutureBuilder<String>(
                          future: SharedPreferences.getInstance().then(
                            (prefs) => prefs.getString('jabatan') ?? 'Senior Developer',
                          ),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Senior Developer',
                              style: const TextStyle(
                                fontSize: 14, // Ukuran font untuk jabatan
                                color: Colors.white70,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Konten utama
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card untuk Personal Information
                  Card(
                    elevation: 0, // Menghapus elevation agar transparan
                    color: Colors.transparent, // Membuat card transparan
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header dengan tombol Edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6422FF),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showEditDialog(context),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Informasi nomor telepon
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _phoneController.text,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Informasi email
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _emailController.text,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak antar card
                  // Card untuk Employed Information
                  Card(
                    elevation: 0, // Menghapus elevation agar transparan
                    color: Colors.transparent, // Membuat card transparan
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header dengan tombol navigasi ke detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Employed Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6422FF),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EmployedDetailScreen(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Detail',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Informasi Personal Area
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Personal Area',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  FutureBuilder<String>(
                                    future: SharedPreferences.getInstance().then(
                                      (prefs) => prefs.getString('personal_area') ?? 'Head Office',
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? 'Head Office',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Informasi Personal Sub Area
                          Row(
                            children: [
                              const Icon(
                                Icons.subdirectory_arrow_right,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Personal Sub Area',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  FutureBuilder<String>(
                                    future: SharedPreferences.getInstance().then(
                                      (prefs) => prefs.getString('personal_sub_area') ?? 'IT Department',
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? 'IT Department',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak antar card
                  // Card untuk Superior
                  Card(
                    elevation: 0, // Menghapus elevation agar transparan
                    color: Colors.transparent, // Membuat card transparan
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header tanpa tombol
                          const Text(
                            'Superior',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6422FF),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Informasi Nama Superior
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  FutureBuilder<String>(
                                    future: SharedPreferences.getInstance().then(
                                      (prefs) => prefs.getString('superior_name') ?? 'John Doe',
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? 'John Doe',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Informasi ID Superior
                          Row(
                            children: [
                              const Icon(
                                Icons.badge,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ID',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  FutureBuilder<String>(
                                    future: SharedPreferences.getInstance().then(
                                      (prefs) => prefs.getString('superior_id') ?? 'SUP12345',
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? 'SUP12345',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak antar card
                  // Card untuk Account Settings
                  Card(
                    elevation: 0, // Menghapus elevation agar transparan
                    color: Colors.transparent, // Membuat card transparan
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header tanpa tombol
                          const Text(
                            'Account Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6422FF),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Opsi Change Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChangePasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Opsi Notification Setting
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.notifications,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Notification Setting',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationSettingScreen(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Card untuk Other Information
                  Card(
                    elevation: 0, // Menghapus elevation agar transparan
                    color: Colors.transparent, // Membuat card transparan
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header tanpa tombol
                          const Text(
                            'Other Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6422FF),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Opsi Bantuan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.help_outline,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Bantuan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BantuanScreen(), // Pastikan halaman ini sudah diimpor
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Opsi Kebijakan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.policy,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Kebijakan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const KebijakanScreen(), // Pastikan halaman ini sudah diimpor
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Opsi Panduan Aplikasi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Panduan Aplikasi',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PanduanAplikasiScreen(), // Pastikan halaman ini sudah diimpor
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Opsi Syarat dan Ketentuan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.description,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Syarat dan Ketentuan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SyaratDanKetentuanScreen(), // Pastikan halaman ini sudah diimpor
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF6422FF),
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'settings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6422FF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),   
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}