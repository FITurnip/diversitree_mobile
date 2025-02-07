import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';

class WorkspaceService {
  // Static method to update the database
  static Future<void> updateOnDatabase(Map<String, dynamic> workspaceData) async {
    Map<String, dynamic> workspaceOnDb = {
      "id": workspaceData["id"],
      "urutan_status_workspace": workspaceData["urutan_status_workspace"],
      "nama_workspace": workspaceData["nama_workspace"],
      "updated_at": workspaceData["updated_at"],
      "created_at": workspaceData["created_at"],
    };

    await LocalDbService.insertOrUpdate('workspaces', workspaceOnDb);
  }

  static void reassignWorkspaceData(workspaceData, responseData) {
    // Instead of reassigning workspaceData, update its contents
    workspaceData.clear(); // Clear the original map
    workspaceData.addAll(Map<String, dynamic>.from(responseData["response"]));
  }

  // Static method to save workspace information
  static Future<void> saveInformasi(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-informasi', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      reassignWorkspaceData(workspaceData, responseData);

      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }

  static Future<void> saveKoordinat(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-koordinat', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      reassignWorkspaceData(workspaceData, responseData);
      
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }

  static Future<void> saveFinalResult(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-final-result', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      reassignWorkspaceData(workspaceData, responseData);
      
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }

  static Future<void> saveCapturedImage(Map<String, dynamic> workspaceData, XFile image, String workspace_id, String? path_foto) async {
    var response = await ApiService.post("/workspace/save-pohon", {
      "foto": image,
      "id": workspace_id,
      "path_foto": path_foto,
    });var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      reassignWorkspaceData(workspaceData, responseData);
      
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }
}
