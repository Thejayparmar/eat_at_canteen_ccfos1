import 'package:eat_at_canteen_ccfos/orderstatepage.dart';
import 'package:flutter/material.dart';
import 'orderstatepage.dart';  // Ensure to create the OrderStatusPage for navigation

// DetailPage2 class to display canteen product details
class DetailPage2 extends StatelessWidget {
  final Map<String, dynamic> canteen; // Canteen data passed as a map

  // Constructor to accept the canteen data
  DetailPage2({required this.canteen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align title and icon at opposite ends
          children: [
            Text('CREATED BY ALPHA TEAM'), // Displaying the team name
            Icon(Icons.mic), // Mic icon to signify a possible voice interaction feature
          ],
        ),
        backgroundColor: Colors.white, // White background for the app bar
        elevation: 0, // No shadow under the AppBar
        titleTextStyle: TextStyle(
          color: Colors.black, // Black text color for title
          fontWeight: FontWeight.bold, // Bold title text
          fontSize: 18, // Font size for the title
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set icon color to black
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Ensure the background image exists
            fit: BoxFit.cover, // Image covers the entire background
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding for page content
        child: ListView(
          children: [
            Text(
              'YOUR LOCATION: RAJKOT', // Display user's location
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color for location
              ),
            ),
            SizedBox(height: 10), // Add space between location text and product cards
            // Product cards displaying menu items
            _buildProductCard(
              context,
              '1. BURGER',
              'TYPE', // Product type can be dynamic
              '100', // Price of the product
              'assets/images/burger.png', // Ensure this image exists in your assets
            ),
            _buildProductCard(
              context,
              '2. PIZZA',
              'TYPE',
              '100',
              'assets/images/pizza.png', // Ensure this image exists
            ),
            _buildProductCard(
              context,
              '3. FRANKIE',
              'TYPE',
              '100',
              'assets/images/frankie.png', // Ensure this image exists
            ),
            _buildProductCard(
              context,
              '4. SPRING RL',
              'TYPE',
              '100',
              'assets/images/spring_rl.png', // Ensure this image exists
            ),
          ],
        ),
      ),
      // Bottom navigation bar with action buttons
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Spread icons evenly
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}), // Home icon
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}), // Shopping cart icon
            FloatingActionButton(
              backgroundColor: Colors.purple, // Color of the floating action button
              onPressed: () {}, // Placeholder action for the floating button
              child: Icon(Icons.add), // Icon inside the floating button
            ),
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}), // Notifications icon
            IconButton(icon: Icon(Icons.person), onPressed: () {}), // Profile icon
          ],
        ),
      ),
    );
  }

  // Helper method to build product card for each item
  Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
    return Card(
      color: Colors.purple, // Set the background color of the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin between cards
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding inside the card
        child: Row(
          children: [
            Image.asset(
              imagePath, // Load image from assets
              height: 60.0, // Set height of the image
              width: 60.0, // Set width of the image
            ),
            SizedBox(width: 16.0), // Space between image and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  title, // Display the title of the product
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold, // Bold font for title
                    color: Colors.white, // White text color for readability
                  ),
                ),
                Text(
                  'TYPE: $type', // Display type of product
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // White text color for type
                  ),
                ),
                Text(
                  'PRICE: $price', // Display price of the product
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white, // White text color for price
                  ),
                ),
              ],
            ),
            Spacer(), // Spacer to push the 'BUY' button to the right
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Button background color
              ),
              onPressed: () {
                // Navigate to the OrderStatusPage when 'BUY' is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderStatusPage()),
                );
              },
              child: Text('BUY'), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
