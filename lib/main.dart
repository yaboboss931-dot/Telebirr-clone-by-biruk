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
      home: const AppTimeGate(), // <--- The Time Lock Gate
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
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _checkTimeLock();
  }

  void _checkTimeLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Check if the app was ever installed before
    int? installTimeMillis = prefs.getInt('install_time');
    
    if (installTimeMillis == null) {
      // First time opening the app
      installTimeMillis = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt('install_time', installTimeMillis);
    }

    DateTime installTime = DateTime.fromMillisecondsSinceEpoch(installTimeMillis);
    DateTime now = DateTime.now();
    Duration difference = now.difference(installTime);

    // Check if 14 hours (14 * 60 minutes) have passed
    if (difference.inHours >= 14) {
      // Check if they unlocked it in the last 1 hour
      int? lastUnlockMillis = prefs.getInt('last_unlock_time');
      if (lastUnlockMillis != null) {
        DateTime lastUnlock = DateTime.fromMillisecondsSinceEpoch(lastUnlockMillis);
        if (now.difference(lastUnlock).inHours < 1) {
          setState(() {
            _isUnlocked = true;
            _isLoading = false;
          });
          return;
        }
      }
      
      // Time is up, lock the app
      setState(() {
        _isLocked = true;
        _isLoading = false;
      });
    } else {
      // Time is not up yet, let them in
      setState(() {
        _isUnlocked = true;
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
      return LockScreen(
        onUnlock: () {
          setState(() {
            _isLocked = false;
            _isUnlocked = true;
          });
        },
      );
    }

    // If unlocked, show the real app
    return const LoginScreen();
  }
}

// --- THE LOCK SCREEN WITH PASSWORDS ---
class LockScreen extends StatefulWidget {
  final VoidCallback onUnlock;
  const LockScreen({super.key, required this.onUnlock});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  void _verifyPassword() async {
    String enteredPassword = _passwordController.text.trim();

    // Define the valid passwords
    const String pass1 = 'yeab@1234';
    const String pass2 = 'yeab@12345'; // The new password for the next time

    if (enteredPassword == pass1 || enteredPassword == pass2) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Save the time they unlocked it so it gives them 1 hour
      await prefs.setInt('last_unlock_time', DateTime.now().millisecondsSinceEpoch);
      
      // If they used pass1, change the password to pass2 for next time
      if (enteredPassword == pass1) {
        await prefs.setString('next_password', pass2);
      } else if (enteredPassword == pass2) {
        await prefs.setString('next_password', pass1); // Switches back and forth
      }

      widget.onUnlock();
    } else {
      setState(() {
        _errorMessage = 'Wrong password! Ask Yeabsra 😂';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ASK YEABSRA FOR PASSWORD IF U WANT TO MAKE IT 😂',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // BIG FONT
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _verifyPassword,
                  child: const Text('Unlock for 1 Hour', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
