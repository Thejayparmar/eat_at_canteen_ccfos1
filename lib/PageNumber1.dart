import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import speech-to-text functionality
import 'rk_main_campus.dart' as main_campus; // Import main campus page
import 'rk_city_campus.dart' as city_campus; // Import city campus page

/// PageNumber1 class displays location options and utilizes speech-to-text for voice commands
class PageNumber1 extends StatefulWidget {
  @override
  _PageNumber1State createState() => _PageNumber1State();
}

class _PageNumber1State extends State<PageNumber1> {
  stt.SpeechToText _speech = stt.SpeechToText(); // Initialize SpeechToText instance
  bool _isListening = false; // Track if microphone is listening
  String _text = 'Press the microphone to start speaking'; // Displayed text based on speech input

  @override
  void initState() {
    super.initState();
    _initializeSpeech(); // Initialize speech recognition
  }

  /// Initialize the speech recognition
  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'), // Monitor speech status
      onError: (val) => print('onError: $val'), // Monitor errors
    );
    if (!available) {
      setState(() => _text = 'Speech recognition not available'); // Notify if unavailable
    }
  }

  /// Toggle listening on and off
  void _listen() async {
    if (!_isListening) {
      // Start listening and update recognized text
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords; // Update displayed text with recognized words
        }),
      );
      setState(() => _isListening = true); // Set listening state to true
    } else {
      _speech.stop(); // Stop listening
      setState(() => _isListening = false); // Set listening state to false
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Location: Rajkot'), // AppBar title
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none), // Display microphone icon based on listening state
            onPressed: _listen, // Toggle listening when pressed
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Reset padding for drawer items
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'), // Drawer header title
              decoration: BoxDecoration(color: Colors.purple), // Drawer header background color
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Handle profile navigation
              },
            ),
            ListTile(
              title: Text('Expenses'),
              onTap: () {
                // Handle expenses navigation
              },
            ),
            ListTile(
              title: Text('Menu Options'),
              onTap: () {
                // Handle other menu options
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Set background image, ensure asset exists
            fit: BoxFit.cover, // Fit image to cover the background
          ),
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text(
                  '1. RKU MAIN CAMPUS', // Label for Main Campus section
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => main_campus.RKMainCampus()));
                    // Navigate to main campus page when tapped
                  },
                  child: Image.asset('assets/images/rk_main_campus.png'),  // Display main campus image, ensure asset exists
                ),
              ],
            ),
            SizedBox(height: 20), // Space between main and city campus sections
            Column(
              children: [
                Text(
                  '2. RKU CITY CAMPUS', // Label for City Campus section
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => city_campus.RKCityCampus()));
                    // Navigate to city campus page when tapped
                  },
                  child: Image.asset('assets/images/rk_city_campus.png'),  // Display city campus image, ensure asset exists
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a card displaying product details with a buy button
Widget _buildProductCard(BuildContext context, String title, String type, String price, String imagePath) {
  return Card(
    color: Colors.purple, // Set card color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
    ),
    margin: EdgeInsets.symmetric(vertical: 8.0), // Vertical margin between cards
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Padding within the card
      child: Row(
        children: [
          Image.asset(
            imagePath, // Product image, ensure asset exists
            height: 60.0,
            width: 60.0,
          ),
          SizedBox(width: 16.0), // Space between image and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, // Product title
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'TYPE: $type', // Product type
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'PRICE: $price', // Product price
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(), // Spacer to push button to the end
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Button color
            ),
            onPressed: () {
              // Handle buy action here
            },
            child: Text('BUY'), // Buy button label
          ),
        ],
      ),
    ),
  );
}
