import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/password_screen.dart'; 

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
          seedColor: const Color(0xFF7CB342),
          primary: const Color(0xFF7CB342),
        ),
        useMaterial3: true,
      ),
      home: const PasswordScreen(), 
    );
  }
}
