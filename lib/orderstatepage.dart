import 'dart:async';
import 'package:flutter/material.dart';

class OrderStatusPage extends StatefulWidget {
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  // Define the initial times for each phase
  int _acceptedTime = 600; // 10 minutes * 60 seconds
  int _preparingTime = 1200; // 20 minutes * 60 seconds

  // The orderStatus list holds the progress of each phase
  List<bool> orderStatus = [true, false, false]; // Order progress: Placed (immediately true), Accepted, Preparing

  Timer? _timer; // Timer to track countdown for each phase

  @override
  void initState() {
    super.initState();
    // Start the countdown timer to update the order status every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Countdown for Accepted phase (10 minutes)
        if (_acceptedTime > 0) {
          _acceptedTime -= 1; // Reduce time every second
        } else {
          orderStatus[1] = true; // Mark Accepted as complete after 10 minutes
        }

        // Countdown for Preparing phase (20 minutes)
        if (_preparingTime > 0) {
          _preparingTime -= 1; // Reduce time every second
        } else {
          orderStatus[2] = true; // Mark Preparing as complete after 20 minutes
          timer.cancel(); // Stop the timer when all phases are complete
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed to avoid memory leaks
    super.dispose();
  }

  // Function to format time from seconds to "MM:SS" format
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60; // Calculate minutes
    int remainingSeconds = seconds % 60; // Calculate remaining seconds
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}'; // Format as MM:SS
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'), // Title of the screen
        backgroundColor: Colors.purple, // AppBar color
      ),
      body: Container(
        alignment: Alignment.center, // Center the content on the screen
        padding: EdgeInsets.all(24), // Add padding around the container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the children in the column
          children: [
            // Header Text
            Text(
              'CONGRATULATIONS!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Make text bold and larger
            ),
            SizedBox(height: 20), // Space between header and other widgets
            Text('Your order is successfully placed!'), // Inform the user about the order placement
            SizedBox(height: 10),
            
            // List of order phases (Placed, Accepted, Preparing)
            ...List.generate(orderStatus.length, (index) {
              String title = ['Order Placed', 'Accepted', 'Preparing'][index]; // Title for each phase
              bool isCompleted = orderStatus[index]; // Check if the phase is completed
              int time = [0, _acceptedTime, _preparingTime][index]; // Get the remaining time for each phase
              
              // Return the widgets for each phase (Row with status and time remaining)
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the items in the row
                    children: [
                      Text(title), // Display the phase title (e.g., "Order Placed")
                      Icon(isCompleted ? Icons.check : Icons.clear, color: isCompleted ? Colors.green : Colors.grey), // Show a check or clear icon
                    ],
                  ),
                  if (!isCompleted) SizedBox(height: 5), // Add a small space if the phase is not completed
                  if (!isCompleted) 
                    Text('Remaining Time: ${formatTime(time)}'), // Display the remaining time
                  SizedBox(height: 20), // Space between each phase
                ],
              );
            }),

            // Display the status of the Preparing phase
            Text(
              _preparingTime == 0 ? 'Ready to Pickup' : 'Preparing Order',
              style: TextStyle(color: _preparingTime == 0 ? Colors.green : Colors.grey), // Show green when ready to pick up, grey when preparing
            ),
          ],
        ),
      ),
    );
  }
}
