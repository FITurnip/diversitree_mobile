import 'dart:convert';

import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/format_text_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:diversitree_mobile/views/workspace_master.dart';
import 'package:flutter/material.dart';

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
      MaterialPageRoute(
        builder: (context) => WorkspaceMaster(urutanSaatIni: urutanDibuka, workspaceData: workspaceData)),
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
              child: Text(
                'Menu',  // Title for the drawer
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pengguna'),
            ),
            SizedBox(height: 4),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Cari workspace", // Floating label
                      suffixIcon: Icon(Icons.search), // Search icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary), // Border color when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppColors.primary), // Border color when focused
                      ),
                      suffixIconColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    ),
                  ),
                ),
            
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      childAspectRatio: 0.7, // Adjust this ratio to fit content properly
                    ),
                    itemCount: workspace.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          goToWorkspace(workspace[index]["urutan_status_workspace"], workspace[index]["id"]);
                        },
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              LatestCapture(
                                url: workspace[index]["foto_terakhir"] ?? null,
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
                                    statusWorkspace.isNotEmpty
                                        ? statusWorkspace[workspace[index]["urutan_status_workspace"] - 1]["nama_status"] ?? "-"
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
                                        FormatTextService.formatDate(workspace[index]["created_at"]),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        workspace[index]["nama_workspace"] ?? "Tanpa Judul",
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
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToWorkspace(1, "");
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
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