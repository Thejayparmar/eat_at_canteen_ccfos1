import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:async';

class PaymentPage extends StatefulWidget {
  final String eventTitle;
  final String email;
  final String phone;

  PaymentPage({required this.eventTitle, required this.email, required this.phone});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    _startPayment();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_QNT17rACVasLYF',
      'amount': 50000, // Amount in paise
      'name': widget.eventTitle,
      'description': 'Event Registration Payment',
      'prefill': {
        'contact': widget.phone,
        'email': widget.email,
      },
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // You can access paymentId, orderId, signature directly from the response here.
    setState(() {
      _isProcessing = false;
    });

    // Show a success message or navigate accordingly
    Navigator.pop(context, true); // Handle successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessing = false;
    });
    Navigator.pop(context, false); // Handle payment error
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Payment'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  SizedBox(height: 20),
                  Text('Processing payment...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 80),
                  SizedBox(height: 20),
                  Text('Payment Successful!'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text('Return to Home'),
                  ),
                ],
              ),
      ),
    );
  }
}
