// temporary, please fix this

import 'package:flutter/material.dart';
import 'package:diversitree_mobile/views/Home.dart'; // Import your Home page

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Home after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Navigate to Home
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Applying a Linear Gradient to the background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF08CB4A), // Lighter green
              Color(0xFF046525), // Darker green
            ],
            begin: Alignment.topLeft, // Gradient starts from the top-left
            end: Alignment.bottomRight, // Gradient ends at the bottom-right
          ),
        ),
        child: Center(
          child: Image.asset(
            'storage/Logo_Default.png', // Path to your PNG logo
            width: width * 0.75, // Logo width is 3/4 of the screen width
            height: width * 0.75, // Logo height matches the width for aspect ratio
            fit: BoxFit.contain, // Ensure the logo scales well
          ),
        ),
      ),
    );
  }
}