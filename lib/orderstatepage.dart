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
  List<bool> orderStatus = [true, false, false]; // Order progress: Placed (immediately true), Accepted, Preparing
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer for both Accepted and Preparing phases
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_acceptedTime > 0) {
          _acceptedTime -= 1;
        } else {
          orderStatus[1] = true; // Mark Accepted as complete after 10 minutes
        }

        if (_preparingTime > 0) {
          _preparingTime -= 1;
        } else {
          orderStatus[2] = true; // Mark Preparing as complete after 20 minutes
          timer.cancel(); // Stop the timer when everything is complete
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure to cancel the timer when the widget is disposed
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CONGRATULATIONS!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Your order is successfully placed!'),
            SizedBox(height: 10),
            ...List.generate(orderStatus.length, (index) {
              String title = ['Order Placed', 'Accepted', 'Preparing'][index];
              bool isCompleted = orderStatus[index];
              int time = [0, _acceptedTime, _preparingTime][index];
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Icon(isCompleted ? Icons.check : Icons.clear, color: isCompleted ? Colors.green : Colors.grey),
                    ],
                  ),
                  if (!isCompleted) SizedBox(height: 5),
                  if (!isCompleted)
                    Text('Remaining Time: ${formatTime(time)}'),
                  SizedBox(height: 20),
                ],
              );
            }),
            Text(
              _preparingTime == 0 ? 'Ready to Pickup' : 'Preparing Order',
              style: TextStyle(color: _preparingTime == 0 ? Colors.green : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
