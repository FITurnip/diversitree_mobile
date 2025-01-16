import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const MaterialApp(
        home: Center(child: CircularProgressIndicator()),
      );
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Camera preview
            CameraPreview(controller),

            // Bottom buttons
            Positioned(
              bottom: 30,
              left: 20,
              child: CircleButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  // Handle back button press
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: MediaQuery.of(context).size.width / 2 - 35,
              child: CircleButton(
                icon: Icons.camera_alt, // Camera icon with black color
                onPressed: () {
                  // Placeholder for picture-taking functionality
                  print("Take picture pressed");
                },
                isCircleInCircle: true, // This creates the inner circle effect
              ),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: BoxButton(
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCircleInCircle;

  const CircleButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isCircleInCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isCircleInCircle ? 80 : 60,
        height: isCircleInCircle ? 80 : 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: isCircleInCircle ? Border.all(color: Colors.black, width: 4) : null,
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black, // Inner circle with black color
            ),
            child: Icon(
              icon,
              color: Colors.black, // Icon color is now black
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class BoxButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BoxButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Box",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
