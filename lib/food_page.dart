import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve food details passed via navigation arguments
    final Map<String, dynamic> foodDetails = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      // AppBar displaying the title 'Food Details'
      appBar: AppBar(
        title: Text('Food Details'),
        backgroundColor: Colors.redAccent, // Set the AppBar color to red accent
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: <Widget>[
            // Display food name
            Text(
              'Name: ${foodDetails['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Display food type
            Text(
              'Type: ${foodDetails['type']}',
              style: TextStyle(fontSize: 20),
            ),
            // Display food price with a dollar sign
            Text(
              'Price: \$${foodDetails['price']}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to build a product card with the food item details
Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
  return Card(
    color: Colors.purple.shade100, // Set the card background color to light purple
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
    ),
    margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin between cards
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Padding inside the card
      child: Row(
        children: [
          // Display food image (icon or image from assets)
          Image.asset(
            imagePath,
            height: 60.0, // Set image height
            width: 60.0,  // Set image width
          ),
          SizedBox(width: 16.0), // Add space between image and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              // Display food title in bold and larger font
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              // Display food type
              Text(
                'TYPE: $type',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white, // White text color for type
                ),
              ),
              // Display food price
              Text(
                'PRICE: $price',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white, // White text color for price
                ),
              ),
            ],
          ),
          Spacer(), // Add space between the text and the button
          // Elevated button to initiate a buy action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Set button color to black
            ),
            onPressed: () {
              // Add your buy action here (e.g., navigating to a checkout page or adding to cart)
            },
            child: Text('BUY'), // Button text
          ),
        ],
      ),
    ),
  );
}
