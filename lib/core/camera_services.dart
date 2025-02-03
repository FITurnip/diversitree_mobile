
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraServices {
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
  
  static Future<dynamic> saveCapturedImage(XFile image, String workspace_id) async {
    return await ApiService.post("/workspace/save-pohon", {
      "foto": image,
      "id": workspace_id,
    });
  }
}