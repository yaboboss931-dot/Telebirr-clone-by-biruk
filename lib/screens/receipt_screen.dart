import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final String recipientName;
  final String amount;

  const ReceiptScreen({super.key, required this.recipientName, required this.amount});

  @override
  Widget build(BuildContext context) {
    // Generate current time
    final now = DateTime.now();
    final timeString = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    // Generate a random Transaction Number
    final txnNumber = "DHP${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hides the back button so they can't escape easily lol
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.green),
            label: const Text('Download', style: TextStyle(color: Colors.green)),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.green),
            label: const Text('Share', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 10),
            const Text('Successful', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            // AMOUNT
            Text(
              '$amount (ETB)',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),

            // DETAILS
            _buildDetailRow('Transaction Time:', timeString),
            _buildDetailRow('Transaction Type:', 'Transfer Money'),
            _buildDetailRow('Transaction To:', recipientName),
            _buildDetailRow('Transaction Number:', txnNumber),
            
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.qr_code, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text('QR Code', style: TextStyle(color: Colors.green, fontSize: 16)),
                SizedBox(width: 20),
              ],
            ),
            
            const SizedBox(height: 30),
            // Fake Ad Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage('https://github.com/birukbr7/Telebirr-clone-by-biruk/blob/main/images/teleplay.png?raw=true'), // Using the image from the repo if it exists
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            // FINISHED BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // This sends them back to the home screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Finished', style: TextStyle(fontSize: 18, color: Colors.white)),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
