import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database operations

/// EntryPage class provides a form to input user data and submit it to Firestore.
class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _nameController = TextEditingController(); // Controller for name input
  final TextEditingController _ageController = TextEditingController(); // Controller for age input

  bool _isLoading = false; // Flag to show loading spinner while submitting data

  /// Function to validate and submit data to Firestore
  Future<void> _submitData() async {
    // Check if form validation passes
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      try {
        // Add the data to Firestore collection 'jay' with fields 'name', 'age', and a timestamp
        await FirebaseFirestore.instance.collection('jay').add({
          'name': _nameController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'timestamp': FieldValue.serverTimestamp(), // Add timestamp for ordering or tracking
        });

        // Show success message on successful submission
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data submitted successfully!'),
        ));

        // Clear form fields after successful submission
        _nameController.clear();
        _ageController.clear();
      } catch (e) {
        // Handle any errors and show failure message
        print("Error adding data: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit data. Please try again.'),
        ));
      } finally {
        setState(() {
          _isLoading = false; // Hide loading spinner after submission attempt
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title and styling for the app bar
        title: Text('Add User Data'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Form widget for data entry and validation
        child: Form(
          key: _formKey, // Form validation key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text field for entering the user's name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  // Validate name field is not empty
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Spacing between fields

              // Text field for entering the user's age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number, // Specify numeric input
                validator: (value) {
                  // Validate age field is not empty and is a valid number
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32), // Spacing before submit button

              // Centered button to submit data
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData, // Disable button while loading
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Submit'), // Display 'Submit' or loading spinner
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, // Button color
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0), // Button padding
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
