import 'package:permission_handler/permission_handler.dart';
import 'package:diversitree_mobile/views/splash_screen.dart';
import 'package:flutter/material.dart';

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
  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diversitree App',
      home: SplashScreen(),  // Start with SplashScreen
    );
  }
}
