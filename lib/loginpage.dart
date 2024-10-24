import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'adminpage.dart'; // Import admin page
import 'home_page.dart'; // Import home page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController(); // Controller for phone number input
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  String errorMessage = '';
  String selectedRole = 'User'; // Default role is "User"
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to save phone number to Firestore
  void _savePhoneNumberToFirestore(String phoneNumber) async {
    try {
      // Add the phone number and role to the 'users' collection
      await _firestore.collection('users').add({
        'phoneNumber': phoneNumber,
        'role': selectedRole, // Save the selected role (Admin/User)
      });
      setState(() {
        errorMessage = 'Phone number saved successfully';
      });
    } catch (e) {
      // Display error message if any issue occurs
      setState(() {
        errorMessage = 'Failed to save number: ${e.toString()}';
      });
    }
  }

  // Function to handle form submission
  void _submit() {
    String phoneNumber = '+91${phoneController.text.trim()}'; // Assuming Indian country code (+91)

    if (phoneController.text.length == 10) {
      _savePhoneNumberToFirestore(phoneNumber); // Save phone number to Firestore

      // Redirect based on the selected role
      if (selectedRole == 'Admin') {
        // Redirect to AdminPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (selectedRole == 'User') {
        // Redirect to HomePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      setState(() {
        errorMessage = 'Enter a valid 10-digit phone number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Colors.purple, // Theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation, // Adding fade animation to the entire body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Phone Number Input with Icon
              TextField(
                controller: phoneController, // Controller to get phone number input
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon: Icon(Icons.phone, color: Colors.purple), // Phone icon
                  filled: true,
                  fillColor: Colors.purple.shade50, // Light purple background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              // Dropdown Menu with Padding and Decoration
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50, // Light purple background for dropdown
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purpleAccent, width: 1), // Purple border
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: <String>['Admin', 'User']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Submit Button with Elevated Style and Shadow
              ElevatedButton(
                onPressed: _submit, // Handle submission
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8, // Adds shadow for a 3D effect
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
                ),
                child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              if (errorMessage.isNotEmpty) // Display any error message
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: errorMessage.contains('successfully') ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
