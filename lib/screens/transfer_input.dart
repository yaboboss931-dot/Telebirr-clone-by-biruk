import 'package:flutter/material.dart';
import 'loading_screen.dart'; // <--- THIS IS NEW!

class TransferInputScreen extends StatefulWidget {
  final String transferType;

  const TransferInputScreen({super.key, required this.transferType});

  @override
  State<TransferInputScreen> createState() => _TransferInputScreenState();
}

class _TransferInputScreenState extends State<TransferInputScreen> {
  final TextEditingController phoneController = TextEditingController();

  // This is the secret popup for your prank!
  void showAmountDialog() {
    final TextEditingController amountController = TextEditingController();
    
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
                  Navigator.pop(context); // Close popup
                  
                  // GO TO THE LOADING SCREEN INSTEAD OF RECEIPT
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. YOUR BANNER IMAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'images/banner.jpg', // Make sure this file is uploaded!
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Banner Image Not Found')),
                  ),
                ),
              ),
            ),

            // 2. Dots Indicator below banner
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please Enter Mobile Number',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    
                    // Text Field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: '+251',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green, width: 1.5),
                        ),
                        // Exact icons from the picture
                        suffixIcon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.green, size: 28),
                            SizedBox(width: 15),
                            Icon(Icons.contact_page, color: Colors.green, size: 28),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB3E5FC), // Exact light blue from picture
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: showAmountDialog, // Opens the secret amount popup
                        child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 4. Recent Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent', style: TextStyle(fontSize: 18, color: Colors.black87)),
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        children: [
                          // Recreating the exact graphic from the picture
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // The 3D green box effect
                              Container(
                                margin: const EdgeInsets.only(right: 6, bottom: 6),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7CB342), // Darker green for shadow
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8BC34A), // Light green for front
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.check, size: 45, color: Colors.white),
                              ),
                              // The Yellow Circle with > <
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Text(
                                  '> <',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: -2),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text('No recent receiver', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
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
