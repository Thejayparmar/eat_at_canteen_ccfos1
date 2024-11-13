import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String paymentId;
  final String transactionId;
  final String eventName;
  final double eventFee;
  final String paymentStatus;

  const PaymentSuccessPage({
    Key? key,
    required this.paymentId,
    required this.transactionId,
    required this.eventName,
    required this.eventFee,
    required this.paymentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Success"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thank you for registering!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Event: $eventName"),
            Text("Fee: ₹${eventFee.toStringAsFixed(2)}"),
            Text("Payment Status: $paymentStatus"),
            if (paymentStatus == 'Paid') ...[
              Text("Payment ID: $paymentId"),
              Text("Transaction ID: $transactionId"),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
