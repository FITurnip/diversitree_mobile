import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Add this import

class WorkspaceTim extends StatefulWidget {
  final String workspaceId;

  WorkspaceTim({super.key, required this.workspaceId, });

  @override
  _WorkspaceTimState createState() => _WorkspaceTimState();
}

class _WorkspaceTimState extends State<WorkspaceTim> {
  List<Map<String, dynamic>> listAnggota = [];
  
  // Declare a Timer variable
  Timer? _timer;

  // Function to fetch the list of anggota
  Future<void> _initListAnggota() async {
    var response = await WorkspaceTimService.getList(widget.workspaceId);
    setState(() {
      listAnggota.clear(); // Clear the list before adding new data
      listAnggota.addAll(response);
    });
  }

  // Function to load the QR code image
  Image? qrCode;
  Future<void> _loadImage() async {
    String url = ApiService.getPath('/workspace/tim/qr-code/${widget.workspaceId}');
    String? token = await AuthService.getToken();

    setState(() {
      qrCode = Image.network(
        url,
        width: 200,
        height: 200,
        headers: {
          "Authorization": "Bearer $token",
        },
        fit: BoxFit.contain,
      );
    });
  }

  // Initialize content and set the periodic refetching of anggota list
  Future<void> _initContent() async {
    await _loadImage();
    await _initListAnggota();

    // Set up periodic refetch every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _initListAnggota(); // Refresh the list
    });
  }

  @override
  void initState() {
    super.initState();
    _initContent();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiversitreeAppBar(titleText: "Anggota Tim"),
      backgroundColor: AppColors.lightPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pindai QR untuk bergabung',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            width: 240,
            height: 240,
            alignment: Alignment.center,
            child: qrCode != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: qrCode,
                  )
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  listAnggota.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: listAnggota.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(listAnggota[index]['name']!),
                                subtitle: Text(listAnggota[index]['email']!),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Belum ada anggota',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
