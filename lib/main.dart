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

    // Check if 14 hours have passed
    if (difference.inHours >= 14) {
      int? lastUnlockMillis = prefs.getInt('last_unlock_time');
      
      // If they have never unlocked it, or if 1 hour has passed since the last unlock
      if (lastUnlockMillis == null || now.difference(DateTime.fromMillisecondsSinceEpoch(lastUnlockMillis)).inHours >= 1) {
        setState(() {
          _isLocked = true;
          _isLoading = false;
        });
      } else {
        // They unlocked it less than 1 hour ago, let them in
        setState(() {
          _isLocked = false;
          _isLoading = false;
        });
      }
    } else {
      // 14 hours haven't passed yet, let them in
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
      return LockScreen(
        onUnlock: () {
          // Re-check the time lock after they unlock
          _checkTimeLock();
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // We check which password is required next. Default is the first one.
    String requiredPassword = prefs.getString('next_password') ?? 'yeab@1234';

    if (enteredPassword == requiredPassword) {
      // Save the time they unlocked it so it gives them 1 hour
      await prefs.setInt('last_unlock_time', DateTime.now().millisecondsSinceEpoch);
      
      // Change the password for the NEXT time it locks
      if (requiredPassword == 'yeab@1234') {
        await prefs.setString('next_password', 'yeab@12345');
      } else {
        await prefs.setString('next_password', 'yeab@1234');
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
