import 'package:diversitree_mobile/components/StepperButton.dart';
import 'package:diversitree_mobile/components/StepperInformation.dart';
import 'package:diversitree_mobile/components/Header.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/views/PemotretanPohon.dart';
import 'package:diversitree_mobile/views/ShannonWannerTable.dart';
import 'package:diversitree_mobile/views/WorkspaceInit.dart';
import 'package:diversitree_mobile/views/MenentukanKoordinat.dart';
import 'package:flutter/material.dart';

class WorkspaceMaster extends StatefulWidget {
  // Constructor to accept the widget content
  WorkspaceMaster();

  @override
  _WorkspaceMasterState createState() => _WorkspaceMasterState();
}

class _WorkspaceMasterState extends State<WorkspaceMaster> {
  int urutanSaatIni = 1;

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
                        return WorkspaceInit();
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
              onStepChanged: (urutanTerbaru) {
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