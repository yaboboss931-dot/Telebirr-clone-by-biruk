import 'package:flutter/material.dart';
import 'loading_screen.dart';

class EnterAmountScreen extends StatefulWidget {
  final String recipientName;
  final String phoneNumber;
  final String transferType;

  const EnterAmountScreen({
    super.key, 
    required this.recipientName, 
    required this.phoneNumber, 
    required this.transferType
  });

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void proceedToLoading() {
    if (amountController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            recipientName: widget.recipientName,
            amount: amountController.text,
            transactionType: widget.transferType,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // 1. Recipient Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.amber, // Yellow background
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamawit', // Matches your screenshot
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '251${widget.phoneNumber}', // Uses the number typed in the first screen
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          
          // 2. Amount Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true, // Opens keyboard immediately
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (value) => proceedToLoading(), // Hitting 'OK' on keyboard sends
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  '(ETB)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          
          // 3. Notes Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: TextField(
              controller: notesController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add notes(optional)',
                hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15),
              ),
            ),
          ),

          const Spacer(), // Pushes the button to the bottom
          
          // 4. Submit Button (In case they close the keyboard)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088FF), // Solid blue
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: proceedToLoading,
                child: const Text('Send', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
