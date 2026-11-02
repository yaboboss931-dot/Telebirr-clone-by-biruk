import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptScreen extends StatefulWidget {
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
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  void initState() {
    super.initState();
    // Triggers the fake notification on screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showFakeNotification(context);
      });
    });
  }

  // THIS IS THE NEW SMS DIALOG
  void _showSmsDialog() {
    final TextEditingController phoneController = TextEditingController();
    
    // The exact message you want
    String displayAmount = widget.amount;
    if (!displayAmount.contains('.')) {
      displayAmount = '${widget.amount}.00';
    }
    // You can change the masked number +2519597***40 below if you want
    String message = "Dear Customer you have received $displayAmount birr from +2519597***40 via tellebirr to your CBE ${widget.recipientName} thank you.";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Fake SMS'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Enter Friend\'s Phone Number',
              hintText: 'e.g. 0911223344',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (phoneController.text.isNotEmpty) {
                  Navigator.pop(context);
                  
                  // Launch the SMS app
                  final Uri smsLaunchUri = Uri(
                    scheme: 'sms',
                    path: phoneController.text.trim(),
                    queryParameters: <String, String>{
                      'body': Uri.encodeComponent(message),
                    },
                  );

                  if (!await launchUrl(smsLaunchUri)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open SMS app')),
                    );
                  }
                }
              },
              child: const Text('Open SMS App', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showFakeNotification(BuildContext context) {
    String displayAmount = widget.amount;
    if (!displayAmount.contains('.')) {
      displayAmount = '${widget.amount}.00';
    }

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: -150, end: 0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Telebirr',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You have successfully transferred -$displayAmount ETB to ${widget.recipientName}. Thank you for using Telebirr.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Timer(const Duration(seconds: 6), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeString = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String txnNumber = 'DHP';
    for (int i = 0; i < 5; i++) {
      txnNumber += chars[random.nextInt(chars.length)];
    }
    for (int i = 0; i < 3; i++) {
      txnNumber += random.nextInt(10).toString();
    }

    String displayAmount = widget.amount;
    if (!displayAmount.contains('.')) {
      displayAmount = '${widget.amount}.00';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
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
              
              const Icon(Icons.check_circle, color: Color(0xFF7CB342), size: 70),
              const SizedBox(height: 8),
              const Text(
                'Successful',
                style: TextStyle(color: Color(0xFF7CB342), fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 25), 
              
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
              
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 10),

              _buildDetailRow('Transaction Time:', timeString),
              _buildDetailRow('Transaction Type:', widget.transferType), 
              _buildDetailRow('Transaction To:', widget.recipientName), 
              _buildDetailRow('Transaction Number:', txnNumber),
              
              const SizedBox(height: 5),
              
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.qr_code, color: Color(0xFF7CB342), size: 24),
                  SizedBox(width: 6),
                  Text('QR Code', style: TextStyle(color: Color(0xFF7CB342), fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              
              const SizedBox(height: 15),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'images/banner-2.jpg', 
                  height: 100, 
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      color: const Color(0xFF7CB342),
                      child: const Center(
                        child: Text('Missing banner-2.jpg', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 10),
              
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
              
              const Spacer(),
              
              // SMS BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50, 
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800], 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: _showSmsDialog, // Opens the dialog to type the phone number
                    icon: const Icon(Icons.message, color: Colors.white, size: 20),
                    label: const Text('Send Fake SMS to Friend', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),

              // FINISHED BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50, 
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[600])), 
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500), 
            ),
          ),
        ],
      ),
    );
  }
}
