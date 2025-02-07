import 'package:diversitree_mobile/components/camera_screen.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IdentifikasiPohon extends StatefulWidget {
  final Map<String, dynamic> pohonData;
  final String workspaceId;
  
  IdentifikasiPohon({required this.pohonData, required this.workspaceId});

  @override
  _IdentifikasiPohonState createState() => _IdentifikasiPohonState();
}

class _IdentifikasiPohonState extends State<IdentifikasiPohon> {
  final TextEditingController _spesiesController = TextEditingController();
  final TextEditingController _dbhController = TextEditingController();

  @override
  void dispose() {
    _spesiesController.dispose();
    _dbhController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _spesiesController.text = widget.pohonData["nama_spesies"] ?? "";
    _dbhController.text = widget.pohonData["dbh"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Image
          Positioned.fill(
            child: Image.network(
              ApiService.urlStorage + widget.pohonData["path_foto"], // Replace with your image
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: ElevatedButton(
              onPressed: () {
                // Navigate back when the button is pressed
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTextColors.onPrimary.withOpacity(0.8), // Remove any shadow
                padding: EdgeInsets.all(8), // Adjust padding if needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Set the border radius to make it rounded
                ),
              ),
              child: Icon(
                Icons.arrow_back, // Back arrow icon
                color: AppColors.primary, // Set the icon color to primary color
              ),
            ),
          ),

          // Recapture button on top right
          Positioned(
            top: 40,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                final backCamera = CameraService.getBackCamera();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(
                      camera: backCamera,
                      workspaceId: widget.workspaceId,
                      capturedImages: [],
                      saveImages: () {
                        // widget.saveCapturedImage!();
                      },
                      mode: 'single',
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: AppTextColors.onPrimary,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Set the border radius to make it rounded
                ),
              ),
            ),
          ),
          // Draggable Bottom Sheet with TextFields
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.08,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 4, // Set the height of the line
                        width: 80, // Make the line span the width of the container
                        decoration: BoxDecoration(
                          color: AppColors.primary, // Set the color of the line
                          borderRadius: BorderRadius.circular(2), // Set border radius for rounded ends
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Identifikasi ulang",
                                style: TextStyle(color: AppColors.primary, fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 32),
                                maximumSize: Size(double.infinity, 40),
                                backgroundColor: Colors.white.withOpacity(0.75),
                                side: BorderSide(
                                  color: AppColors.primary
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Simpan",
                                style: TextStyle(color: Colors.white, fontSize: 12)
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 32),
                                backgroundColor: AppColors.primary
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 48,
                        margin: EdgeInsets.only(
                          bottom: 16
                        ),
                        child: TextField(
                          controller: _spesiesController,
                          decoration: InputDecoration(
                            labelText: 'Spesies',
                            labelStyle: TextStyle(fontSize: 14, color: AppColors.primary),
                            floatingLabelStyle: TextStyle(color: AppColors.primary),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // Add border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary), // Border when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary), // Border when focused
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: EdgeInsets.only(
                          bottom: 16
                        ),
                        child: TextField(
                          controller: _dbhController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow only numbers and one decimal
                          ],
                          decoration: InputDecoration(
                            labelText: 'DBH',
                            labelStyle: TextStyle(fontSize: 14, color: AppColors.primary),
                            floatingLabelStyle: TextStyle(color: AppColors.primary),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // Add border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary), // Border when focused
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary), // Border when focused
                            ),
                            suffixText: 'm²',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}