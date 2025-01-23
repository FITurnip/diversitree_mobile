import 'package:diversitree_mobile/components/ringkasan_informasi.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

class PemotretanPohon extends StatefulWidget {
  @override
  _PemotretanPohonState createState() => _PemotretanPohonState();
}

class _PemotretanPohonState extends State<PemotretanPohon> {
  double infoSize = 56.0;
  final List<String> images = [
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RingkasanInformasi(infoSize: infoSize, showCamera: true,),

          Container(margin: EdgeInsets.only(bottom: 8.0), child: Text('Daftar Pohon', style: AppTextStyles.heading1,)),

          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.65,
            ),
            itemCount: images.length,
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
                          images[index],
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
                          Text("Mangifera indica"),
                          Text("Dbh: 80 m2"),
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
