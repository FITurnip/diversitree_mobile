// temporary, please fix this
import 'package:flutter/foundation.dart'; // Required for kDebugMode
import 'dart:convert';

import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:diversitree_mobile/views/home.dart'; // Import your Home page

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Map<String, dynamic>> workspaceTable = [];
  List<Map<String, dynamic>> statusWorkspaceTable = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  setWorkspaceTable() async {
    workspaceTable = await LocalDbService.getAll('workspaces');
    if (workspaceTable.isEmpty) {
      var response = await ApiService.get('/workspace/list');
      
      // Ensure the response body is valid JSON and is a list
      if (response.statusCode == 200) {
        try {
          var responseData = json.decode(response.body);

          // Check if the response is indeed a List
          if (responseData["response"] is List) {
            print("panjang response data ${responseData['response'].length}");
            // Now, we can safely cast it to List<Map<String, dynamic>>
            workspaceTable = List<Map<String, dynamic>>.from(responseData["response"]).map((record) {
              return {
                "id": record["id"],
                "urutan_status_workspace": record["urutan_status_workspace"],
                "nama_workspace": record["nama_workspace"],
                "updated_at": record["updated_at"],
                "created_at": record["created_at"],
              };
            }).toList();

            await LocalDbService.insertAll('workspaces', workspaceTable);
          } else {
            // Handle the case where the response data is not a list
            if (kDebugMode) {
              print('Unexpected response data format: Expected a List.');
            }
          }
        } catch (e) {
          // Handle JSON decoding errors
          if (kDebugMode) {
            print('Error decoding response body: $e');
          }
        }
      } else {
        // Handle the case where the API request fails
        if (kDebugMode) {
          print('API request failed with status code: ${response.statusCode}');
        }
      }
    }
  }

  setStatusWorkspaceTable() async {
    statusWorkspaceTable = await LocalDbService.getAll('status_workspaces');
    if (statusWorkspaceTable.isEmpty) {
      var response = await ApiService.get('/status-workspace/list');
      
      // Ensure the response body is valid JSON and is a list
      if (response.statusCode == 200) {
        try {
          var responseData = json.decode(response.body);

          // Check if the response is indeed a List
          if (responseData["response"] is List) {
            // Now, we can safely cast it to List<Map<String, dynamic>>
            statusWorkspaceTable = List<Map<String, dynamic>>.from(responseData["response"]).map((record) {
              return {
                "urutan": record["urutan"],
                "nama_status": record["nama_status"],
              };
            }).toList();

            await LocalDbService.insertAll('status_workspaces', statusWorkspaceTable);
          } else {
            // Handle the case where the response data is not a list
            if (kDebugMode) {
              print('Unexpected response data format: Expected a List.');
            }
          }
        } catch (e) {
          // Handle JSON decoding errors
          if (kDebugMode) {
            print('Error decoding response body: $e');
          }
        }
      } else {
        // Handle the case where the API request fails
        if (kDebugMode) {
          print('API request failed with status code: ${response.statusCode}');
        }
      }
    }
  }

  Future<void> _loadData() async {
    await LocalDbService.dropDatabase();
    await setWorkspaceTable();
    await setStatusWorkspaceTable();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home(workspaceTable: workspaceTable, statusWorkspaceTable: statusWorkspaceTable)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Applying a Linear Gradient to the background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF08CB4A), // Lighter green
              Color(0xFF046525), // Darker green
            ],
            begin: Alignment.topLeft, // Gradient starts from the top-left
            end: Alignment.bottomRight, // Gradient ends at the bottom-right
          ),
        ),
        child: Center(
          child: Image.asset(
            'storage/Logo_White.png', // Path to your PNG logo
            width: width * 0.75, // Logo width is 3/4 of the screen width
            height: width * 0.75, // Logo height matches the width for aspect ratio
            fit: BoxFit.contain, // Ensure the logo scales well
          ),
        ),
      ),
    );
  }
}