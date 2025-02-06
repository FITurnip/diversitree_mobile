import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

AppBar header({String? titleText}) {
  return AppBar(
    leading: titleText == null
        ? Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'storage/Logo_White.png', // File object containing the image
              fit: BoxFit.fitWidth,
            ),
          )
        : null,
    title: Text(
      titleText ?? "Diversitree",
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        // fontSize: 20
      ),
    ),
    actions: titleText == null
        ? [
            // Hamburger menu icon on the right side
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu, // Hamburger icon
                    color: AppColors.primary, // Adjust the color as needed
                  ),
                  onPressed: () {
                    // Open drawer when the hamburger icon is clicked
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ]
        : null, // No actions when titleText is not null
    toolbarHeight: 44,
    backgroundColor: Colors.white,
    forceMaterialTransparency: true,
    iconTheme: IconThemeData(
      color: AppColors.primary
    ),
  );
}