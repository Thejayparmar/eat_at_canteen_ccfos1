import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AdminOrderPage displays a list of orders from Firestore and provides
/// the admin with options to update each order's status to 'accepted' or 'rejected'.

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  /// Updates the status of an order in Firestore based on `docId` (order ID) and `newStatus`.
  Future<void> updateOrderStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title for the admin order management screen.
        title: Text('Admin Order Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Real-time stream of orders from Firestore.
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          // Display a loading indicator while data is loading.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If there are no orders, display a message.
          if (!snapshot.hasData) return Text('No orders found!');
          
          // Display the list of orders in a ListView.
          return ListView.builder(
            itemCount: snapshot.data!.docs.length, // Number of orders.
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              
              // Each order is displayed as a card with details and status options.
              return Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.deepPurple),
                  // Displays the name of the item in the order.
                  title: Text(data['items']['name'], style: TextStyle(color: Colors.deepPurple)),
                  // Displays the quantity of the item.
                  subtitle: Text('Quantity: ${data['items']['quantity']}'),
                  trailing: Wrap(
                    spacing: 12, // Space between the action icons.
                    children: <Widget>[
                      // Button to accept the order.
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => updateOrderStatus(doc.id, 'accepted'),
                      ),
                      // Button to reject the order.
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => updateOrderStatus(doc.id, 'rejected'),
                      ),
                    ],
                  ),
                  onTap: () {}, // Action when the order card is tapped.
                ),
              );
            },
          );
        },
      ),
    );
  }
}
