import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/views/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  CameraService.initializeCameras();
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
  Future<void> initialization() async {
    await AuthService.prepare();
    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request Camera Permission
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isDenied) {
      // Show dialog or explanation if needed
    }

    // Request Storage Permission (optional)
    var storageStatus = await Permission.storage.request();
    if (storageStatus.isDenied) {
      // Handle denial
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
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
