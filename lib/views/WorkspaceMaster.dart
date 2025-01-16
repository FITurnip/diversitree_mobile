import 'package:diversitree_mobile/components/StepperInformation.dart';
import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/core/styles.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepperInformation(urutan: urutanSaatIni),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(builder: (context) {
                if(urutanSaatIni == 1) return WorkspaceInit();
                else return MenentukanKoordinat();
              })
            ),
          ),

          Column(
            children: [
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * (urutanSaatIni / 4),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                
                Container(
                  width: MediaQuery.of(context).size.width * ((4 - urutanSaatIni) / 4),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ],),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // "Sebelumnya" button with white background, border, and 50% width
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45, // 45% width
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (urutanSaatIni > 1) urutanSaatIni--;
                          });
                        },
                        child: Text("Sebelumnya"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // White background
                          foregroundColor: AppColors.primary, // Black text color
                          side: BorderSide(color: AppColors.primary, width: 2), // Black border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                      ),
                    ),
                    
                    // "Selanjutnya" button with green background, border, and 50% width
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45, // 45% width
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (urutanSaatIni < 4) urutanSaatIni++;
                          });
                        },
                        child: Text("Selanjutnya"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // Green background
                          foregroundColor: Colors.white, // White text color
                          side: BorderSide(color: AppColors.primary, width: 2), // Green border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
