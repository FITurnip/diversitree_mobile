import 'dart:async';
import 'dart:ui';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MenentukanKoordinat extends StatefulWidget {
  final Map<String, dynamic> workspaceData;
  MenentukanKoordinat({required this.workspaceData});

  @override
  _MenentukanKoordinatState createState() => _MenentukanKoordinatState();
}

class _MenentukanKoordinatState extends State<MenentukanKoordinat> {
  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(workspaceData: widget.workspaceData);
  }
}

enum CircleState { selected, unselected, filled }

class DashedBorderBox extends StatefulWidget {
  final Map<String, dynamic> workspaceData;
  DashedBorderBox({required this.workspaceData});

  @override
  _DashedBorderBoxState createState() => _DashedBorderBoxState();
}

class _DashedBorderBoxState extends State<DashedBorderBox> {
  String selectedKoordinat = "";

  Map<String, String> labelKoordinat = {
    "kiri_atas": "Kiri Atas",
    "kanan_atas": "Kanan Atas",
    "kiri_bawah": "Kiri Atas",
    "kanan_bawah": "Kanan Bawah"
  };

  Map<String, dynamic> koordinat = {
    "kiri_atas": {"x": null as double?, "y": null as double?},
    "kanan_atas": {"x": null as double?, "y": null as double?},
    "kiri_bawah": {"x": null as double?, "y": null as double?},
    "kanan_bawah": {"x": null as double?, "y": null as double?}
  };

  Map<String, Color> circleColor = {
    "kiri_atas": AppColors.tertiary,
    "kanan_atas": AppColors.tertiary,
    "kiri_bawah": AppColors.tertiary,
    "kanan_bawah": AppColors.tertiary,
  };

  void updateColor() {
    setState(() {
      koordinat.forEach((key, value) {
        if(key == selectedKoordinat) {
          circleColor[key] = AppColors.secondary;
        } else {
          if (value["x"] != null) {
            circleColor[key] = AppColors.primary; 
          } else {
            circleColor[key] = AppColors.tertiary;
          }
        }
      });
    });
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );
  String locationMessage = 'Requesting location...';

