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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance to interact with Firestore
  String errorMessage = ''; // Variable to hold error messages
  String selectedRole = 'User'; // Default selected role is "User"
  
  late AnimationController _animationController; // Animation controller for fade-in effect
  late Animation<double> _animation; // Animation to control opacity

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
    _animationController.forward(); // Start the animation immediately
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of the animation controller to avoid memory leaks
    super.dispose();
  }

  // Function to save the phone number to Firestore
  void _savePhoneNumberToFirestore(String phoneNumber) async {
    try {
      // Add the phone number and role to the 'users' collection in Firestore
      await _firestore.collection('users').add({
        'phoneNumber': phoneNumber, // Save the phone number
        'role': selectedRole, // Save the selected role (Admin/User)
      });
      setState(() {
        errorMessage = 'Phone number saved successfully'; // Show success message
      });
    } catch (e) {
      // Display error message if there's an issue with saving data to Firestore
      setState(() {
        errorMessage = 'Failed to save number: ${e.toString()}';
      });
    }
  }

  // Function to handle form submission
  void _submit() {
    String phoneNumber = '+91${phoneController.text.trim()}'; // Format the phone number with Indian country code

    // Check if the phone number is valid (10 digits)
    if (phoneController.text.length == 10) {
      _savePhoneNumberToFirestore(phoneNumber); // Save phone number to Firestore

      // Redirect based on the selected role
      if (selectedRole == 'Admin') {
        // Redirect to AdminPage if the role is Admin
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (selectedRole == 'User') {
        // Redirect to HomePage if the role is User
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      // If the phone number is not valid, show an error message
      setState(() {
        errorMessage = 'Enter a valid 10-digit phone number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'), // Title for the app bar
        backgroundColor: Colors.purple, // Theme color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the body content
        child: FadeTransition(
          opacity: _animation, // Adding fade animation to the entire body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              Text(
                'Enter your phone number', // Instructional text
                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Spacer between elements

              // Phone Number Input Field
              TextField(
                controller: phoneController, // Controller to capture phone number input
                decoration: InputDecoration(
                  hintText: 'Phone number', // Hint text when the field is empty
                  prefixIcon: Icon(Icons.phone, color: Colors.purple), // Phone icon inside the input field
                  filled: true,
                  fillColor: Colors.purple.shade50, // Light purple background for the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners for the input field
                    borderSide: BorderSide.none, // No border around the input field
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding inside the input field
                ),
                keyboardType: TextInputType.phone, // Use phone-specific keyboard
              ),
              SizedBox(height: 20), // Spacer between elements

              // Dropdown for selecting role (Admin/User)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50, // Light purple background for dropdown
                  borderRadius: BorderRadius.circular(12), // Rounded corners for the dropdown
                  border: Border.all(color: Colors.purpleAccent, width: 1), // Purple border around dropdown
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole, // Current selected role
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!; // Update the selected role when changed
                      });
                    },
                    items: <String>['Admin', 'User'] // List of available roles
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30), // Spacer before the submit button

              // Submit Button
              ElevatedButton(
                onPressed: _submit, // Handle form submission when pressed
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners for the button
                  ),
                  elevation: 8, // Shadow effect for a 3D look
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0), // Padding for the button
                ),
                child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18)), // Button text
              ),
              if (errorMessage.isNotEmpty) // Show error message if there is any
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage, // Display the error message or success message
                    style: TextStyle(
                      color: errorMessage.contains('successfully') ? Colors.green : Colors.red, // Green for success, red for error
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
