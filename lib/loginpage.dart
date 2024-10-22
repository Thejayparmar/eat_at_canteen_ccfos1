import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  String errorMessage = '';
  String _selectedRole = 'user';

  // Function to navigate to either home or admin page based on selected role
  void navigateToPage() {
    if (_selectedRole == 'user') {
      Navigator.pushReplacementNamed(context, '/homepage');
    } else if (_selectedRole == 'admin') {
      Navigator.pushReplacementNamed(context, '/adminpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                    ),
                    onPressed: navigateToPage, // Bypassing OTP and navigating directly
                    child: Text('Continue'),
                  ),
                ),
              ],
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Login as',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'user',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value.toString();
                    });
                  },
                  activeColor: Colors.purple,
                ),
                Text('User'),
                SizedBox(width: 30),
                Radio(
                  value: 'admin',
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value.toString();
                    });
                  },
                  activeColor: Colors.purple,
                ),
                Text('Admin'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
