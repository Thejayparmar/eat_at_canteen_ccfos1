import 'package:flutter/material.dart';
import 'PageNumber1.dart';  // Importing the PageNumber1 widget for navigation (ensure the path is correct)

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'), // Title of the Home Page
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align the children in the center vertically
          children: <Widget>[
            // Display logo image
            Image.asset('assets/images/logo.png'), // Logo added here
            SizedBox(height: 20), // Adds vertical space between the logo and the text
            // Welcome message
            Text(
              'Welcome to Eat at Canteen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Adds space between the welcome text and the button
            // ElevatedButton to navigate to the next page
            ElevatedButton(
              onPressed: () {
                // Navigate to PageNumber1 when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageNumber1()), // Navigate to PageNumber1 widget
                );
              },
              child: Text('Explore Menu'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}

// Function to build a product card displaying the food item details
Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
  return Card(
    color: Colors.purple.shade100, // Set card color to purple shade
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
    ),
    margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin between cards
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Padding inside the card
      child: Row(
        children: [
          // Display food image
          Image.asset(
            imagePath,
            height: 60.0, // Set image height
            width: 60.0,  // Set image width
          ),
          SizedBox(width: 16.0), // Space between image and the text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              // Title of the food item
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold, // Bold title text
                  color: Colors.white, // White text color
                ),
              ),
              // Food type
              Text(
                'TYPE: $type',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white, // White text color for type
                ),
              ),
              // Food price
              Text(
                'PRICE: $price',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white, // White text color for price
                ),
              ),
            ],
          ),
          Spacer(), // Adds flexible space between the text and the button
          // Elevated button for "BUY" action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button color to black
            ),
            onPressed: () {
              // Add your buy action here (e.g., navigate to cart or checkout)
            },
            child: Text('BUY'), // Button text
          ),
        ],
      ),
    ),
  );
}
