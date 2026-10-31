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
    
    // Setup the spinning animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1 second per rotation
    )..repeat();

    // The 5-second timer before showing the receipt
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold background is transparent so you see the screen underneath
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white, // White circle behind the loader so it's visible
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
          ),
          child: RotationTransition(
            turns: _controller,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(4, (index) {
                  return Transform.rotate(
                    angle: index * (3.14159 / 2), // 90 degrees
                    child: Transform.translate(
                      offset: const Offset(0, -18), // Push dots to the edge
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.green,
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
    );
  }
}
