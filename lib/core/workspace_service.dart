import 'dart:convert';
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

  // Static method to save workspace information
  static Future<void> saveInformasi(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-informasi', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      // Instead of reassigning workspaceData, update its contents
      workspaceData.clear(); // Clear the original map
      workspaceData.addAll(Map<String, dynamic>.from(responseData["response"]));
      
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
      print("Updated Workspace Data: ${workspaceData}");
    }
  }

  static Future<void> saveKoordinat(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-koordinat', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      // Update the workspaceData with the response
      workspaceData = Map<String, dynamic>.from(responseData["response"]);
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }

  static Future<void> saveFinalResult(Map<String, dynamic> workspaceData) async {
    var response = await ApiService.post('/workspace/save-final-result', workspaceData);
    var responseData = json.decode(response.body);

    if (responseData["response"] is Map) {
      // Update the workspaceData with the response
      workspaceData = Map<String, dynamic>.from(responseData["response"]);
      // Call updateOnDatabase method after getting the response
      await updateOnDatabase(workspaceData);
    }
  }
}
