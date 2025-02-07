import 'dart:io';

import 'package:diversitree_mobile/components/header.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PhotoViewPage extends StatelessWidget {
  final XFile image;

  PhotoViewPage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(titleText: 'Pohon'),
      body: Image.file(
        File(image.path),
        fit: BoxFit.contain, // Ensure the image fits nicely on the screen
      ),
    );
  }
}