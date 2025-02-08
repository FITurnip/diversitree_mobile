
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraService {
  static List<XFile> newCapturedImages = [];
  static bool isSavingNewCapturedImages = false;
  static int savedImages = 0;
  static int newCapturedImagesLength = 0;
  static CameraDescription? _backCamera;

  static Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => throw Exception('No back camera found!'),
    );
  }

  static CameraDescription getBackCamera() {
    // We assume the camera is initialized or an exception will be thrown
    if (_backCamera == null) {
      throw Exception('Camera not initialized. Please initialize the cameras first.');
    }
    return _backCamera!;
  }

  static Future<String> saveImageToStorage(XFile file) async {
    // Get the app's document directory
    final directory = await getApplicationDocumentsDirectory();
    
    // Define a file name (you could use the original name or generate a new one)
    final fileName = basename(file.path);
    
    // Create a new file in the document directory
    final savedFile = File('${directory.path}/$fileName');
    
    // Copy the captured image to the new location
    await file.saveTo(savedFile.path);
    
    // Return the path of the saved file
    return savedFile.path;
  }
  
  static Future<void> saveCapturedImage
  (
    Map<String, dynamic> workspaceData,
    XFile image,
    String workspace_id,
    String? path_foto,
  ) async {
    await WorkspaceService.saveCapturedImage(workspaceData, image, workspace_id, path_foto ?? null);
  }
}