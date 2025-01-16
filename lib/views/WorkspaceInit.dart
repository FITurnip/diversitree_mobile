import 'package:flutter/material.dart';

class WorkspaceInit extends StatefulWidget {
  @override
  _WorkspaceInitState createState() => _WorkspaceInitState();
}

class _WorkspaceInitState extends State<WorkspaceInit> {
  // Setting initial values for the controllers
  final TextEditingController workspaceController = TextEditingController(text: "Workspace A");
  final TextEditingController penganggungJawabController = TextEditingController(text: "--dummy--");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nama Workspace field (enabled) with default value
        TextFormField(
          controller: workspaceController,
          decoration: InputDecoration(
            labelText: "Nama Workspace",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Add border radius
            ),
          ),
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