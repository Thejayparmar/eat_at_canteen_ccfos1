import 'package:flutter/material.dart';

/// AdminHomePage is a StatefulWidget that provides an interface for an admin 
/// to enter details of a food item (name, type, and price) and submit them. 
/// The details are then passed to another screen via navigation.

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Controllers for the text fields to manage user inputs.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  /// _handleSubmit is called when the 'Submit' button is pressed.
  /// It collects the values from the text fields, stores them in a map
  /// (`foodDetails`), and navigates to the '/food' route while passing
  /// the food details as arguments.
  /// After navigation, it clears the input fields by calling `_clearInputs`.
  void _handleSubmit() {
    final foodDetails = {
      'name': _nameController.text,
      'type': _typeController.text,
      'price': _priceController.text,
    };
    Navigator.pushNamed(context, '/food', arguments: foodDetails);
    _clearInputs();
  }

  /// Clears the values in the input fields.
  void _clearInputs() {
    _nameController.clear();
    _typeController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar title is clickable and navigates to '/shopOwner' when tapped.
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/shopOwner'),
          child: Text('Shop Owner Detail', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            // Logout icon button navigates to '/food'.
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushNamed(context, '/food'),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        // Body of the page contains input fields for name, type, and price of a food item.
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // TextField to enter the name of the food item.
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Enter Name'),
              ),
              // TextField to enter the type of the food item.
              TextField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Enter Type'),
              ),
              // TextField to enter the price of the food item, with numeric keyboard input.
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Price'),
              ),
              SizedBox(height: 20),
              // Submit button that triggers the _handleSubmit function.
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
