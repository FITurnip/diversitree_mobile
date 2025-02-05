import 'dart:convert';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/ringkasan_informasi.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
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

  // Method to update progress while saving images
  Completer<void>? _savingCompleter;
  Future<void> saveImages() async {
    print("berjalan ${_savingCompleter}");
    if (_savingCompleter != null && !_savingCompleter!.isCompleted) {
      CameraService.newCapturedImagesLength += newCapturedImages.length;
      List<XFile> tempImages = List.from(newCapturedImages);
      newCapturedImages.clear();
      CameraService.newCapturedImages.addAll(tempImages);

      Navigator.pop(context);
      Navigator.pop(context);

      return _savingCompleter!.future;
    }

    _savingCompleter = Completer<void>();

    Navigator.pop(context);
    Navigator.pop(context);

    CameraService.newCapturedImagesLength += newCapturedImages.length;
    List<XFile> tempImages = List.from(newCapturedImages);
    newCapturedImages.clear();
    CameraService.newCapturedImages.addAll(tempImages);

    setState(() {
      CameraService.isSavingNewCapturedImages = true;
      CameraService.savedImages = 0;
    });

    while (CameraService.newCapturedImages.isNotEmpty) {
      var image = CameraService.newCapturedImages.removeAt(0);;
      
      await CameraService.saveCapturedImage(widget.workspaceData, image, widget.workspaceData["id"]);
      
      setState(() {
        CameraService.savedImages++;
        listPohon = widget.workspaceData["pohon"] is List
          ? (widget.workspaceData["pohon"] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList()
          : [];
        
      });

      await Future.delayed(Duration(seconds: 1)); // Optional delay per image
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("All images saved successfully!"),
    ));

    setState(() {
      CameraService.isSavingNewCapturedImages = false;
      CameraService.savedImages = 0;
      CameraService.newCapturedImagesLength = 0;

      listPohon = widget.workspaceData["pohon"] is List
        ? (widget.workspaceData["pohon"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
        : [];
    });

    _savingCompleter?.complete();
    _savingCompleter = null;
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
          RingkasanInformasi(
            infoSize: infoSize,
            showCamera: true,
            workspaceData: widget.workspaceData,
            newCapturedImages: newCapturedImages,
            saveCapturedImage: () {
              saveImages();
            }),

          Container(margin: EdgeInsets.only(bottom: 8.0), child: Text('Daftar Pohon', style: AppTextStyles.heading1,)),

          if(CameraService.isSavingNewCapturedImages) Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                CircularProgressIndicator(), // Progress bar
                SizedBox(width: 32.0),
                Text(
                  'Menyimpan... ${CameraService.savedImages}/${CameraService.newCapturedImagesLength} foto',
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