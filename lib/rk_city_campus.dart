import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orderstatepage.dart';

// Main class representing the RK City Campus with a list of canteens
class RKCityCampus extends StatelessWidget {
  // List of canteens with their names and images
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
        backgroundColor: Colors.purple, // Background color of the app bar
      ),
      body: ListView.builder(
        itemCount: canteens.length, // Number of canteens to display
        itemBuilder: (context, index) {
          // Building each item in the list
          return Card(
            margin: EdgeInsets.all(8), // Margin around each card
            child: ListTile(
              title: Text(canteens[index]['name']), // Canteen name
              leading: _buildCanteenImage(canteens[index]['image']), // Canteen image
              onTap: () {
                // On tapping a canteen, navigate to DetailPage1
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

  // Method to display canteen image or a placeholder if the image is not found
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!')); // Placeholder text
      },
    );
  }
}

// Detail page class for displaying specific canteen details
class DetailPage1 extends StatelessWidget {
  final Map<String, dynamic> canteen; // Data for the selected canteen

  DetailPage1({required this.canteen}); // Constructor with required canteen parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(canteen['name']), // Title of the app bar with canteen name
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _buildCanteenImage(canteen['image']), // Display canteen image
          _buildProductCard(
            context,
            'Burger', // Product title
            'Fast Food', // Product type
            '100', // Product price
          ),
          _buildProductCard(
            context,
            'Pizza', // Product title
            'Italian', // Product type
            '200', // Product price
          ),
        ],
      ),
    );
  }

  // Method to display canteen image with a placeholder if the image is not found
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 200,
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!')); // Placeholder text
      },
    );
  }

  // Method to build a card for each product with buy functionality
  Widget _buildProductCard(BuildContext context, String title, String type, String price) {
    return Card(
      color: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 16.0), // Spacing on the left side
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
                  'TYPE: $type', // Product type
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'PRICE: $price', // Product price
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(), // Spacer to push the button to the right
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Button color
              ),
              onPressed: () async {
                try {
                  // Add the product order to Firestore database
                  await FirebaseFirestore.instance.collection('orders').add({
                    'title': title,
                    'type': type,
                    'price': price,
                    'canteen_name': canteen['name'],
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Show confirmation message on successful order placement
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Order of $title is placed Successfully',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    backgroundColor: Colors.green, // Set background color to green
                  ));

                  // Wait for a few seconds to display the SnackBar
                  await Future.delayed(Duration(seconds: 2));

                  // Navigate to OrderStatusPage after delay
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusPage(), // Navigate to order status page
                    ),
                  );

                } catch (e) {
                  // Show error message on failure to add product
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add product: $e'),
                  ));
                  print('Error adding product to Firestore: $e'); // Log error
                }
              },
              child: Text('BUY'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