  Future<void> _checkPermissionsAndStartStream() async {
    // Check if location permissions are granted
    final permissionStatus = await Permission.locationWhenInUse.status;

    if (permissionStatus.isGranted) {
      // If permission is granted, start listening to the stream
      _startLocationStream();
    } else if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      // Request permission
      final result = await Permission.locationWhenInUse.request();

      if (result.isGranted) {
        _startLocationStream();
      } else {
        setState(() {
          locationMessage = 'Location permission denied.';
        });
      }
    }
  }

  double? latitudePosition, longitudePosition;

  void _startLocationStream() {
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        setState(() {
          if (position == null) {
            locationMessage = 'Unknown location';
          } else {
            locationMessage =
                'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                latitudePosition = position.latitude;
                longitudePosition = position.longitude;
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    updateColor();

    // Debug print to check the updated map
    if (kDebugMode) {
      print(circleColor);
    }

    _checkPermissionsAndStartStream();

    setState(() {
      if(widget.workspaceData["titik_koordinat"] != null) {
        koordinat = widget.workspaceData["titik_koordinat"];
      }
      widget.workspaceData["titik_koordinat"] = koordinat;
    });

    // print("hasil akhir:${widget.workspaceData}");
  }

  void selectKoordinat(String newSelectedKoordinat) {
    setState(() {
      selectedKoordinat = newSelectedKoordinat;
    });
  }

  void _onSectionTap(String sectionKey) {
    print("clicked ${sectionKey}");
    // Handle section tap logic here
    selectKoordinat(sectionKey);
    updateColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16,),

        Center(
          child: Container(
            child: Stack(
              clipBehavior: Clip.none, // Allow overflow of the circles
              children: [
                // Main box with dashed border
                Container(
                  height: 100, // Fixed height
                  width: 100,  // Fixed width
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent), // Invisible border for dashed effect
                  ),
                  child: CustomPaint(
                    painter: DashedBorderPainter(),
                  ),
                ),
                
                // Circles on the corners (just circular containers, no interaction)
                for (var entry in koordinat.entries)
                  Positioned(
                    // Check the position and apply the correct `top`, `left`, `bottom`, or `right`
                    top: entry.key == 'kiri_atas' || entry.key == 'kanan_atas' ? -8 : null,
                    left: entry.key == 'kiri_atas' || entry.key == 'kiri_bawah' ? -8 : null,
                    right: entry.key == 'kanan_atas' || entry.key == 'kanan_bawah' ? -8 : null,
                    bottom: entry.key == 'kiri_bawah' || entry.key == 'kanan_bawah' ? -8 : null,
                    child: CircleContainer(
                      position: entry.key,
                      circleColor: circleColor,
                      isChecked: koordinat[entry.key]['x'] != null,
                    ),
                  ),
                

                // Clickable areas divided into four sections
                Positioned.fill(
                  child: Row(
                    children: [
                      // Left half
                      Expanded(
                        child: Column(
                          children: [
                            // Top-left clickable area (fixed size of 50x50)
                            GestureDetector(
                              onTap: () => _onSectionTap('kiri_atas'),
                              child: Container(
                                width: 50, // Fixed size
                                height: 50, // Fixed size
                                color: Colors.transparent, // Invisible container for tapping
                              ),
                            ),
                            // Bottom-left clickable area (fixed size of 50x50)
                            GestureDetector(
                              onTap: () => _onSectionTap('kiri_bawah'),
                              child: Container(
                                width: 50, // Fixed size
                                height: 50, // Fixed size
                                color: Colors.transparent, // Invisible container for tapping
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right half
                      Expanded(
                        child: Column(
                          children: [
                            // Top-right clickable area (fixed size of 50x50)
                            GestureDetector(
                              onTap: () => _onSectionTap('kanan_atas'),
                              child: Container(
                                width: 50, // Fixed size
                                height: 50, // Fixed size
                                color: Colors.transparent, // Invisible container for tapping
                              ),
                            ),
                            // Bottom-right clickable area (fixed size of 50x50)
                            GestureDetector(
                              onTap: () => _onSectionTap('kanan_bawah'),
                              child: Container(
                                width: 50, // Fixed size
                                height: 50, // Fixed size
                                color: Colors.transparent, // Invisible container for tapping
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),


        SizedBox(height: 32,),

        for (var entry in koordinat.entries)
          GestureDetector(
            onTap: () {
              selectKoordinat(entry.key);
              updateColor();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              margin: EdgeInsets.symmetric(vertical: 4.0),
              width: double.infinity,
              height: 28,
              decoration: BoxDecoration(
                color: circleColor[entry.key], // Background color
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: koordinat[entry.key]['x'] == null 
                      ? Icon(Icons.check_box_outline_blank, color: Colors.white, size: 10)
                      : Icon(Icons.check_box, color: Colors.white, size: 10),
                  ),
                  Expanded(
                    child: Text(
                      labelKoordinat[entry.key]!,
                      style: TextStyle(fontWeight: FontWeight.bold, color: circleColor[entry.key] == AppColors.primary ? AppTextColors.onPrimary : AppTextColors.onTertiary, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "x: ${koordinat[entry.key]['x']}",
                      style: TextStyle(color: circleColor[entry.key] == AppColors.primary ? AppTextColors.onPrimary : AppTextColors.onTertiary, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "y: ${koordinat[entry.key]['y']}",
                      style: TextStyle(color: circleColor[entry.key] == AppColors.primary ? AppTextColors.onPrimary : AppTextColors.onTertiary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          ),

        latitudePosition != null ? Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
          width: double.infinity,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Terkini",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppTextColors.onPrimary, fontSize: 12),
                ),
              ),
              Expanded(
                child: Text(
                  "x: ${latitudePosition}",
                  style: TextStyle(color: AppTextColors.onPrimary, fontSize: 12),
                ),
              ),
              Expanded(
                child: Text(
                  "y: ${longitudePosition}",
                  style: TextStyle(color: AppTextColors.onPrimary, fontSize: 12),
                ),
              ),
            ],
          ),
        )
        : Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
        ),

        latitudePosition != null ? Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle the button press here
              setState(() {
                koordinat[selectedKoordinat]?['x'] = latitudePosition;
                koordinat[selectedKoordinat]?['y'] = longitudePosition;
              });
            },
            icon: Icon(Icons.location_on, color: Colors.white), // Location icon with white color
            label: Text('Tandai Lokasi', style: TextStyle(color: Colors.white)), // White text for contrast
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Set button color to primary
              foregroundColor: Colors.white, // Ensures text/icon color remains visible
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
          ),
        ) : SizedBox.shrink()
      ],
    );
  }
}

class CircleContainer extends StatefulWidget {
  final String position;
  final Map<String, Color> circleColor;
  final bool isChecked; // This will be the initial value for the checked state

  CircleContainer({
    required this.position,
    required this.circleColor,
    required this.isChecked,
  });

  @override
  _CircleContainerState createState() => _CircleContainerState();
}

class _CircleContainerState extends State<CircleContainer> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    // Initialize the checked state from the widget's initial value
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 20, // Circle diameter
        height: 20, // Circle diameter
        decoration: BoxDecoration(
          color: widget.circleColor[widget.position], // Set the background color based on state
          shape: BoxShape.circle, // Circular shape
        ),
        child: _isChecked
            ? Icon(Icons.check, color: Colors.white, size: 10)
            : null,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.secondary // Border color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dashWidth = 6.0; // Dash width
    final dashSpace = 4.0; // Space between dashes
    final radius = 0.0; // Corner radius for rounded corners

    // Create a rounded rectangle path
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)));

    // Get the path metrics for the rounded rectangle
    PathMetrics pathMetrics = path.computeMetrics();
    
    // Draw dashed border along the path
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        // Create the segment
        final pathSegment = pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(pathSegment, paint);
        distance += dashWidth + dashSpace; // Move by dash + space
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}