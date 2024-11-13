import 'package:flutter/material.dart';

/// DetailPage1 class to display canteen product details
class DetailPage1 extends StatelessWidget {
  final Map<String, dynamic> canteen; // Canteen data passed as a map

  // Constructor to accept the canteen data
  DetailPage1({required this.canteen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out text and icon
          children: [
            Text('CREATED BY ALPHA TEAM'), // Title text
            Icon(Icons.mic), // Mic icon to represent a feature (e.g., voice commands)
          ],
        ),
        backgroundColor: Colors.white, // White background for the AppBar
        elevation: 0, // No shadow under the AppBar
        titleTextStyle: TextStyle(
          color: Colors.black, // Black color for title text
          fontWeight: FontWeight.bold, // Bold font for title
          fontSize: 18, // Font size for the title
        ),
        iconTheme: IconThemeData(color: Colors.black), // Icon color set to black
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Background image for the page
            fit: BoxFit.cover, // Cover the entire background
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding for page content
        child: ListView(
          children: [
            Text(
              'YOUR LOCATION: RAJKOT', // Location information
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10), // Spacer between location text and product cards
            // Product cards with title, type, price, and image
            _buildProductCard(
              context,
              '1. BURGER',
              'TYPE A', // Static type, can also be dynamic
              '100', // Price of the product
              'assets/images/burger.png', // Image path for the product
            ),
            _buildProductCard(
              context,
              '2. PIZZA',
              'TYPE B',
              '150',
              'assets/images/pizza.png',
            ),
            _buildProductCard(
              context,
              '3. FRANKIE',
              'TYPE C',
              '50',
              'assets/images/frankie.png',
            ),
            _buildProductCard(
              context,
              '4. SPRING RL',
              'TYPE D',
              '80',
              'assets/images/spring_rl.png',
            ),
          ],
        ),
      ),
      // Bottom navigation bar with icons and a floating button
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Spacing for icons
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}), // Home icon button
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}), // Shopping cart icon button
            FloatingActionButton(
              backgroundColor: Colors.purple, // Color for the floating button
              onPressed: () {}, // Placeholder for the floating button action
              child: Icon(Icons.add), // Plus icon inside the floating button
            ),
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}), // Notifications icon button
            IconButton(icon: Icon(Icons.person), onPressed: () {}), // Profile icon button
          ],
        ),
      ),
    );
  }

  /// Builds a product card widget with details such as title, type, price, and image
  Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
    return Card(
      color: Colors.purple, // Card background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin for each card
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding inside the card
        child: Row(
          children: [
            Image.asset(
              imagePath, // Image asset for the product
              height: 60.0, // Image height
              width: 60.0, // Image width
            ),
            SizedBox(width: 16.0), // Spacer between image and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  title, // Product title
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color for readability
                  ),
                ),
                Text(
                  'TYPE: $type', // Display product type
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'PRICE: $price', // Display product price
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
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
                // Add your buy action here
              },
              child: Text('BUY'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
