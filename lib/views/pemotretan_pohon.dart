import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/ringkasan_informasi.dart';
import 'package:diversitree_mobile/core/camera_services.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:flutter/material.dart';

class PemotretanPohon extends StatefulWidget {
  final Map<String, dynamic> workspaceData;
  PemotretanPohon({required this.workspaceData});
  @override
  _PemotretanPohonState createState() => _PemotretanPohonState();
}

class _PemotretanPohonState extends State<PemotretanPohon> {
  double infoSize = 56.0;

  List<XFile> newCapturedImages = [];
  bool isSavingNewCapturedImages = false;
  int savedImages = 0;

  // Method to update progress while saving images
  Future<void> saveImages() async {
    Navigator.pop(context);
    Navigator.pop(context);

    print("saving start here...===============================================================");
    setState(() {
      isSavingNewCapturedImages = true;
      savedImages = 0;
    });

    // Save images one by one
    for (int i = 0; i < newCapturedImages.length; i++) {
      setState(() {
        savedImages++;
      });

      print(
        "${newCapturedImages[i]} ${widget.workspaceData['id']}",
      );

      await CameraServices.saveCapturedImage(
        newCapturedImages[i],
        widget.workspaceData["id"],
      );

      // var response = await CameraServices.saveCapturedImage(
      //   newCapturedImages[i],
      //   widget.workspaceData["id"],
      // );
      // var responseData = json.decode(response.body);

      // // Ensure the 'pohon' key exists and is a List
      // if (widget.workspaceData["pohon"] is List) {
      //   // Add the decoded response data to the 'pohon' list
      //   widget.workspaceData["pohon"].add(responseData);
      // } else {
      //   // Initialize 'pohon' as a list if it doesn't exist
      //   widget.workspaceData["pohon"] = [responseData];
      // }

      // print("newVal: ${widget.workspaceData}");

      // Simulate saving process with a delay (replace with actual saving logic)
      await Future.delayed(Duration(seconds: 1));
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("All images saved successfully!"),
    ));

    
    setState(() {
      isSavingNewCapturedImages = false;
      savedImages = 0;
      newCapturedImages.clear();
    });
  }

  late List<Map<String, dynamic>> listPohon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listPohon = widget.workspaceData["pohon"] is List
      ? (widget.workspaceData["pohon"] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList()
      : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RingkasanInformasi(infoSize: infoSize, showCamera: true, workspaceData: widget.workspaceData, newCapturedImages: newCapturedImages, saveCapturedImage: () {saveImages();}),

          Container(margin: EdgeInsets.only(bottom: 8.0), child: Text('Daftar Pohon', style: AppTextStyles.heading1,)),

          if(isSavingNewCapturedImages) Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                CircularProgressIndicator(), // Progress bar
                SizedBox(width: 32.0),
                Text(
                  'Menyimpan... ${savedImages}/${newCapturedImages.length} foto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.65,
            ),
            itemCount: listPohon.length,
            shrinkWrap: true,  // Ensures GridView is sized correctly
            physics: NeverScrollableScrollPhysics(), // Disables internal scroll
            itemBuilder: (context, index) {
              return Card(
                // color: AppColors.tertiary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                        child: Image.network(
                          ApiService.urlStorage + listPohon[index]['path_foto'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${listPohon[index]['nama_spesies']}"),
                          Text("Dbh: ${listPohon[index]['dbh']} m2"),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
                        decoration: BoxDecoration(
                          color: AppColors.info,  // Set the static background color here
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.visibility, color: Colors.white,),  // Use visibility icon for 'view'
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Button pressed for item $index')),
                            );
                          },
                        ),
                      )
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
  }
}
