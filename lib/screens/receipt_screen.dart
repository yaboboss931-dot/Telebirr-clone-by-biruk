import 'dart:math';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final String recipientName;
  final String amount;
  final String transferType;

  const ReceiptScreen({
    super.key, 
    required this.recipientName, 
    required this.amount, 
    required this.transferType
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeString = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    // Generate random ID
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String txnNumber = 'DHP';
    for (int i = 0; i < 5; i++) {
      txnNumber += chars[random.nextInt(chars.length)];
    }
    for (int i = 0; i < 3; i++) {
      txnNumber += random.nextInt(10).toString();
    }

    // Format amount to have .00
    String displayAmount = amount;
    if (!displayAmount.contains('.')) {
      displayAmount = '$amount.00';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. TOP BUTTONS (Download & Share)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.download, color: Color(0xFF7CB342), size: 22),
                        SizedBox(width: 6),
                        Text('Download', style: TextStyle(color: Color(0xFF7CB342), fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.share, color: Color(0xFF7CB342), size: 22),
                        SizedBox(width: 6),
                        Text('Share', style: TextStyle(color: Color(0xFF7CB342), fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // 2. SUCCESS ICON
              const Icon(Icons.check_circle, color: Color(0xFF7CB342), size: 70),
              const SizedBox(height: 8),
              const Text(
                'Successful',
                style: TextStyle(color: Color(0xFF7CB342), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 45), 
              
              // 3. AMOUNT (WITH MINUS SIGN) - FONT REDUCED
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '-', 
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black87, height: 0.9),
                  ),
                  Text(
                    displayAmount,
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black87, height: 0.9),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '(ETB)',
                    style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              const Divider(thickness: 1, color: Color(0xFFEEEEEE), indent: 20, endIndent: 20),
              const SizedBox(height: 20),

              // 4. DETAILS - FONT SIZE REDUCED
              _buildDetailRow('Transaction Time:', timeString),
              _buildDetailRow('Transaction Type:', 'Transfer Money'),
              _buildDetailRow('Transaction To:', recipientName), 
              _buildDetailRow('Transaction Number:', txnNumber),
              
              const SizedBox(height: 10),
              
              // 5. QR CODE
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.qr_code, color: Color(0xFF7CB342), size: 26),
                    SizedBox(width: 6),
                    Text('QR Code', style: TextStyle(color: Color(0xFF7CB342), fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // 6. TELEPLAY BANNER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'images/teleplay.png',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        color: const Color(0xFF7CB342),
                        child: const Center(
                          child: Text('Upload teleplay.png to images', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // 7. DOTS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF7CB342), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // 8. FINISHED BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50), 
                child: SizedBox(
                  width: double.infinity,
                  height: 50, // Slightly smaller height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB342),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Finished', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for the rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Tighter spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[600])), // Reduced from 16
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500), // Reduced from 16
            ),
          ),
        ],
      ),
    );
  }
}
