import 'dart:io';

import 'package:diversitree_mobile/components/camera_gallery.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/core/styles.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String workspaceId;
  final Function() saveImage;
  final String mode; // New parameter to decide mode ('single' or 'multiple')
  final List<XFile>? capturedImages; // List to store multiple images for 'multiple' mode
  final Function(XFile)? syncCaptureImage;

  CameraScreen({
    required this.camera,
    required this.workspaceId,
    required this.saveImage,
    required this.mode,
    this.capturedImages,
    this.syncCaptureImage,
  });

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFlashing = false;
  XFile? capturedImage;
  // bool _imageCaptured = false; // Flag to track if an image has been captured

  @override
  void initState() {
    super.initState();
    // Initialize the CameraController with the selected camera.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
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
    // if (widget.mode == 'single' && _imageCaptured) return; // If it's single mode and an image is already captured, do nothing

    try {
      // Trigger the flash effect
      setState(() {
        _isFlashing = true;
      });

      // Wait for the flash effect to complete
      await Future.delayed(Duration(milliseconds: 150));

      final image = await _controller.takePicture();
      setState(() {
        if (widget.mode == 'single') {
          capturedImage = image; // Store the captured image
          // _imageCaptured = true; // Update flag to indicate an image has been captured
        } else {
          widget.capturedImages?.insert(0, image); // Store in list if mode is multiple
        }
        _isFlashing = false;
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
        builder: (context) => CameraGallery(
          images: widget.mode == 'single' ? [capturedImage!] : widget.capturedImages!,
          saveImage: () {
            if(widget.mode == 'single') widget.syncCaptureImage!(capturedImage!);
            widget.saveImage();
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Anda ingin kembali?'),
          content: Text('Foto terbaru akan dihapus'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.capturedImages?.clear();
                Navigator.of(context).pop(true); // Do pop
              },
              child: Text(
                'Ya',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Do not pop
              },
              child: Text(
                'Batalkan',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(widget.capturedImages?.length == 0 && widget.mode == 'multiple') return;
        if(widget.mode == 'single') return;
        // Call the extracted method for confirmation dialog
        bool? shouldPop = await _showConfirmationDialog(context);

        // If user confirms, pop the page
        if (shouldPop == true) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
      
            Positioned(
              bottom: 32.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      bool? shouldPop = true;

                      if(widget.capturedImages!.length > 0 && widget.mode == 'multiple') shouldPop = await _showConfirmationDialog(context);

                      // If user confirms, pop the page
                      if (shouldPop == true) {
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.secondary.withOpacity(0.8),
                    ),
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
                      if (widget.mode == 'single' && capturedImage != null) {
                        openGallery(context);
                      } else if (widget.mode == 'multiple' && widget.capturedImages!.isNotEmpty) {
                        openGallery(context);
                      }
                    },
                    child: widget.mode == 'single'
                      ? capturedImage == null
                        ? Icon(
                            Icons.photo_album,
                            color: AppColors.secondary.withOpacity(0.8),
                          )
                        : ClipOval(
                            child: Image.file(
                              File(capturedImage!.path),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover, // Make the image cover the button area
                            ),
                          )
                    : widget.capturedImages!.isEmpty
                        ? Icon(
                            Icons.photo_album,
                            color: AppColors.secondary.withOpacity(0.8),
                          )
                        : ClipOval(
                            child: Image.file(
                              File(widget.capturedImages!.first.path), // Show the first image in the list (last captured)
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover, // Make the image cover the button area
                            ),
                          ),
                    backgroundColor: AppColors.info.withOpacity(0.8),
                    shape: CircleBorder(),
                  ),
                ],
              )),
      
            if (_isFlashing) AnimatedOpacity(
              opacity: _isFlashing ? 0.90 : 0.0, // Flash effect, visible for a brief moment
              duration: Duration(milliseconds: 100),
              child: Container(
                color: Colors.black, // Flash color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
