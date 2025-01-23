import 'dart:ui';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenentukanKoordinat extends StatefulWidget {
  @override
  _MenentukanKoordinatState createState() => _MenentukanKoordinatState();
}

class _MenentukanKoordinatState extends State<MenentukanKoordinat> {
  @override
  Widget build(BuildContext context) {
    return DashedBorderBox();
  }
}

enum CircleState { selected, unselected, filled }

class DashedBorderBox extends StatefulWidget {
  @override
  _DashedBorderBoxState createState() => _DashedBorderBoxState();
}

String ?selected_koordinat = null;

Map<String, dynamic> koordinat = {
  "kiri_atas": {"label": "Kiri Atas", "exist": false, "x": 0.00, "y": 0.00},
  "kanan_atas": {"label": "Kanan Atas", "exist": true, "x": 35.47, "y": 62.19},
  "kiri_bawah": {"label": "Kiri Bawah", "exist": false, "x": 0.00, "y": 0.00},
  "kanan_bawah": {"label": "Kanan Bawah", "exist": true, "x": 50.23, "y": 80.42}
};

Map<String, Color> circleColor = {
  "kiri_atas": AppColors.tertiary,
  "kanan_atas": AppColors.tertiary,
  "kiri_bawah": AppColors.tertiary,
  "kanan_bawah": AppColors.tertiary,
};
class _DashedBorderBoxState extends State<DashedBorderBox> {
  void updateColor() {
    setState(() {
      koordinat.forEach((key, value) {
        if(key == selected_koordinat) {
          circleColor[key] = AppColors.secondary;
        } else {
          if (value["exist"] == true) {
            circleColor[key] = AppColors.primary; 
          } else {
            circleColor[key] = AppColors.tertiary;
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    updateColor();

    // Debug print to check the updated map
    if (kDebugMode) {
      print(circleColor);
    }
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
                    child: CircleContainer(position: entry.key, onTap: () {updateColor();}),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: 32,),

        for (var entry in koordinat.entries)
          GestureDetector(
            onTap: () {
              setState(() {
                selected_koordinat = entry.key;
              });
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
                  Text(koordinat[entry.key]['label'], style: TextStyle(fontWeight: FontWeight.bold),),
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
              Text("x: 0.00", style: TextStyle(color: AppTextColors.onInfo)),
              Text("y: 0.00", style: TextStyle(color: AppTextColors.onInfo)),
            ],
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle the button press here
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
  final Function onTap;

  CircleContainer({required this.position, required this.onTap});

  @override
  _CircleContainerState createState() => _CircleContainerState();
}

class _CircleContainerState extends State<CircleContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected_koordinat = widget.position;
        });
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 20, // Circle diameter
          height: 20, // Circle diameter
          decoration: BoxDecoration(
            color: circleColor[widget.position], // Set the background color based on state
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

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Dashed Border with Circle Containers on Corners")),
      body: Center(child: MenentukanKoordinat()),
    ),
  ));
}
