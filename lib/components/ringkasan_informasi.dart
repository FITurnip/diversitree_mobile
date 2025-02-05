import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/camera_screen.dart';
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
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Text(
                        ": 20.3 m2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120, // Fixed width for the label
                        child: Text(
                          "Teridentifikasi",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Text(
                        ": 10 pohon",
                        style: TextStyle(color: Colors.white),
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
                // Ensure that plugin services are initialized before accessing availableCameras.
                WidgetsFlutterBinding.ensureInitialized();

                // Get the list of available cameras.
                final cameras = await availableCameras();

                // Find the back camera.
                final backCamera = cameras.firstWhere(
                  (camera) => camera.lensDirection == CameraLensDirection.back,
                  orElse: () => throw Exception('No back camera found!'),
                );

                // page route to camera screen
                print("Navigating to Camera Screen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(
                      camera: backCamera,
                      workspace_id: widget.workspaceData['id'],
                      newCapturedImages: widget.newCapturedImages ?? [],
                      saveImages: () {
                        widget.saveCapturedImage!();
                      },
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