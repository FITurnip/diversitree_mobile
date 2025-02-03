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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    child: CircleContainer(position: entry.key, onTap: () {updateColor();}, selectKoordinat: (newSelectedKoordinat) {selectKoordinat(newSelectedKoordinat);}, circleColor: circleColor),
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
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 2.0),
              width: double.infinity,
              height: 32,
              color: circleColor[entry.key],
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10.0, // Space between columns
                  mainAxisSpacing: 10.0, // Space between rows
                ),
                children: [
                  Text(labelKoordinat[entry.key]!, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("x: ${koordinat[entry.key]['x']}"),
                  Text("y: ${koordinat[entry.key]['y']}"),
                ],
              ),
            ),
          ),

        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          width: double.infinity,
          height: 32,
          color: AppColors.info,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 10.0, // Space between columns
              mainAxisSpacing: 10.0, // Space between rows
            ),
            children: [
              Text("Terkini", style: TextStyle(fontWeight: FontWeight.bold, color: AppTextColors.onInfo),),
              Text("x: ${latitudePosition}", style: TextStyle(color: AppTextColors.onInfo)),
              Text("y: ${longitudePosition}", style: TextStyle(color: AppTextColors.onInfo)),
            ],
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle the button press here
              setState(() {
                koordinat[selectedKoordinat]?['x'] = latitudePosition;
                koordinat[selectedKoordinat]?['y'] = longitudePosition;
              });
            },
            icon: Icon(Icons.location_on), // Location icon
            label: Text('Tandai Lokasi'),
          ),
        )
      ],
    );
  }
}

class CircleContainer extends StatefulWidget {
  final String position;
  final Function(String) selectKoordinat;
  final Function onTap;
  final Map<String, Color> circleColor;

  CircleContainer({required this.position, required this.onTap, required this.selectKoordinat, required this.circleColor});

  @override
  _CircleContainerState createState() => _CircleContainerState();
}

class _CircleContainerState extends State<CircleContainer> {
  late String selectedKoordinat;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectKoordinat(widget.position);
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 20, // Circle diameter
          height: 20, // Circle diameter
          decoration: BoxDecoration(
            color: widget.circleColor[widget.position], // Set the background color based on state
            shape: BoxShape.circle, // Circular shape
            border: Border.all(color: Colors.grey.shade900, width: 2.0), // Border for the circle
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black // Border color
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