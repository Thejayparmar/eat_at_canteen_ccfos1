import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orderstatepage.dart';

// RKMainCampus class represents the main campus with a list of canteens
class RKMainCampus extends StatelessWidget {
  // List of canteens, each with a name and an image path
  final List<Map<String, dynamic>> canteens = [
    {'name': 'Main Canteen', 'image': 'assets/images/main_canteen.png'},
    {'name': 'South-Ind Canteen', 'image': 'assets/images/south_ind_canteen.png'},
    {'name': 'Canteen', 'image': 'assets/images/canteen.png'},
    {'name': 'NP Food Zone', 'image': 'assets/images/np_food_zone.png'},
    {'name': 'Tea-post Canteen', 'image': 'assets/images/tea_post_canteen.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RKU Main Campus Canteens'), // App bar title
        centerTitle: true,
        backgroundColor: Colors.purple, // App bar background color
      ),
      body: ListView.builder(
        itemCount: canteens.length, // Number of canteen items
        itemBuilder: (context, index) {
          // Build each item in the list
          return Card(
            margin: EdgeInsets.all(8), // Margin around each card
            child: ListTile(
              title: Text(canteens[index]['name']), // Display canteen name
              leading: _buildCanteenImage(canteens[index]['image']), // Display canteen image
              onTap: () {
                // Navigate to DetailPage1 on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage1(canteen: canteens[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Widget to display canteen image with error handling
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!')); // Displayed if image is not found
      },
    );
  }
}

// DetailPage1 class displays details of a specific canteen and its products
class DetailPage1 extends StatelessWidget {
  final Map<String, dynamic> canteen; // Data for the selected canteen

  DetailPage1({required this.canteen}); // Constructor with canteen parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(canteen['name']), // Title with canteen name
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _buildCanteenImage(canteen['image']), // Display canteen image
          _buildProductCard(
            context,
            'Burger', // Product name
            'Fast Food', // Product type
            '100', // Product price
          ),
          _buildProductCard(
            context,
            'Pizza', // Product name
            'Italian', // Product type
            '200', // Product price
          ),
        ],
      ),
    );
  }

  // Widget to display the canteen image with error handling
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 200,
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!')); // Displayed if image is not found
      },
    );
  }

  // Method to build a product card with buy functionality
  Widget _buildProductCard(BuildContext context, String title, String type, String price) {
    return Card(
      color: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Card corners
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin for card
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 16.0), // Left padding for the content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Product title
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'TYPE: $type', // Display product type
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'PRICE: $price', // Display product price
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(), // Spacer to push the button to the end of the row
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Button color
              ),
              onPressed: () async {
                try {
                  // Add product to Firestore with the provided details
                  await FirebaseFirestore.instance.collection('orders').add({
                    'title': title,
                    'type': type,
                    'price': price,
                    'canteen_name': canteen['name'],
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Show confirmation message on successful order
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Order of $title is placed Successfully',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    backgroundColor: Colors.green, // Green background for success
                  ));

                  // Delay to allow message display before navigation
                  await Future.delayed(Duration(seconds: 2));

                  // Navigate to OrderStatusPage after placing order
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusPage(), // Navigate to order status page
                    ),
                  );

                } catch (e) {
                  // Show error message if order fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add product: $e'), // Display error message
                  ));
                  print('Error adding product to Firestore: $e'); // Log error to console
                }
              },
              child: Text('BUY'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
