import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PhotoViewPage extends StatelessWidget {
  final XFile image;

  PhotoViewPage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo View'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Image.file(
          File(image.path),
          fit: BoxFit.contain, // Ensure the image fits nicely on the screen
        ),
      ),
    );
  }
}