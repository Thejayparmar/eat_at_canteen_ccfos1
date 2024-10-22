import 'package:flutter/material.dart';
import 'home_page.dart';  // Make sure you have this file created

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = '';
  final String correctOtp = "25017";  // Example OTP for demonstration

  void _updateOtp(String value) {
    setState(() {
      if (value == '⌫') {
        otp = otp.length > 0 ? otp.substring(0, otp.length - 1) : '';
      } else if (otp.length < 5) {  // Assuming OTP length is 5
        otp += value;
      }
    });
  }

  Widget _numericPad() {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(20),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      children: <String>[
        '1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'
      ].map((key) {
        return GridTile(
          child: ElevatedButton(
            onPressed: () => _updateOtp(key),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200], // Background color
              shape: CircleBorder(),
              padding: EdgeInsets.all(20)
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
        title: Text("Verify your phone number"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("We've sent an SMS with an activation code to your phone +91 8511496033",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: otp.split('').map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
          _numericPad(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: otp.length == 5 && otp == correctOtp ? () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage when the OTP is correct
                );
              } : null,
              child: Text('Verify'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
