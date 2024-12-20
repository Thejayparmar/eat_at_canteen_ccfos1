import 'package:flutter/material.dart';
import 'home_page.dart';  // Ensure you have this file created for navigation

// Stateful widget for the OTP verification page
class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = '';  // Variable to store the entered OTP
  final String correctOtp = "25017";  // Example OTP used for demonstration

  // Function to update OTP based on user input
  void _updateOtp(String value) {
    setState(() {
      if (value == '⌫') {
        // Remove last digit if backspace is pressed
        otp = otp.length > 0 ? otp.substring(0, otp.length - 1) : '';
      } else if (otp.length < 5) {  // Check OTP length (assumed to be 5)
        otp += value; // Add the new digit to OTP
      }
    });
  }

  // Function to create the numeric keypad (3x4 grid)
  Widget _numericPad() {
    return GridView.count(
      crossAxisCount: 3,  // Number of columns in the keypad grid (3 columns)
      padding: EdgeInsets.all(20),  // Padding around the grid
      mainAxisSpacing: 10,  // Vertical spacing between buttons
      crossAxisSpacing: 10,  // Horizontal spacing between buttons
      shrinkWrap: true,  // Allow keypad to take up only the required space (no extra scrolling)
      children: <String>[
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'
      ].map((key) {
        return GridTile(
          child: ElevatedButton(
            onPressed: () => _updateOtp(key),  // Call _updateOtp when a key is pressed
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200],  // Background color of the button
              shape: CircleBorder(),  // Circular button shape
              padding: EdgeInsets.all(20),  // Button padding
            ),
            child: Text(key, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify your phone number"),  // Title of the app bar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Center the children vertically
        children: <Widget>[
          // Instruction text for the user
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "We've sent an SMS with an activation code to your phone +91 8511496033",
              textAlign: TextAlign.center,  // Center the instruction text
              style: TextStyle(fontSize: 16),  // Set the text size
            ),
          ),
          SizedBox(height: 30),  // Space between text and OTP display

          // Display entered OTP digits as individual characters
          Row(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the OTP display
            children: otp.split('').map((e) => Padding(
              padding: const EdgeInsets.all(8.0),  // Space between OTP digits
              child: Text(e, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),  // Style for each OTP digit
            )).toList(),
          ),
          
          // Numeric keypad for entering OTP
          _numericPad(),

          // Button to verify OTP
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: otp.length == 5 && otp == correctOtp ? () {
                // If OTP is correct, navigate to HomePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),  // Replace with HomePage when OTP is correct
                );
              } : null,  // Disable button if OTP is not complete or incorrect
              child: Text('Verify'),  // Button text
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,  // Button background color
                onPrimary: Colors.white,  // Button text color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),  // Button padding
              ),
            ),
          ),
        ],
      ),
    );
  }
}
