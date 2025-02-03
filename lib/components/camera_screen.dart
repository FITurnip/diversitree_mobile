import 'dart:io';

import 'package:diversitree_mobile/components/camera_gallery.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/core/styles.dart';

class CameraScreen extends StatefulWidget {
  final List<XFile> newCapturedImages;
  final CameraDescription camera;
  final String workspace_id;
  final Function() saveImages;

  CameraScreen({required this.camera, required this.workspace_id, required this.newCapturedImages, required this.saveImages});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? lastCapturedImage; // To store the last captured image

  @override
  void initState() {
    super.initState();
    // Initialize the CameraController with the selected camera.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      // Set the zoom level to 1x (no zoom)
      _controller.setZoomLevel(1.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to capture image
  Future<void> captureImage() async {
    try {
      final image = await _controller.takePicture();
      setState(() {
        widget.newCapturedImages.insert(0, image);  // Add the captured image to the list
        lastCapturedImage = image;  // Update the last captured image
      });
      print('Captured Image Path: ${image.path}');
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  // Navigate to the gallery page (new route)
  void openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraGallery(images: widget.newCapturedImages, workspace_id: widget.workspace_id, saveImages: widget.saveImages,),  // Pass captured images to the GalleryPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print("i get this fucking shit: ${_controller.value.aspectRatio}");
            final mediaWidth = MediaQuery.of(context).size.width;
            final mediaHeight = MediaQuery.of(context).size.height;

            return Center(
              child: Transform.rotate(
                angle: 90 * 3.14159265359 / 180, // Rotate by 90 degrees in radians
                child: Transform.scale(
                  scale: mediaHeight / mediaWidth,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio, // Use the camera's aspect ratio
                    child: CameraPreview(_controller),
                  ),
                ),
              ),
            );
          } else {
            // Loading spinner while initializing
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: AppColors.secondary.withOpacity(0.8)),
              backgroundColor: AppColors.info.withOpacity(0.8),
              shape: CircleBorder(),
            ),
            SizedBox(width: 64),
            FloatingActionButton(
              onPressed: () async {
                // Capture image when the central button is clicked
                await captureImage();
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                // color: Colors.transparent,
                width: 100.0,  // Set the width of the circle
                height: 100.0, // Set the height of the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,  // Make the container circular
                  color: AppColors.secondary,
                ),
              ),
              backgroundColor: AppColors.secondary.withOpacity(0.8),
              shape: CircleBorder(),
            ),
            SizedBox(width: 64),
            FloatingActionButton(
              onPressed: () {
                // Navigate to the gallery page when the photo_library button is pressed
                openGallery(context);
              },
              child: lastCapturedImage == null
                  ? Icon(Icons.photo_album, color: AppColors.secondary.withOpacity(0.8),)
                  : ClipOval(
                      child: Image.file(
                        File(lastCapturedImage!.path),
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover, // Make the image cover the button area
                      ),
                    ),
              backgroundColor: AppColors.info.withOpacity(0.8),
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
    );
  }
}