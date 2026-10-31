import 'package:flutter/material.dart';
import 'receipt_screen.dart';

class TransferInputScreen extends StatefulWidget {
  final String transferType; // <--- THIS FIXES THE ERROR

  const TransferInputScreen({super.key, required this.transferType}); // <--- AND THIS

  @override
  State<TransferInputScreen> createState() => _TransferInputScreenState();
}

class _TransferInputScreenState extends State<TransferInputScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transferType),
        backgroundColor: const Color.fromRGBO(140, 199, 63, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Recipient Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (ETB)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(140, 199, 63, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptScreen(
                          recipientName: nameController.text,
                          amount: amountController.text,
                          transactionType: widget.transferType,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields!')),
                    );
                  }
                },
                child: const Text('Send', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
