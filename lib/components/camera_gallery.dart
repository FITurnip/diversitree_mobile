import 'dart:io';
import 'package:diversitree_mobile/components/header.dart';
import 'package:diversitree_mobile/components/photo_view.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraGallery extends StatefulWidget {
  final List<XFile> images;
  final Function() saveImages;

  CameraGallery({required this.images, required this.saveImages});

  @override
  _CameraGalleryState createState() => _CameraGalleryState();
}

class _CameraGalleryState extends State<CameraGallery> {
  int imagesSaved = 0; // Track the number of saved images

  @override
  void initState() {
    super.initState();
    print("masuk gallery");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(titleText: "Foto Terbaru"),
      body: widget.images.isEmpty
          ? Center(child: Text('Belum ada foto diambil!'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.saveImages();
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text(
                            "Tambah ke Workspace",  // Abbreviated text
                            style: TextStyle(color: Colors.white, fontSize: 12),  // Smaller font size
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    Text("Jumlah Pohon: ${widget.images.length}"),
                    SizedBox(height: 8.0,),
                    Center(
                      child: Wrap(
                        spacing: 4, // Space between items horizontally
                        runSpacing: 4, // Space between lines vertically
                        children: List.generate(widget.images.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewPage(image: widget.images[index]),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Optional rounded corners
                              child: Container(
                                width: (MediaQuery.of(context).size.width / 4) - 8,
                                child: Image.file(
                                  File(widget.images[index].path),
                                  fit: BoxFit.cover, // Ensure the image fills the container
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
