import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orderstatepage.dart';  // Importing OrderStatusPage for navigation

// Main class representing the RK City Campus with a list of canteens
class RKCityCampus extends StatelessWidget {
  // List of canteens with their names and image file paths
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
        title: Text('RKU Main Campus Canteens'),  // App bar title
        centerTitle: true,  // Centers the title in the app bar
        backgroundColor: Colors.purple,  // Sets the background color of the app bar
      ),
      body: ListView.builder(
        itemCount: canteens.length,  // Number of canteens to display in the list
        itemBuilder: (context, index) {
          // Building each canteen item in the list
          return Card(
            margin: EdgeInsets.all(8),  // Adds margin around each card
            child: ListTile(
              title: Text(canteens[index]['name']),  // Displays the canteen name
              leading: _buildCanteenImage(canteens[index]['image']),  // Displays the canteen image using the helper method
              onTap: () {
                // On tapping a canteen, navigate to the DetailPage1 with the selected canteen data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage1(canteen: canteens[index]),  // Passing canteen data to DetailPage1
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Method to display the canteen image, or a placeholder if the image is not found
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,  // Load image from assets
      width: 50,  // Image width
      height: 50,  // Image height
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!'));  // If image fails to load, show placeholder text
      },
    );
  }
}

// Detail page class for displaying specific canteen details
class DetailPage1 extends StatelessWidget {
  final Map<String, dynamic> canteen;  // Data for the selected canteen

  DetailPage1({required this.canteen});  // Constructor to receive the selected canteen data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(canteen['name']),  // Title of the app bar with the selected canteen's name
        backgroundColor: Colors.purple,  // App bar color
      ),
      body: Column(
        children: [
          _buildCanteenImage(canteen['image']),  // Display the selected canteen image
          _buildProductCard(
            context,
            'Burger',  // Product name
            'Fast Food',  // Product type
            '100',  // Product price
          ),
          _buildProductCard(
            context,
            'Pizza',  // Product name
            'Italian',  // Product type
            '200',  // Product price
          ),
        ],
      ),
    );
  }

  // Method to display canteen image with a placeholder if the image is not found
  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,  // Load image from assets
      width: 200,  // Image width
      height: 200,  // Image height
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!'));  // Show placeholder text if image fails to load
      },
    );
  }

  // Method to build a card for each product with buy functionality
  Widget _buildProductCard(BuildContext context, String title, String type, String price) {
    return Card(
      color: Colors.purple,  // Card color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),  // Rounded corners for the card
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),  // Vertical margin between cards
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 16.0),  // Spacing on the left side
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,  // Display the product title
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  // Set the text color to black
                  ),
                ),
                Text(
                  'TYPE: $type',  // Display the product type
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,  // Set the text color to black
                  ),
                ),
                Text(
                  'PRICE: $price',  // Display the product price
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,  // Set the text color to black
                  ),
                ),
              ],
            ),
            Spacer(),  // Spacer to push the button to the right
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,  // Button background color
              ),
              onPressed: () async {
                try {
                  // Add the product order to Firestore database
                  await FirebaseFirestore.instance.collection('orders').add({
                    'title': title,
                    'type': type,
                    'price': price,
                    'canteen_name': canteen['name'],  // Add canteen name to the order
                    'timestamp': FieldValue.serverTimestamp(),  // Add timestamp for the order
                  });

                  // Show confirmation message on successful order placement
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Order of $title is placed Successfully',
                      style: TextStyle(color: Colors.white),  // Set text color to white
                    ),
                    backgroundColor: Colors.green,  // Set background color to green
                  ));

                  // Wait for a few seconds to display the SnackBar
                  await Future.delayed(Duration(seconds: 2));

                  // Navigate to OrderStatusPage after the delay
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusPage(),  // Navigate to the order status page
                    ),
                  );

                } catch (e) {
                  // Show error message if product addition to Firestore fails
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add product: $e'),
                  ));
                  print('Error adding product to Firestore: $e');  // Log the error
                }
              },
              child: Text('BUY'),  // Button text
            ),
          ],
        ),
      ),
    );
  }
}
