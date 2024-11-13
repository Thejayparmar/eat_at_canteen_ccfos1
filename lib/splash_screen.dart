import 'dart:async';
import 'package:flutter/material.dart';
import 'loginpage.dart';  // Ensure these files are created and configured correctly
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller; // Controls the animations
  Animation<double>? _opacityAnimation; // Animation for text opacity
  Animation<Offset>? _slideAnimation;   // Animation for text sliding in from the left

  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with a duration of 2 seconds
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Setting up the opacity animation with an ease-in curve
    _opacityAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    // Setting up the slide animation to move from left (off-screen) to center
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Start from off-screen left
      end: Offset(0.0, 0.0),    // End at the center
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,    // Smooth slide-out curve
    ));

    // Start the animation after a 2-second delay for the initial logo display
    Timer(Duration(seconds: 2), () {
      _controller!.forward();  // Begin text animations
    });

    // Navigate to the home page after 5 seconds in total
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/home'); // Replace splash screen with home screen
    });
  }

  @override
  void dispose() {
    _controller!.dispose();  // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center content vertically
          children: <Widget>[
            // Display the logo
            Image.asset('assets/images/logo.png'), // Path to your logo

            // Slide and fade transition for the welcome text
            SlideTransition(
              position: _slideAnimation!, // Slide animation
              child: FadeTransition(
                opacity: _opacityAnimation!, // Fade animation
                child: Text(
                  "HELLO WELCOME",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
