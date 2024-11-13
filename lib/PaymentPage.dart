import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay package for payments
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast for displaying toast messages

/// PaymentPage class that provides a UI to initiate a payment process
class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay; // Define Razorpay instance

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay(); // Initialize Razorpay instance
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess); // Listen for payment success
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError); // Listen for payment error
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet); // Listen for external wallet selection
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Clear Razorpay instance on dispose to prevent memory leaks
  }

  /// Handle successful payment event
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Success: ${response.paymentId}", // Display payment success toast with payment ID
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  /// Handle payment error event
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.code} - ${response.message}", // Display payment failure toast with error code and message
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  /// Handle external wallet event
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName}", // Display toast with external wallet name
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  /// Open Razorpay checkout with payment options
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_x8tV5oSUixLmbV',  // Razorpay API Key for authentication
      'amount': 100,  // Payment amount in smallest currency unit (e.g., 100 paise = 1 INR)
      'name': 'Your Company Name', // Displayed company name on Razorpay checkout
      'description': 'Payment for the order', // Payment description
      'prefill': {
        'contact': '8888888888', // Pre-filled contact number
        'email': 'test@example.com' // Pre-filled email address
      },
      'external': {
        'wallets': ['paytm'] // Allow payments through specified wallets (e.g., Paytm)
      }
    };

    try {
      _razorpay.open(options); // Open Razorpay checkout with specified options
    } catch (e) {
      print(e.toString()); // Handle any errors by printing the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'), // Title for AppBar
        backgroundColor: Colors.blueAccent, // Set AppBar background color
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openCheckout(); // Initiate payment on button press
          },
          child: Text('Pay Now'), // Button label
        ),
      ),
    );
  }
}
