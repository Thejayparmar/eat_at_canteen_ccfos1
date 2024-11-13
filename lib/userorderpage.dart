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
    try {
      // Add the order to the 'orders' collection in Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': 'yourUserId',  // Replace with the actual user ID of the logged-in user
        'items': {
          'name': _itemController.text, // Capture item name from the text field
          'quantity': int.parse(_quantityController.text), // Parse quantity from the text field
        },
        'status': 'pending', // Set initial order status as 'pending'
        'timestamp': FieldValue.serverTimestamp(), // Record the order timestamp using Firestore's server time
      });

      // Clear the input fields after placing the order
      _itemController.clear();
      _quantityController.clear();

      // Show a confirmation message on successful order placement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!'))
      );
    } catch (e) {
      // In case of any error during order placement, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order. Please try again later.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place an Order'), // Title for the app bar
        backgroundColor: Colors.deepPurple, // Set app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(20), // Add padding around the form for better UI
        child: Form(
          child: Column(
            children: [
              // Input field for item name
              TextFormField(
                controller: _itemController, // Attach controller to capture input from the user
                decoration: InputDecoration(
                  labelText: 'Item Name', // Label for item name input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners for input field
                    borderSide: BorderSide(color: Colors.deepPurple), // Set border color to deep purple
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between the item name field and quantity field

              // Input field for quantity
              TextFormField(
                controller: _quantityController, // Attach controller for capturing quantity input
                decoration: InputDecoration(
                  labelText: 'Quantity', // Label for quantity input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners for input field
                    borderSide: BorderSide(color: Colors.deepPurple), // Set border color to deep purple
                  ),
                ),
                keyboardType: TextInputType.number, // Set keyboard to number input type for quantity
              ),
              SizedBox(height: 30), // Space before the submit button

              // Button to submit the order
              ElevatedButton(
                onPressed: placeOrder, // Call placeOrder function when button is pressed
                child: Text('Place Order'), // Button text displayed on the button
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Button background color
                  onPrimary: Colors.white, // Button text color
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
