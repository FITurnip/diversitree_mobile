import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/camera_screen.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/core/styles.dart';

import 'package:flutter/material.dart';
class RingkasanInformasi extends StatefulWidget {
  const RingkasanInformasi({
    super.key,
    required this.infoSize,
    required this.showCamera,
    required this.workspaceData,
    this.newCapturedImages, 
    this.saveCapturedImage,
  });

  final double infoSize;
  final bool showCamera;
  final Map<String, dynamic> workspaceData;
  final List<XFile>? newCapturedImages;
  final Function()? saveCapturedImage;

  @override
  State<RingkasanInformasi> createState() => _RingkasanInformasiState();
}

class _RingkasanInformasiState extends State<RingkasanInformasi> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              width: double.infinity,
              height: widget.infoSize,
              decoration: BoxDecoration(
                color: AppColors.info, // Background color
                borderRadius: BorderRadius.circular(appBorderRadius), // Border radius
              ),
              padding: EdgeInsets.all(8), // Optional: Add padding inside the container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120, // Fixed width for the label
                        child: Text(
                          "Luas Area",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Text(
                        ": ${widget.workspaceData['luas_persegi']} m²",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120, // Fixed width for the label
                        child: Text(
                          "Teridentifikasi",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Text(
                        ": ${widget.workspaceData['pohon'] is List<dynamic> ? widget.workspaceData['pohon'].length : '0'} pohon",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      
          // Camera Button
          if(widget.showCamera)
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: OutlinedButton(
              onPressed: () async {
                // Find the back camera.
                final backCamera = CameraService.getBackCamera();

                // page route to camera screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(
                      camera: backCamera,
                      workspaceId: widget.workspaceData['id'],
                      capturedImages: widget.newCapturedImages ?? [],
                      saveImage: () {
                        widget.saveCapturedImage!();
                      },
                      mode: 'multiple',
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                fixedSize: Size(widget.infoSize, widget.infoSize), // Set width & height
                backgroundColor: AppColors.secondary,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Square shape
                ),
                side: BorderSide(color: AppColors.secondary, width: 0.0), // Border color & width
              ),
              child: Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}