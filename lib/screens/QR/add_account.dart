import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../main/main_page.dart'; // Import file main_page.dart

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  String? scannedCode;
  bool showScanner = true;
  bool showKeypad = false;
  String enteredPin = '';

  void _updatePin(String value) {
    setState(() {
      if (value == 'delete') {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else {
        enteredPin += value;
      }
    });
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
          'Add Account',
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
      body: showScanner
          ? ScannerScreen(
              onScan: (code) {
                // Langsung arahkan ke MainPage setelah scan berhasil
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(pin: code),
                  ),
                );
              },
              onManualEntry: () {
                setState(() {
                  showScanner = false;
                  showKeypad = true;
                });
              },
            )
          : showKeypad
              ? KeypadScreen(
                  enteredPin: enteredPin,
                  onKeyPressed: _updatePin,
                  onSubmit: () {
                    if (enteredPin.length >= 4) {
                      // Langsung arahkan ke MainPage setelah submit PIN
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(pin: enteredPin),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIN must be at least 4 digits'),
                        ),
                      );
                    }
                  },
                  onCancel: () {
                    setState(() {
                      showKeypad = false;
                      showScanner = true; // Kembali ke layar scanner
                      enteredPin = '';
                    });
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a New Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6422FF),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (scannedCode != null)
                        Text(
                          'Scanned Code: $scannedCode',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      if (scannedCode != null) const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showScanner = true;
                            scannedCode = null;
                            enteredPin = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6422FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Scan QR Code Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showKeypad = true;
                            enteredPin = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6422FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Enter Code Manually',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          String? finalCode = scannedCode ?? enteredPin;
                          if (finalCode.isNotEmpty) {
                            // Langsung arahkan ke MainPage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(pin: finalCode),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please scan or enter a PIN')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Add Account',
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

class ScannerScreen extends StatelessWidget {
  final Function(String) onScan;
  final VoidCallback onManualEntry;

  const ScannerScreen({
    super.key,
    required this.onScan,
    required this.onManualEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (BarcodeCapture capture) {
            final String? code = capture.barcodes.first.rawValue;
            if (code != null) {
              onScan(code);
            }
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Your account provider will display a QR code.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: TextButton(
              onPressed: onManualEntry,
              child: const Text(
                'OR ENTER CODE MANUALLY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class KeypadScreen extends StatelessWidget {
  final String enteredPin;
  final Function(String) onKeyPressed;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const KeypadScreen({
    super.key,
    required this.enteredPin,
    required this.onKeyPressed,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Enter PIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6422FF),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your PIN contains at least 4 digits.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          enteredPin.isEmpty ? '****' : enteredPin,
          style: const TextStyle(
            fontSize: 32,
            letterSpacing: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6422FF),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildKeypadButton('1', 'ABC'),
              _buildKeypadButton('2', 'DEF'),
              _buildKeypadButton('3', 'GHI'),
              _buildKeypadButton('4', 'JKL'),
              _buildKeypadButton('5', 'MNO'),
              _buildKeypadButton('6', 'PQR'),
              _buildKeypadButton('7', 'STU'),
              _buildKeypadButton('8', 'VWX'),
              _buildKeypadButton('9', 'YZ'),
              _buildKeypadButton('0', '', onPressed: () => onKeyPressed('0')),
              _buildKeypadButton('', '', icon: Icons.backspace, onPressed: () => onKeyPressed('delete')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String number, String letters, {IconData? icon, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? () => onKeyPressed(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 24)
          else
            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (letters.isNotEmpty)
            Text(
              letters,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }
}