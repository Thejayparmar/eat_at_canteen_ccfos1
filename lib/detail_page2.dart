import 'package:eat_at_canteen_ccfos/orderstatepage.dart';
import 'package:flutter/material.dart';
import 'orderstatepage.dart';  // Make sure to create this new page

class DetailPage2 extends StatelessWidget {
  final Map<String, dynamic> canteen;

  DetailPage2({required this.canteen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CREATED BY ALPHA TEAM'),
            Icon(Icons.mic),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Ensure this asset exists
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            Text(
              'YOUR LOCATION: RAJKOT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildProductCard(
              context,
              '1. BURGER',
              'TYPE',
              '100',
              'assets/images/burger.png', // Ensure this asset exists
            ),
            _buildProductCard(
              context,
              '2. PIZZA',
              'TYPE',
              '100',
              'assets/images/pizza.png', // Ensure this asset exists
            ),
            _buildProductCard(
              context,
              '3. FRANKIE',
              'TYPE',
              '100',
              'assets/images/frankie.png', // Ensure this asset exists
            ),
            _buildProductCard(
              context,
              '4. SPRING RL',
              'TYPE',
              '100',
              'assets/images/spring_rl.png', // Ensure this asset exists
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
            FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () {},
              child: Icon(Icons.add),
            ),
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
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
            Image.asset(
              imagePath,
              height: 60.0,
              width: 60.0,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'TYPE: $type',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'PRICE: $price',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderStatusPage()),
                );
              },
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
