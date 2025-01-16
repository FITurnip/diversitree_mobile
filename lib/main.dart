import 'package:diversitree_mobile/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:diversitree_mobile/views/Home.dart';  // Import your Home page

void main() {
  runApp(Diversitree());
}

class Diversitree extends StatefulWidget {
  const Diversitree({super.key});

  @override
  DiversitreeState createState() {
    return DiversitreeState();
  }
}

class DiversitreeState extends State<Diversitree> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diversitree App',
      home: SplashScreen(),  // Start with SplashScreen
    );
  }
}
