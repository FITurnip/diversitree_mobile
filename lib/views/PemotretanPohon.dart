import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

class PemotretanPohon extends StatefulWidget {
  @override
  _PemotretanPohonState createState() => _PemotretanPohonState();
}

class _PemotretanPohonState extends State<PemotretanPohon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.info, // Background color
                  borderRadius: BorderRadius.circular(appBorderRadius), // Border radius
                ),
                padding: EdgeInsets.all(8), // Optional: Add padding inside the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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


            ElevatedButton.icon(onPressed: () {
              // page route to camera screen
            }, label: Text(""), icon: Icon(Icons.camera_alt)),
            
          ],
        ),
        Text("Percobaan"),
      ],
    );
  }
}