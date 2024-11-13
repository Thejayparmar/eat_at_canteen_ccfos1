import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database operations

/// AdminPage class to display a list of orders in the admin view
class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Orders'), // Title for the admin page AppBar
        centerTitle: true, // Center the title
        backgroundColor: Colors.purple, // Set AppBar background color
      ),
      body: StreamBuilder<QuerySnapshot>(
        // StreamBuilder to listen to Firestore changes in the 'orders' collection
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(), // Stream to get real-time data, ordered by timestamp
        builder: (context, snapshot) {
          // Check if the data is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading spinner while waiting
          }

          // Check if there's an error in fetching data
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Display error message if present
          }

          // Check if there are no orders to display
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found.')); // Show message if no orders are found
          }

          // List of order documents fetched from Firestore
          final orders = snapshot.data!.docs;

          // Build a list of orders using ListView.builder
          return ListView.builder(
            itemCount: orders.length, // Total number of order documents
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>; // Cast document to a map for easy access

              return Card(
                margin: EdgeInsets.all(8), // Margin around each order card
                child: ListTile(
                  title: Text(order['title'] ?? 'No title'), // Order title, fallback to 'No title' if null
                  subtitle: Text('Price: \$${order['price'] ?? 'N/A'}'), // Order price, fallback to 'N/A' if null
                  trailing: Icon(Icons.shopping_cart), // Shopping cart icon at the end of the ListTile
                ),
              );
            },
          );
        },
      ),
    );
  }
}
