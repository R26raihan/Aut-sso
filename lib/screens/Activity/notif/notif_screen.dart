import 'package:flutter/material.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk notifikasi autentikasi terkait PLN
    final List<Map<String, String>> notifications = [
      {
        'title': 'Login Berhasil',
        'description': 'Anda telah login di perangkat Samsung Galaxy S21 pada jam 09:00 AM menggunakan aplikasi PLN Mobile.',
        'time': '09:02 AM, 21 Mar 2025',
      },
      {
        'title': 'Login Berhasil',
        'description': 'Anda telah login di perangkat iPhone 14 Pro pada jam 08:30 AM menggunakan aplikasi PLN Mobile.',
        'time': '08:32 AM, 21 Mar 2025',
      },
      {
        'title': 'Login Berhasil',
        'description': 'Anda telah login di perangkat Xiaomi 12 pada jam 07:45 AM menggunakan aplikasi PLN Mobile.',
        'time': '07:47 AM, 21 Mar 2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6422FF), // Warna ungu
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        title: const Text(
          'Notifications',
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
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  'No notifications available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFFFA726), // Border oranye
                          width: 1,
                        ),
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
                          // Ikon Notifikasi
                          const Icon(
                            Icons.security,
                            color: Color(0xFF6422FF), // Warna ungu
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          // Judul, Deskripsi, dan Waktu
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6422FF), // Warna ungu
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notification['description']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notification['time']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
      ),
    );
  }
}