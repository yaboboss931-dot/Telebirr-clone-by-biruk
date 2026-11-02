import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupNumberScreen extends StatefulWidget {
  const SetupNumberScreen({super.key});

  @override
  State<SetupNumberScreen> createState() => _SetupNumberScreenState();
}

class _SetupNumberScreenState extends State<SetupNumberScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  // Load the number when the screen opens
  void _loadSavedNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _numberController.text = prefs.getString('target_number') ?? '';
    });
  }

  // Save the number to phone memory
  void _saveNumber() async {
    String number = _numberController.text.trim();
    if (number.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('target_number', number);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Target Number Saved Successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Prank Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Enter the phone number you want to send the fake SMS to. The app will remember this number.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Friend\'s Phone Number',
                hintText: 'e.g. 0911223344',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF7CB342), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CB342),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveNumber,
                child: const Text('Save Number', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
