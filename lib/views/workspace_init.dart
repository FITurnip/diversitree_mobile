import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/helper/format_text_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController penganggungJawabController = TextEditingController(text: "-");
  final TextEditingController createdAtWorkspaceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    workspaceData = widget.workspaceData;
    namaWorkspaceController.text = workspaceData["nama_workspace"] ?? "";
    createdAtWorkspaceController.text = workspaceData["created_at"] != null ? FormatTextService.formatDate(workspaceData["created_at"]) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nama Workspace field (enabled) with default value
        Container(
          height: 48,
          margin: EdgeInsets.only(
            bottom: 20
          ),
          child: TextFormField(
            controller: namaWorkspaceController,
            decoration: InputDecoration(
              labelText: "Nama Workspace",
              labelStyle: TextStyle(fontSize: 14, color: AppColors.primary),
              floatingLabelStyle: TextStyle(color: AppColors.primary),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Add border radius
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary), // Border when focused
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary), // Border when focused
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
        ),
        
        // Nama Penganggung Jawab field (disabled) with default value
        Container(
          height: 48,
          margin: EdgeInsets.only(
            bottom: 20
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    controller: penganggungJawabController,
                    decoration: InputDecoration(
                      labelText: "Nama Penganggung Jawab",
                      labelStyle: TextStyle(fontSize: 14, color: AppColors.secondary), // Default label color
                      floatingLabelStyle: TextStyle(color: AppColors.secondary), // Label when floating
                      floatingLabelBehavior: FloatingLabelBehavior.auto,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.secondary), // Default border
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.5), width: 1), // Border when disabled
                      ),
                    ),
                    cursorColor: AppColors.secondary, // Cursor color
                    style: TextStyle(color: AppColors.secondary), // Text input color
                    enabled: false, // This disables the field
                  )
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.group, color: Colors.white,size: 30), // Group icon,
                ),
              )
            ],
          ),
        ),

        Container(
          height: 48,
          margin: EdgeInsets.only(
            bottom: 20
          ),
          child: TextFormField(
            controller: createdAtWorkspaceController,
            decoration: InputDecoration(
              labelText: "Tanggal dibuat",
              labelStyle: TextStyle(fontSize: 14, color: AppColors.secondary),
              floatingLabelStyle: TextStyle(color: AppColors.secondary),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Add border radius
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.5), width: 1), // Border when disabled
              ),
              suffixIcon: Icon(Icons.calendar_today, color: AppColors.secondary),
            ),
            enabled: false,
          ),
        ),
      ],
    );
  }
}