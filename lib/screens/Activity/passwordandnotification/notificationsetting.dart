import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _enableNotifications = true; // Status awal untuk Enable Notifications
  bool _emailNotifications = false; // Status awal untuk Email Notifications
  bool _pushNotifications = true; // Status awal untuk Push Notifications

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings(); // Memuat pengaturan notifikasi saat inisialisasi
  }

  // Memuat pengaturan notifikasi dari SharedPreferences
  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableNotifications = prefs.getBool('enable_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
    });
  }

  // Menyimpan pengaturan notifikasi ke SharedPreferences
  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_notifications', _enableNotifications);
    await prefs.setBool('email_notifications', _emailNotifications);
    await prefs.setBool('push_notifications', _pushNotifications);

    // Tampilkan SnackBar untuk konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification settings updated'),
        backgroundColor: const Color(0xFF6422FF),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: const Color(0xFF6422FF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6422FF),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Enable Notifications',
                style: TextStyle(fontSize: 14),
              ),
              value: _enableNotifications,
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                  // Jika notifikasi dimatikan, nonaktifkan juga email dan push
                  if (!_enableNotifications) {
                    _emailNotifications = false;
                    _pushNotifications = false;
                  }
                });
                _saveNotificationSettings();
              },
              activeColor: const Color(0xFF6422FF),
            ),
            SwitchListTile(
              title: const Text(
                'Email Notifications',
                style: TextStyle(fontSize: 14),
              ),
              value: _emailNotifications,
              onChanged: _enableNotifications
                  ? (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                      _saveNotificationSettings();
                    }
                  : null, // Nonaktifkan switch jika Enable Notifications dimatikan
              activeColor: const Color(0xFF6422FF),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
            ),
            SwitchListTile(
              title: const Text(
                'Push Notifications',
                style: TextStyle(fontSize: 14),
              ),
              value: _pushNotifications,
              onChanged: _enableNotifications
                  ? (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                      _saveNotificationSettings();
                    }
                  : null, // Nonaktifkan switch jika Enable Notifications dimatikan
              activeColor: const Color(0xFF6422FF),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}