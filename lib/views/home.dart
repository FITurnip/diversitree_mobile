import 'dart:convert';

import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/format_text_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:diversitree_mobile/views/workspace_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  final List<Map<String, dynamic>> workspaceTable;
  final List<Map<String, dynamic>> statusWorkspaceTable;

  // Update the constructor to accept workspaceTable as a parameter
  const Home({super.key, required this.workspaceTable, required this.statusWorkspaceTable});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String ?selectedValue;

  // Declare workspace without initialization
  late List<Map<String, dynamic>> workspace;
  late List<Map<String, dynamic>> statusWorkspace;

  @override
  void initState() {
    super.initState();
    // Initialize workspace in initState using widget.workspaceTable
    workspace = widget.workspaceTable;
    statusWorkspace = widget.statusWorkspaceTable;
  }

  int currentPage = 1, lowerBoundIndex = 0, upperBoundIndex = 4;

  Map<String, dynamic> workspaceData = {};

  Future<void> setWorkspaceData (String workspaceId) async{
    var response = await ApiService.get('/workspace/detail/${workspaceId}');
    var responseData = json.decode(response.body);

    workspaceData = responseData["response"];
  }

  void goToWorkspace(int urutanDibuka, String workspaceId) async {
    // prepare workspaceData
    if(workspaceId.isNotEmpty) {
      await setWorkspaceData(workspaceId);
    } else {
      workspaceData = {"id": null, "nama_workspace": ""};
      await WorkspaceService.saveInformasi(workspaceData);
      print("Real Updated Workspace Data: ${workspaceData}");
    }

    // go to workspace
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkspaceMaster(urutanSaatIni: urutanDibuka, workspaceData: workspaceData)),
    );

    // set new list
    var tempWorspacesData = await LocalDbService.getAll("workspaces");

    setState(() {
      workspace.clear();
      workspace.addAll(tempWorspacesData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workspace',
                      style: AppTextStyles.heading1
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        goToWorkspace(1, "");
                      },
                      label: Text("Tambah"), icon: Icon(Icons.add, color: Colors.white),style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white
                    ),)
                  ],
                ),

                // Text(
                //   'Filter',
                //   style: AppTextStyles.secondaryText,
                // ),
                // SizedBox(height: 20),
                // DropdownButtonFormField<String>(
                //   value: selectedValue,
                //   decoration: InputDecoration(
                //     labelText: "Pilih Status",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   items: statusWorkspace.map((status) {
                //     return DropdownMenuItem<String>(
                //       value: status['nama_status'],
                //       child: Text(status['nama_status']),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       selectedValue = newValue!;
                //     });
                //   },
                // ),
            
                SizedBox(height: 20),
            
                TextField(
                  decoration: InputDecoration(
                    labelText: "Cari", // Floating label
                    suffixIcon: Icon(Icons.search), // Search icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded border
                    ),
                  ),
                ),
            
                SizedBox(height: 20),
            
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: workspace.length,
                    itemBuilder: (context, index) {
                      if (index < lowerBoundIndex || index > upperBoundIndex) return null;

                      return Slidable(
                        key: Key(workspace[index]["id"].toString()), // Unique key for sliding
                        endActionPane: ActionPane(
                          motion: ScrollMotion(), // Smooth slide animation
                          children: [
                            Container(
                              child: SlidableAction(
                                onPressed: (context) {
                                  // deleteWorkspace(workspace[index]["id"]); // Delete on tap
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                borderRadius: BorderRadius.circular(12),
                                padding: EdgeInsets.all(0),
                              ),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            goToWorkspace(workspace[index]["urutan_status_workspace"], workspace[index]["id"]);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LatestCapture(url: workspace[index]["foto_terakhir"] ?? null),
                                  ),
                                  SizedBox(width: 12), // Spacing between image and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workspace[index]["nama_workspace"] ?? "Tanpa Judul",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          FormatTextService.formatDate(workspace[index]["created_at"]),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        // Status Badge
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            statusWorkspace.isNotEmpty
                                                ? statusWorkspace[workspace[index]["urutan_status_workspace"] - 1]["nama_status"] ?? "-"
                                                : "-",
                                            style: TextStyle(
                                              color: AppTextColors.onPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Icon(Icons.remove_red_eye),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
                SizedBox(height: 50),
              ],
            ),
          ),


          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    child: Icon(Icons.arrow_left, color: AppColors.primary),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text(
                    '${lowerBoundIndex + 1}-${upperBoundIndex + 1} dari ${workspace.length}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    child: Icon(Icons.arrow_right, color: AppColors.primary),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
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
    return Image.network(
      getUrl(),
      width: 64,
      height: 72,
      fit: BoxFit.cover,
    );
  }
}