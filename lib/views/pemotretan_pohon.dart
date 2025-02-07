import 'dart:async';

import 'package:camera/camera.dart';
import 'package:diversitree_mobile/components/ringkasan_informasi.dart';
import 'package:diversitree_mobile/core/camera_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:diversitree_mobile/views/identifikasi_pohon.dart';
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

  void backFromCameraGallery() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void moveNewCapturedImage() {
    CameraService.newCapturedImagesLength += newCapturedImages.length;
    List<XFile> tempImages = List.from(newCapturedImages);
    newCapturedImages.clear();
    CameraService.newCapturedImages.addAll(tempImages);
  }

  late List<Map<String, dynamic>> listPohon;
  void reassignListPohon() {
    listPohon = widget.workspaceData["pohon"] is List
      ? (widget.workspaceData["pohon"] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList()
      : [];
  }

  // Method to update progress while saving images
  Completer<void>? _savingCompleter;
  Future<void> saveImages() async {
    print("berjalan ${_savingCompleter}");
    if (_savingCompleter != null && !_savingCompleter!.isCompleted) {
      moveNewCapturedImage();      
      backFromCameraGallery();

      return _savingCompleter!.future;
    }

    _savingCompleter = Completer<void>();

    backFromCameraGallery();

    moveNewCapturedImage();

    setState(() {
      CameraService.isSavingNewCapturedImages = true;
      CameraService.savedImages = 0;
    });

    while (CameraService.newCapturedImages.isNotEmpty) {
      var image = CameraService.newCapturedImages[0];
      
      await CameraService.saveCapturedImage(widget.workspaceData, image, widget.workspaceData["id"], null);
      
      setState(() {
        CameraService.savedImages++;
        CameraService.newCapturedImages.removeAt(0);
        reassignListPohon();
      });

      await Future.delayed(Duration(seconds: 1)); // Optional delay per image
    }

    setState(() {
      // CameraService.newCapturedImages.removeAt(0);
      CameraService.isSavingNewCapturedImages = false;
      CameraService.savedImages = 0;
      CameraService.newCapturedImagesLength = 0;

      reassignListPohon();
    });

    _savingCompleter?.complete();
    _savingCompleter = null;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Semua foto telah disimpan!"),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reassignListPohon();
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
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              childAspectRatio: 0.7, // Adjust this ratio to fit content properly
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: listPohon.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("widget.workspaceData ${widget.workspaceData['id']}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IdentifikasiPohon(workspaceData: widget.workspaceData, pohonData : listPohon[index], workspaceId : widget.workspaceData["id"]),
                    ),
                  );
                },
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          ApiService.urlStorage + listPohon[index]['path_foto'],
                          width: double.infinity, // Make image take full width of its parent
                          height: 260, // Adjust height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text("${listPohon[index]['nama_spesies'] ?? '-' }",
                                style: TextStyle(
                                  color: AppTextColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              Text("${listPohon[index]['dbh']} m²",
                                style: TextStyle(
                                  color: AppTextColors.onPrimary,
                                  fontSize: 8,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
  }
}