import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployedDetailScreen extends StatefulWidget {
  const EmployedDetailScreen({super.key});

  @override
  State<EmployedDetailScreen> createState() => _EmployedDetailScreenState();
}

class _EmployedDetailScreenState extends State<EmployedDetailScreen> {
  // Data default untuk informasi karyawan
  Map<String, String> employeeData = {
    'personal_number': 'EMP12345',
    'registered_name': 'Brooklyn Simmons',
    'position': 'Software Engineer',
    'company_code': 'COMP001',
    'business_area': 'Technology',
    'personal_area': 'Head Office',
    'personal_sub_area': 'IT Department',
    'jabatan': 'Senior Developer',
    'grade': 'G5',
    'officer': 'John Doe',
  };

  @override
  void initState() {
    super.initState();
    _loadEmployeeData(); // Memuat data karyawan saat inisialisasi
  }

  // Memuat data karyawan dari SharedPreferences
  Future<void> _loadEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeData = {
        'personal_number': prefs.getString('personal_number') ?? employeeData['personal_number']!,
        'registered_name': prefs.getString('registered_name') ?? employeeData['registered_name']!,
        'position': prefs.getString('position') ?? employeeData['position']!,
        'company_code': prefs.getString('company_code') ?? employeeData['company_code']!,
        'business_area': prefs.getString('business_area') ?? employeeData['business_area']!,
        'personal_area': prefs.getString('personal_area') ?? employeeData['personal_area']!,
        'personal_sub_area': prefs.getString('personal_sub_area') ?? employeeData['personal_sub_area']!,
        'jabatan': prefs.getString('jabatan') ?? employeeData['jabatan']!,
        'grade': prefs.getString('grade') ?? employeeData['grade']!,
        'officer': prefs.getString('officer') ?? employeeData['officer']!,
      };
    });
  }

  // Menyimpan data karyawan ke SharedPreferences
  Future<void> _saveEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in employeeData.keys) {
      await prefs.setString(key, employeeData[key]!);
    }

    // Tampilkan SnackBar untuk konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Employee information updated successfully'),
        backgroundColor: Color(0xFF6422FF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Menampilkan dialog untuk mengedit informasi karyawan
  void _showEditDialog(BuildContext context) {
    final Map<String, TextEditingController> controllers = {};
    for (var key in employeeData.keys) {
      controllers[key] = TextEditingController(text: employeeData[key]);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Edit Employee Information',
            style: TextStyle(
              color: Color(0xFF6422FF),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: employeeData.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextField(
                    controller: controllers[key],
                    decoration: InputDecoration(
                      labelText: key.replaceAll('_', ' ').toUpperCase(),
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
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  for (var key in employeeData.keys) {
                    employeeData[key] = controllers[key]!.text;
                  }
                });
                _saveEmployeeData();
                Navigator.of(context).pop();
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

  // Ikon untuk setiap informasi
  final Map<String, IconData> icons = {
    'personal_number': Icons.badge,
    'registered_name': Icons.person,
    'position': Icons.work,
    'company_code': Icons.business,
    'business_area': Icons.domain,
    'personal_area': Icons.person,
    'personal_sub_area': Icons.subdirectory_arrow_right,
    'jabatan': Icons.star,
    'grade': Icons.grade,
    'officer': Icons.person_pin,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AppBar Kustom
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6422FF),
                    Color(0xFFFFA726),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 40,
                    left: 16,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Employed Information Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Konten utama
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: employeeData.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  icons[entry.key] ?? Icons.info,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key.replaceAll('_', ' ').toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      entry.value,
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
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Jarak sebelum tombol Edit
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () => _showEditDialog(context),
                      mini: true, // Membuat tombol lebih kecil
                      backgroundColor: const Color(0xFF6422FF),
                      child: const Icon(
                        Icons.edit,
                        size: 20, // Ukuran ikon kecil
                        color: Colors.white,
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