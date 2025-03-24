import 'package:flutter/material.dart';

class AccountSettingScreen extends StatefulWidget {
  final String appName;
  final String username;

  const AccountSettingScreen({
    super.key,
    required this.appName,
    required this.username,
  });

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal
    _appNameController = TextEditingController(text: widget.appName);
    _usernameController = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Logika untuk menyimpan perubahan (misalnya, update data di database atau state)
    String newAppName = _appNameController.text;
    String newUsername = _usernameController.text;

    // Tampilkan SnackBar untuk konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account updated: $newAppName ($newUsername)'),
        backgroundColor: const Color(0xFF6422FF),
        duration: const Duration(seconds: 2),
      ),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  void _deleteAccount() {
    // Tampilkan dialog konfirmasi sebelum menghapus dengan ikon tong sampah
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete, // Ikon tong sampah
              color: Colors.red, // Warna merah
              size: 50, // Ukuran ikon
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to delete ${widget.appName}?',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              // Logika untuk menghapus akun (misalnya, hapus dari database atau state)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.appName} has been deleted'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6422FF),
              ),
            ),
            const SizedBox(height: 20),
            // Field untuk mengedit nama aplikasi
            TextField(
              controller: _appNameController,
              decoration: InputDecoration(
                labelText: 'App Name',
                labelStyle: const TextStyle(color: Color(0xFF6422FF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6422FF)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Field untuk mengedit username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Color(0xFF6422FF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6422FF)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Save
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6422FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Delete
            ElevatedButton(
              onPressed: _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}