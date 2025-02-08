import 'package:diversitree_mobile/components/stepper_button.dart';
import 'package:diversitree_mobile/components/stepper_information.dart';
import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/core/workspace_service.dart';
import 'package:diversitree_mobile/views/workspace/pemotretan_pohon.dart';
import 'package:diversitree_mobile/views/workspace/shannon_wanner_table.dart';
import 'package:diversitree_mobile/views/workspace/workspace_init.dart';
import 'package:diversitree_mobile/views/workspace/menentukan_koordinat.dart';
import 'package:flutter/foundation.dart';
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
      appBar: DiversitreeAppBar(titleText: "Workspace"),
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
                  Container(
                    margin: EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0
                    ),
                    height: 40,
                    padding: EdgeInsets.only(left: 16.0, right: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.info,
                        width: 1.5, // Border width
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Baru di-update",
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12, // Customize font size if needed
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(Icons.refresh, color: AppColors.primary ,size: 24,), // Group icon,
                        )
                      ],
                    ),
                  ),

                  StepperInformation(urutan: urutanSaatIni),
            
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context) {
                      if (urutanSaatIni == 1)
                        return WorkspaceInit(workspaceData: workspaceData);
                      else if (urutanSaatIni == 2)
                        return MenentukanKoordinat(workspaceData: workspaceData);
                      else if (urutanSaatIni == 3)
                        return PemotretanPohon(workspaceData: workspaceData);
                      else
                        return ShannonWannerTable(workspaceData: workspaceData);
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
                if(kDebugMode) {
                  print("WorkspaceMaster: Data will saved ${workspaceData}");
                }
                
                if(urutanSaatIni == 1) await WorkspaceService.saveInformasi(workspaceData);
                else if(urutanSaatIni == 2) await WorkspaceService.saveKoordinat(workspaceData);
                else if(urutanSaatIni == 3) await WorkspaceService.saveFinalResult(workspaceData);

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