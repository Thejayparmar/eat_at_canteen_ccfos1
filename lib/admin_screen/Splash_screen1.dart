import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Total animation time
      vsync: this,
    );

    // Opacity animation
    _opacityAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    // Slide animation from left to right
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Start off-screen to the left
      end: Offset(0.0, 0.0),   // End at the center
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
    ));

    // Start text animation after the image has been displayed for 3 seconds
    Timer(Duration(seconds: 2), () {
      _controller!.forward();
    });

    // Navigate to login page after a total of 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'), // Your logo
            SlideTransition(
              position: _slideAnimation!,
              child: FadeTransition(
                opacity: _opacityAnimation!,
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
