import 'package:flutter/material.dart';

class WorkspaceInit extends StatefulWidget {
  @override
  _WorkspaceInitState createState() => _WorkspaceInitState();
}

class _WorkspaceInitState extends State<WorkspaceInit> {
  @override
  Widget build(BuildContext context) {
    print("berhasil");
    return Scaffold(
      appBar: AppBar(title: Text("Workspace Initialization")),
      body: Center(
        child: Text(
          "You are on the Workspace Initialization page!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
