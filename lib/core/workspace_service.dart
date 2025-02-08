import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';

class WorkspaceService {
  // Static method to update the database
  static Future<void> _updateOnDatabase(Map<String, dynamic> workspaceData) async {
    Map<String, dynamic> workspaceOnDb = {
      "id": workspaceData["id"],
      "urutan_status_workspace": workspaceData["urutan_status_workspace"],
      "nama_workspace": workspaceData["nama_workspace"],
      "updated_at": workspaceData["updated_at"],
      "created_at": workspaceData["created_at"],
    };

    await LocalDbService.insertOrUpdate('workspaces', workspaceOnDb);
  }

  static void _reassignWorkspaceData(workspaceData, response) {
    // Instead of reassigning workspaceData, update its contents
    workspaceData.clear(); // Clear the original map
    workspaceData.addAll(Map<String, dynamic>.from(response));
  }

  static Future<void> _refreshLocaldata(var response, Map<String, dynamic> workspaceData) async {
    if (response is Map) {
      _reassignWorkspaceData(workspaceData, response);

      // Call _updateOnDatabase method after getting the response
      await _updateOnDatabase(workspaceData);
    }
  }

  static Future<void> _saveData(Map<String, dynamic> workspaceData, String url) async {
    var response = await ApiService.post(url, workspaceData, withAuth: true);
    var responseData = json.decode(response.body);
    await _refreshLocaldata(responseData["response"], workspaceData);
  }

  static Future<void> saveInformasi(Map<String, dynamic> workspaceData) async {
    _saveData(workspaceData, '/workspace/save-informasi');
  }

  static Future<void> saveKoordinat(Map<String, dynamic> workspaceData) async {
    _saveData(workspaceData, '/workspace/save-koordinat');
  }

  static Future<void> saveFinalResult(Map<String, dynamic> workspaceData) async {
    _saveData(workspaceData, '/workspace/save-final-result');
  }

  static Future<void> saveCapturedImage(Map<String, dynamic> workspaceData, XFile image, String workspaceId, String? pathFoto) async {
    var response = await ApiService.post("/workspace/save-pohon", {
      "foto": image,
      "id": workspaceId,
      "path_foto": pathFoto,
    }, withAuth: true);
    var responseData = json.decode(response.body);

    await _refreshLocaldata(responseData["response"], workspaceData);
  }
}

class WorkspaceTimService {
  static Future<dynamic> _hitApi(String workspaceId, String url) async {
    var response = await ApiService.post(url, {"workspace_id": workspaceId}, withAuth: true);
    return response;
  }

  static Future<List<Map<String, dynamic>>> getList(String workspaceId) async {
    var response = await _hitApi(workspaceId, '/workspace/tim/list');
    var responseData = json.decode(response.body);
    if (responseData['response'] is List<Map<String, dynamic>>) {
      return (responseData['response'] as List)
          .map((e) => e as Map<String, dynamic>) // Ensures correct type
          .toList();
    } else {
      throw Exception("Unexpected responseData['response'] format: ${responseData['response']}");
    }
  }

  static Future<List<Map<String, dynamic>>> addToTim(String workspaceId) async {
    return await _hitApi(workspaceId, '/workspace/tim/tambah-anggota');
  }
}