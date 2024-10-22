import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'rk_main_campus.dart' as main_campus;
import 'rk_city_campus.dart' as city_campus;

class PageNumber1 extends StatefulWidget {
  @override
  _PageNumber1State createState() => _PageNumber1State();
}

class _PageNumber1State extends State<PageNumber1> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the microphone to start speaking';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (!available) {
      setState(() => _text = 'Speech recognition not available');
    }
  }

  void _listen() async {
    if (!_isListening) {
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
        }),
      );
      setState(() => _isListening = true);
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Location: Rajkot'),
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _listen,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(color: Colors.purple),
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
            image: AssetImage("assets/background.png"), // Ensure this asset exists
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text(
                  '1. RKU MAIN CAMPUS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => main_campus.RKMainCampus()));
                  },
                  child: Image.asset('assets/images/rk_main_campus.png'),  // Ensure this asset exists
                ),
              ],
            ),
            SizedBox(height: 20), // Space between the two sections
            Column(
              children: [
                Text(
                  '2. RKU CITY CAMPUS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => city_campus.RKCityCampus()));
                  },
                  child: Image.asset('assets/images/rk_city_campus.png'),  // Ensure this asset exists
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
                // Add your buy action here
              },
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
