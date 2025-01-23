import 'package:flutter/material.dart';

class WorkspaceInit extends StatefulWidget {
  final Map<String, dynamic> workspaceData;

  WorkspaceInit({required this.workspaceData});
  @override
  _WorkspaceInitState createState() => _WorkspaceInitState();
}

class _WorkspaceInitState extends State<WorkspaceInit> {
  Map<String, dynamic> workspaceData = {};

  // Setting initial values for the controllers
  final TextEditingController namaWorkspaceController = TextEditingController();
  final TextEditingController penganggungJawabController = TextEditingController(text: "--dummy--");

  @override
  void initState() {
    super.initState();
    workspaceData = widget.workspaceData;
    namaWorkspaceController.text = workspaceData["nama_workspace"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nama Workspace field (enabled) with default value
        TextFormField(
          controller: namaWorkspaceController,
          decoration: InputDecoration(
            labelText: "Nama Workspace",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Add border radius
            ),
          ),
          onChanged: ((value) => {
            setState(() {
              // Update workspaceData whenever the input changes
              workspaceData["nama_workspace"] = value;
              // widget.workspaceData["nama_workspace"] = value;
            })
          }),
        ),
        
        SizedBox(height: 20),

        // Nama Penganggung Jawab field (disabled) with default value
        TextFormField(
          controller: penganggungJawabController,
          decoration: InputDecoration(
            labelText: "Nama Penganggung Jawab",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Add border radius
            ),
          ),
          enabled: false, // This disables the field
        ),
      ],
    );
  }
}