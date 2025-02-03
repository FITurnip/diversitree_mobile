import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img; 

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
  
  // static Future<dynamic> saveCapturedImage(XFile image, String workspace_id) async {
  //   // // Save the image to storage
  //   // String savedPath = await saveImageToStorage(image);
    
  //   // // Insert the saved path into SQLite database
  //   // await LocalDbService.insert('photo', {
  //   //   'workspace_id': workspace_id,
  //   //   'photo_path': savedPath,
  //   //   'spesies': "-",
  //   //   'diameter': 0.0,
  //   // });

  //   // final imageBytes = await image.readAsBytes();
  //   // String base64Image = base64Encode(imageBytes);

  //   String filePath = image.path;
  //   String fileName = image.name;

  //   final File file = File(filePath);
  //   List<int> imageBytes = await file.readAsBytes();
  //   String base64Image = base64Encode(imageBytes);


  //   return await ApiService.post("/workspace/save-pohon", {
  //     "foto": base64Image,
  //     "id": workspace_id,
  //   });
  // }

  static Future<dynamic> saveCapturedImage(XFile image, String workspace_id) async {
    // String filePath = image.path;
    // String fileName = image.name;

    // final File file = File(filePath);
    // List<int> imageBytes = await file.readAsBytes();

    // // Decode the image using the image package
    // img.Image? imageDecoded = img.decodeImage(Uint8List.fromList(imageBytes));

    // if (imageDecoded == null) {
    //   throw Exception("Failed to decode image");
    // }

    // // Resize the image to a smaller width and height (e.g., 600px wide)
    // int width = 600;
    // int height = (imageDecoded.height * width) ~/ imageDecoded.width;

    // img.Image resizedImage = img.copyResize(imageDecoded, width: width, height: height);

    // // Encode the resized image to JPEG or PNG
    // List<int> resizedImageBytes = img.encodeJpg(resizedImage, quality: 85); // You can adjust the quality

    // // Convert the resized image to base64
    // String base64Image = base64Encode(resizedImageBytes);

    // print("base64Image ${base64Image}");

    // Send the resized base64 image to your API
    return await ApiService.post("/workspace/save-pohon", {
      "foto": image,
      "id": workspace_id,
    });
  }
}