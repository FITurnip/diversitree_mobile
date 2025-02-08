import 'dart:convert';
import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/format_text_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:diversitree_mobile/views/workspace_master.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkspaceList extends StatefulWidget {
  @override
  _WorkspaceListState createState() => _WorkspaceListState();
}

class _WorkspaceListState extends State<WorkspaceList> {
  bool _isLoading = true;

  Future<void> _initializeWorkspace() async {
    await LocalDbService.dropDatabase();
    // Initialize workspace in initState using widget.workspaceTable
    await WorkspaceController.setStatusWorkspaceTable();
    await WorkspaceController.setWorkspaceTable();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeWorkspace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DiversitreeAppBar(),
      floatingActionButton: AddWorkspaceButton(),
      body: !_isLoading ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            childAspectRatio: 0.7, // Adjust this ratio to fit content properly
          ),
          itemCount: WorkspaceController.workspaceTable.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                WorkspaceController.goToWorkspace(context, WorkspaceController.workspaceTable[index]["id"]);
              },
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    LatestCapture(
                      url: WorkspaceController.workspaceTable[index]["foto_terakhir"] ?? null,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          WorkspaceController.statusWorkspaceTable.isNotEmpty
                              ? WorkspaceController.statusWorkspaceTable[WorkspaceController.workspaceTable[index]["urutan_status_workspace"] - 1]["nama_status"] ?? "-"
                              : "-",
                          style: TextStyle(
                            color: AppTextColors.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FormatTextService.formatDate(WorkspaceController.workspaceTable[index]["created_at"]),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              WorkspaceController.workspaceTable[index]["nama_workspace"] ?? "Tanpa Judul",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ) : Center(child: CircularProgressIndicator(color: AppColors.primary,)),
    );
  }
}


class LatestCapture extends StatelessWidget {
  final String? url;
  const LatestCapture({
    super.key, this.url,
  });

  String getUrl() {
    return url ?? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Image.network(
        getUrl(),
        width: double.infinity, // Make image take full width of its parent
        height: 260, // Adjust height as needed
        fit: BoxFit.cover,
      ),
    );
  }
}

class AddWorkspaceButton extends StatefulWidget {
  @override
  _AddWorkspaceButtonState createState() => _AddWorkspaceButtonState();
}

class _AddWorkspaceButtonState extends State<AddWorkspaceButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        WorkspaceController.goToWorkspace(context, "");
      },
      backgroundColor: AppColors.primary,
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}

class WorkspaceController {
  static List<Map<String, dynamic>> workspaceTable = [];
  static List<Map<String, dynamic>> statusWorkspaceTable = [];
  static Map<String, dynamic> workspaceData = {};

  static Future<void> setWorkspaceTable() async {
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

  static Future<void> setStatusWorkspaceTable() async {
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

  static void goToWorkspace(BuildContext context, String workspaceId) async {
    // prepare workspaceData
    if(workspaceId.isNotEmpty) {
      await setWorkspaceData(workspaceId);
    } else {
      workspaceData = {"id": null, "nama_workspace": ""};
      await WorkspaceService.saveInformasi(workspaceData);
    }

    // go to workspace
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkspaceMaster(urutanSaatIni: workspaceData["urutan_status_workspace"], workspaceData: workspaceData)),
    );

    // set new list
    var tempWorspacesData = await LocalDbService.getAll("workspaces");

    workspaceTable.clear();
    workspaceTable.addAll(tempWorspacesData);
  }


  static Future<void> setWorkspaceData (String workspaceId) async{
    var response = await ApiService.get('/workspace/detail/${workspaceId}');
    var responseData = json.decode(response.body);

    workspaceData = responseData["response"];
  }
}