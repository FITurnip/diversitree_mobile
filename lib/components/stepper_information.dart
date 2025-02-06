import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedCircleBorderPainter extends StatefulWidget {
  final double percentage;
  final String description;

  const AnimatedCircleBorderPainter({
    Key? key,
    required this.percentage,
    required this.description,
  }) : super(key: key);

  @override
  _AnimatedCircleBorderPainterState createState() => _AnimatedCircleBorderPainterState();
}

class _AnimatedCircleBorderPainterState extends State<AnimatedCircleBorderPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(56, 56),
          painter: CircleBorderPainter(percentage: _animation.value, description: widget.description),
        );
      },
    );
  }
}

class CircleBorderPainter extends CustomPainter {
  final double percentage;
  final String description;

  CircleBorderPainter({required this.percentage, required this.description});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Draw background circle
    paint.color = Colors.white;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      0,
      2 * pi,
      false,
      paint,
    );

    // Draw animated progress arc
    paint.color = AppColors.info;
    double sweepAngle = percentage * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );

    // Draw centered text
    TextSpan textSpan = TextSpan(
      text: description,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    double dx = (size.width - textPainter.width) / 2;
    double dy = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

const statusPekerjaan = ["Inisiasi Pekerjaan", "Menentukan Area", "Pemotretan Pohon", "Table Shanon Wanner"];

class StepperInformation extends StatelessWidget {
  final int urutan;

  const StepperInformation({
    super.key,
    required this.urutan,
  });

  double getPercentage() {
    return urutan * 0.25;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.0,
      margin: EdgeInsets.only(bottom: 8, top: 4, left: 8, right: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            AnimatedCircleBorderPainter(
              percentage: getPercentage(),
              description: "$urutan/4",
            ),
            SizedBox(width: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    statusPekerjaan[urutan - 1],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    urutan != 4 ? "Selanjutnya: ${statusPekerjaan[urutan]}" : "Final",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    softWrap: true,
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
