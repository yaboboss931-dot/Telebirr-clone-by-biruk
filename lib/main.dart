import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telebirrbybr7/colors.dart'; 
import 'package:telebirrbybr7/screens/login_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telebirr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          primary: mainColor,
        ),
        useMaterial3: true,
      ),
      home: const AppTimeGate(), 
    );
  }
}

class AppTimeGate extends StatefulWidget {
  const AppTimeGate({super.key});

  @override
  State<AppTimeGate> createState() => _AppTimeGateState();
}

class _AppTimeGateState extends State<AppTimeGate> {
  bool _isLoading = true;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _checkTimeLock();
  }

  void _checkTimeLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    int? installTimeMillis = prefs.getInt('install_time');
    
    if (installTimeMillis == null) {
      installTimeMillis = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt('install_time', installTimeMillis);
    }

    DateTime installTime = DateTime.fromMillisecondsSinceEpoch(installTimeMillis);
    DateTime now = DateTime.now();
    Duration difference = now.difference(installTime);

    // 🚨 THE KILL SWITCH IS HERE 🚨
    // 8 hours = 8 hours. Change to 0 to test it immediately.
    if (difference.inHours >= 8) {
      setState(() {
        _isLocked = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLocked = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFF7CB342))),
      );
    }

    if (_isLocked) {
      return const EnatknLbdaScreen();
    }

    return const LoginScreen();
  }
}

// --- THE TROLL SCREEN 😂 ---
class EnatknLbdaScreen extends StatelessWidget {
  const EnatknLbdaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background to make it dramatic
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '_ enatkn lbda 😂',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45, // MASSIVE FONT
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'App expired. Go ask Yeabsra for a new one.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
