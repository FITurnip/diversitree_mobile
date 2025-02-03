import 'dart:io';
import 'package:diversitree_mobile/components/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraGallery extends StatefulWidget {
  final List<XFile> images;
  final String workspace_id;
  final Function() saveImages;

  CameraGallery({required this.images, required this.workspace_id, required this.saveImages});

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
      appBar: AppBar(
        title: Text('Foto Terbaru'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.images.isEmpty
          ? Center(child: Text('Belum ada foto diambil!'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("start pop from camera gallery");
                        widget.saveImages();
                      },
                      child: Text("Tambah ke workspace"),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
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
                            child: AspectRatio(
                              aspectRatio: 1, // Make the image square
                              child: Image.file(
                                File(widget.images[index].path),
                                fit: BoxFit.cover, // Ensure the image fills the square area
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
