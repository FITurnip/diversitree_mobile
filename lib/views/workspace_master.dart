import 'dart:convert';

import 'package:diversitree_mobile/components/stepper_button.dart';
import 'package:diversitree_mobile/components/stepper_information.dart';
import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/helper/local_db_service.dart';
import 'package:diversitree_mobile/views/pemotretan_pohon.dart';
import 'package:diversitree_mobile/views/shannon_wanner_table.dart';
import 'package:diversitree_mobile/views/workspace_init.dart';
import 'package:diversitree_mobile/views/menentukan_koordinat.dart';
import 'package:flutter/material.dart';

class WorkspaceMaster extends StatefulWidget {
  // Constructor to accept the widget content
  final int urutanSaatIni;
  final Map<String, dynamic> workspaceData;

  WorkspaceMaster({required this.urutanSaatIni, required this.workspaceData});

  @override
  _WorkspaceMasterState createState() => _WorkspaceMasterState();
}

class _WorkspaceMasterState extends State<WorkspaceMaster> {
  late int urutanSaatIni;
  Map<String, dynamic> workspaceData = {};
  
  @override
  void initState() {
    super.initState();
    urutanSaatIni = widget.urutanSaatIni;
    workspaceData = widget.workspaceData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(titleText: "Workspace"),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepperInformation(urutan: urutanSaatIni),
            
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context) {
                      if (urutanSaatIni == 1)
                        return WorkspaceInit(workspaceData: workspaceData);
                      else if (urutanSaatIni == 2)
                        return MenentukanKoordinat();
                      else if (urutanSaatIni == 3)
                        return PemotretanPohon();
                      else
                        return ShannonWannerTable();
                    }),
                  ),
                  SizedBox(height: 200,),
                ],
              ),
            ),
          ),

          // Aligning the StepperButton at the bottom of the screen
          Positioned(
            bottom: 0,
            child: StepperButton(
              urutanSaatIni: urutanSaatIni,
              onStepChanged: (urutanTerbaru) async {
                if(urutanSaatIni == 1) await WorkspaceService.saveInformasi(workspaceData);
                setState(() {
                  urutanSaatIni = urutanTerbaru;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}