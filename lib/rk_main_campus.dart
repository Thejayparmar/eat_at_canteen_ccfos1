import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orderstatepage.dart';

class RKMainCampus extends StatelessWidget {
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
        title: Text('RKU Main Campus Canteens'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: canteens.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(canteens[index]['name']),
              leading: _buildCanteenImage(canteens[index]['image']),
              onTap: () {
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

  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!'));
      },
    );
  }
}

class DetailPage1 extends StatelessWidget {
  final Map<String, dynamic> canteen;

  DetailPage1({required this.canteen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(canteen['name']),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _buildCanteenImage(canteen['image']),
          _buildProductCard(
            context,
            'Burger',
            'Fast Food',
            '100',
          ),
          _buildProductCard(
            context,
            'Pizza',
            'Italian',
            '200',
          ),
        ],
      ),
    );
  }

  Widget _buildCanteenImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 200,
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Image not found!'));
      },
    );
  }

  Widget _buildProductCard(BuildContext context, String title, String type, String price) {
    return Card(
      color: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'TYPE: $type',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'PRICE: $price',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () async {
                try {
                  // Add the product to Firestore
                  await FirebaseFirestore.instance.collection('orders').add({
                    'title': title,
                    'type': type,
                    'price': price,
                    'canteen_name': canteen['name'],
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Show confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Order of $title is placed Successfully',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    backgroundColor: Colors.green, // Set background color to green
                  ));

                  // Wait for a few seconds to allow the SnackBar to show
                  await Future.delayed(Duration(seconds: 2));

                  // Navigate to OrderStatePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderStatusPage(), // Replace with your actual OrderStatePage widget
                    ),
                  );

                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add product: $e'),
                  ));
                  print('Error adding product to Firestore: $e');
                }
              },
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}


