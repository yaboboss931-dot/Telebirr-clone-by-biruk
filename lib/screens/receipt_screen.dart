import 'dart:math';
import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final String recipientName;
  final String amount;
  final String transactionType;

  const ReceiptScreen({
    super.key, 
    required this.recipientName, 
    required this.amount, 
    required this.transactionType
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.green),
            label: const Text('Download', style: TextStyle(color: Colors.green, fontSize: 16)),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.green),
            label: const Text('Share', style: TextStyle(color: Colors.green, fontSize: 16)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle, color: Color(0xFF7CB342), size: 75),
            const SizedBox(height: 10),
            const Text(
              'Successful',
              style: TextStyle(color: Color(0xFF7CB342), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayAmount,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87, height: 1),
                ),
                const SizedBox(width: 5),
                const Text(
                  '(ETB)',
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE), indent: 20, endIndent: 20),
            const SizedBox(height: 20),

            _buildDetailRow('Transaction Time:', timeString),
            _buildDetailRow('Transaction Type:', 'Transfer Money'),
            _buildDetailRow('Transaction To:', recipientName), // Shows your custom name
            _buildDetailRow('Transaction Number:', txnNumber),
            
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.qr_code, color: Colors.green, size: 24),
                  SizedBox(width: 5),
                  Text('QR Code', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            // TELEPLAY BANNER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://raw.githubusercontent.com/birukbr7/Telebirr-clone-by-biruk/main/images/teleplay.png', 
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: const Color(0xFF7CB342),
                      child: const Center(
                        child: Text('Teleplay Banner', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // FINISHED BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CB342),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Finished', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.black54)),
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
