import 'package:flutter/material.dart';
import 'receipt_screen.dart';

class TransferInputScreen extends StatefulWidget {
  final String transferType;

  const TransferInputScreen({super.key, required this.transferType});

  @override
  State<TransferInputScreen> createState() => _TransferInputScreenState();
}

class _TransferInputScreenState extends State<TransferInputScreen> {
  final TextEditingController phoneController = TextEditingController();

  void showAmountDialog() {
    final TextEditingController amountController = TextEditingController();
    
    // Check if they typed a name or number
    String nameOrNumber = phoneController.text.trim();
    if (nameOrNumber.isEmpty || nameOrNumber == '+251') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a mobile number or name')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Amount (Prank)'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (ETB)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptScreen(
                        recipientName: nameOrNumber,
                        amount: amountController.text,
                        transactionType: widget.transferType,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Generate Receipt', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money to Individual',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. The Banner Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[900], // Fallback color
                  image: const DecorationImage(
                    // Using a generic online image that looks like a banner
                    image: NetworkImage('https://raw.githubusercontent.com/birukbr7/Telebirr-clone-by-biruk/main/images/banner.jpg'), 
                    fit: BoxFit.cover,
                  ),
                ),
                // If the image fails to load, it will show this text
                child: const Center(
                  child: Text(
                    'Link your telebirr\nwith FAYDA',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // 2. Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // 3. The White Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please Enter Mobile Number',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    
                    // Text Field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+251',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 2),
                        ),
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.green),
                            SizedBox(width: 10),
                            Icon(Icons.contact_page, color: Colors.green),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue[100], // Identical to screenshot
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: showAmountDialog, // Opens our secret amount popup
                        child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Recent Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 50),
                    Center(
                      child: Column(
                        children: [
                          // Fake Icon for "No recent receiver"
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.check, size: 50, color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
                                child: const Icon(Icons.priority_high, size: 20, color: Colors.white),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text('No recent receiver', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
