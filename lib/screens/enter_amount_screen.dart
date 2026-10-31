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
      // MAGIC: We use PageRouteBuilder with opaque: false to make it transparent
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false, 
          pageBuilder: (context, _, __) => LoadingScreen(
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.amber, 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipientName, 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.phoneNumber, 
                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 2. White Container for Amount and Notes
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Amount Row
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
                          autofocus: true, 
                          textAlign: TextAlign.right,
                          textInputAction: TextInputAction.done, 
                          onSubmitted: (value) => proceedToLoading(),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: '', 
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // The Vertical Line + (ETB)
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '(ETB)',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                
                // Notes Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Add notes(optional)',
                      hintStyle: TextStyle(color: Color(0xFF78909C), fontSize: 15), 
                    ),
                  ),
                ),
                
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),
              ],
            ),
          ),
          
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Icon(
              Icons.keyboard_arrow_down, 
              color: Colors.grey[400],
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
