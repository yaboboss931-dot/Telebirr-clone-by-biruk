import 'dart:async';
import 'package:flutter/material.dart';
import 'receipt_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String recipientName;
  final String amount;
  final String transactionType;

  const LoadingScreen({
    super.key, 
    required this.recipientName, 
    required this.amount, 
    required this.transactionType
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // THIS IS THE 5-SECOND TIMER
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            recipientName: widget.recipientName,
            amount: widget.amount,
            transactionType: widget.transactionType,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The Green Loading Circle
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 6,
            ),
            const SizedBox(height: 30),
            Text(
              'Processing Transaction...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
