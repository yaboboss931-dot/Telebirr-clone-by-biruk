import 'package:flutter/material.dart';
import 'loading_screen.dart'; 

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
                  Navigator.pop(context); 
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
      backgroundColor: const Color(0xFFF5F5F5), 
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
            // 1. THE BANNER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'images/banner.jpg', 
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 110,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Check images folder for banner.jpg')),
                  ),
                ),
              ),
            ),

            // 2. Dots Indicator 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 7, height: 7, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
              ],
            ),
            
            const SizedBox(height: 15),

            // 3. THE WHITE CARD
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
                    
                    // TEXT FIELD
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 18, color: Colors.black), // Solid black text
                      decoration: InputDecoration(
                        hintText: '+251',
                        hintStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                        // Larger, spaced out icons
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.qr_code_scanner, color: Color(0xFF7CB342), size: 32),
                              SizedBox(width: 15),
                              Icon(Icons.contact_page, color: Color(0xFF7CB342), size: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // NEXT BUTTON (Solid Blue like your picture)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088FF), // Bright solid blue
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: showAmountDialog, 
                        child: const Text('Next', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. RECENT SECTION (The exact icon you want)
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
                          // The 3D Green Box with Yellow Face
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // The shadow
                              Container(
                                margin: const EdgeInsets.only(right: 6, bottom: 6),
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF689F38), // Dark green shadow
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // The main green box
                              Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8BC34A), // Light green
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.check, size: 50, color: Colors.white),
                              ),
                              // The Yellow Face Circle
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.close, size: 10, color: Colors.black),
                                        SizedBox(width: 6),
                                        Icon(Icons.close, size: 10, color: Colors.black),
                                      ],
                                    ),
                                    Container(
                                      width: 14,
                                      height: 2,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text('No recent receiver', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
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
