import 'package:eat_at_canteen_ccfos/home_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packagesflutter pub add firebase_core
import 'splash_screen.dart';
 // Correct path to SplashScreen
  // Correct path to LoginPage
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'orderstatepage.dart';
import 'register_page.dart';
import 'rk_city_campus.dart';
import 'rk_main_campus.dart';
import 'EntryPage.dart';
import 'rk_city_campus.dart';
import 'loginpage.dart';
import 'adminpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,  // Remove this line to disable debug mode banner
    title: 'Your App',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    initialRoute: '/',
  routes: {
  '/': (context) => SplashScreen(),
  '/home': (context) => LoginPage(),
 
   // Ensure HomePage is correctly imported and routed
},
  ));
}
