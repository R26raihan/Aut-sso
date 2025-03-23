import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

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
            bottomLeft: Radius.circular(30), // Border radius ujung kiri bawah
            bottomRight: Radius.circular(30), // Border radius ujung kanan bawah
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        title: const Text(
          'Secure Your Account',
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
            Navigator.pop(context); // Kembali ke HomeScreen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tips to Secure Your Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6422FF), // Warna ungu
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Use a strong password with a combination of letters, numbers, and special characters.\n'
              '2. Enable two-factor authentication (2FA) for added security.\n'
              '3. Avoid using the same password across multiple platforms.\n'
              '4. Regularly update your password and monitor your account activity.\n'
              '5. Be cautious of phishing emails or suspicious links.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}