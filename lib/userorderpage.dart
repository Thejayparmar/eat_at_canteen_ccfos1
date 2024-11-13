import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Stateful widget to allow dynamic interactions like placing orders
class UserOrderPage extends StatefulWidget {
  @override
  _UserOrderPageState createState() => _UserOrderPageState();
}

class _UserOrderPageState extends State<UserOrderPage> {
  // Controllers to capture input for item name and quantity
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Function to place an order by adding data to Firestore
  Future<void> placeOrder() async {
    // Add the order to the 'orders' collection in Firestore
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': 'yourUserId',  // Replace with the actual user ID of the logged-in user
      'items': {
        'name': _itemController.text, // Capture item name
        'quantity': int.parse(_quantityController.text), // Parse quantity as integer
      },
      'status': 'pending', // Set initial status as 'pending'
      'timestamp': FieldValue.serverTimestamp(), // Record the order timestamp
    });

    // Clear the input fields after placing the order
    _itemController.clear();
    _quantityController.clear();

    // Show a confirmation message on successful order placement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place an Order'), // Title for the app bar
        backgroundColor: Colors.deepPurple, // Set app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(20), // Add padding around the form
        child: Form(
          child: Column(
            children: [
              // Input field for item name
              TextFormField(
                controller: _itemController, // Attach controller to capture input
                decoration: InputDecoration(
                  labelText: 'Item Name', // Label for item name field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded border
                    borderSide: BorderSide(color: Colors.deepPurple), // Border color
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between fields

              // Input field for quantity
              TextFormField(
                controller: _quantityController, // Attach controller for quantity input
                decoration: InputDecoration(
                  labelText: 'Quantity', // Label for quantity field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded border
                    borderSide: BorderSide(color: Colors.deepPurple), // Border color
                  ),
                ),
                keyboardType: TextInputType.number, // Keyboard type for numeric input
              ),
              SizedBox(height: 30), // Space before the button

              // Button to submit the order
              ElevatedButton(
                onPressed: placeOrder, // Call placeOrder function when pressed
                child: Text('Place Order'), // Button text
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Button color
                  onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
