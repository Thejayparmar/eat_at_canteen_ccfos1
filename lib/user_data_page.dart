import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// UserDataPage class displays user data from a Firestore collection in real-time
class UserDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"), // Title for the app bar
        backgroundColor: Colors.deepPurple, // Background color of the app bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Listen to real-time changes from Firestore 'shopping_list' collection
        stream: FirebaseFirestore.instance.collection('shopping_list').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle errors if any occur during the data fetch
          if (snapshot.hasError) {
            return Text('Something went wrong'); // Error message if the stream fails
          }

          // Show a loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Circular loading indicator
          }

          // Display data from the Firestore collection in a ListView
          return ListView(
            // Convert each document in the snapshot to a ListTile widget
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // Extract data from each document and cast it to a Map
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']), // Display the 'name' field as the title
                subtitle: Text(data['quantity']), // Display the 'quantity' field as the subtitle
                trailing: data['image'] != null // Check if 'image' field is available
                    ? Image.network(
                        data['image'], // Display the image from the URL
                        width: 100,
                        fit: BoxFit.cover, // Set image to cover the assigned area
                      )
                    : null, // If no image is provided, show nothing
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
