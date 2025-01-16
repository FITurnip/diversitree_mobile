
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

class RingkasanInformasi extends StatelessWidget {
  const RingkasanInformasi({
    super.key,
    required this.infoSize,
    required this.showCamera,
  });

  final double infoSize;
  final bool showCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              width: double.infinity,
              height: infoSize,
              decoration: BoxDecoration(
                color: AppColors.info, // Background color
                borderRadius: BorderRadius.circular(appBorderRadius), // Border radius
              ),
              padding: EdgeInsets.all(8), // Optional: Add padding inside the container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120, // Fixed width for the label
                        child: Text(
                          "Luas Area",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Text(
                        ": 20.3 m2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120, // Fixed width for the label
                        child: Text(
                          "Teridentifikasi",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Text(
                        ": 10 pohon",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      
          // Camera Button
          if(showCamera)
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: OutlinedButton(
              onPressed: () {
                // page route to camera screen
              },
              style: OutlinedButton.styleFrom(
                fixedSize: Size(infoSize, infoSize), // Set width & height
                backgroundColor: AppColors.secondary,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Square shape
                ),
                side: BorderSide(color: AppColors.secondary, width: 0.0), // Border color & width
              ),
              child: Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}
