import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/views/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

void main() {
  CameraService.initializeCameras();
  AuthService.prepare();
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
      home: Home(),
    );
  }
}
