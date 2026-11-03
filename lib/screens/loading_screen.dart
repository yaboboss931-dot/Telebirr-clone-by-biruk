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

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // Set up the spinning animation for the dots
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), 
    )..repeat();

    // 5-second timer before showing the receipt
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            recipientName: widget.recipientName,
            amount: widget.amount,
            transferType: widget.transactionType,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Center(
        child: Container(
          width: 95, // The white rounded box size
          height: 95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: RotationTransition(
              turns: _controller,
              child: SizedBox(
                width: 45, // Size of the spinning area
                height: 45,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(6, (index) {
                    // Creating 6 dots that get smaller and lighter
                    double size = 9.0 - (index * 1.2);
                    return Transform.rotate(
                      angle: index * (3.14159 / 3), // 60 degrees apart
                      child: Transform.translate(
                        offset: const Offset(0, -16), // Push to the edge
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7CB342).withOpacity(1.0 - (index * 0.15)),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
