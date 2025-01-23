
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

const statusPekerjaan = ["Inisiasi Pekerjaan", "Menentukan Area", "Pemotretan Pohon", "Table Shanon Wanner"];

class StepperInformation extends StatelessWidget {
  final int urutan; // Accept the index/urutan

  const StepperInformation({
    super.key,
    required this.urutan, // Pass the urutan (index) as a parameter
  });

  // Calculate the percentage based on the index
  double getPercentage() {
    return urutan * 0.25; // Each step gets 25% progress
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        // BorderRadius only for the bottom corners
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40), // Bottom left corner
          bottomRight: Radius.circular(40), // Bottom right corner
        ),
        border: Border.all(
          color: AppColors.primary, // Circular border color
          width: 5, // Border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 16,),
            CustomPaint(
              size: Size(80, 80), // Set the size of the circle
              painter: CircleBorderPainter(percentage: getPercentage(), description: "${urutan}/4"),
            ),
            SizedBox(width: 32,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180), // Set max width here
                  child: Text(
                    statusPekerjaan[urutan -1],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Make the font size bigger
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                    softWrap: true, // Ensures the text wraps if needed
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180), // Set max width here
                  child: Text(
                    urutan != 4 ? "Selanjutnya: ${statusPekerjaan[urutan]}" : "Final",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                    softWrap: true, // Ensures the text wraps if needed
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircleBorderPainter extends CustomPainter {
  final double percentage;
  final String description;

  // Constructor accepting a percentage parameter
  CircleBorderPainter({required this.percentage, required this.description});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15; // Set the thickness of the border

    // Draw the background gray arc (90% of the circle)
    paint.color = Colors.white; // Set the color for the gray section
    double sweepAngle = 2 * 3.1416; // Full circle
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      0, // Start from the top (12 o'clock)
      sweepAngle, // Full circle, we will overwrite the start with the green arc
      false, // Do not connect the arc back to the start point
      paint,
    );

    // Draw the foreground green arc (10% of the circle)
    paint.color = Colors.green; // Set the color for the green section
    sweepAngle = percentage * 2 * 3.1416; // Custom percentage of the full circle's angle (360 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.1416 / 2, // Start at the top (12 o'clock position, -90 degrees in radians)
      sweepAngle, // The custom percentage (e.g., 10% of the circle)
      false, // Do not connect the arc back to the start point
      paint,
    );

    // Draw the centered text
    TextSpan textSpan = TextSpan(
      text: '${description}', // Text showing the percentage (e.g., 10%)
      style: TextStyle(
        color: Colors.white,
        fontSize: 16, // Font size for the text
        fontWeight: FontWeight.bold,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // Center the text in the middle of the circle
    double dx = (size.width - textPainter.width) / 2;
    double dy = (size.height - textPainter.height) / 2;

    // Draw the text on the canvas
    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}