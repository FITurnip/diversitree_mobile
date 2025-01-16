import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

AppBar header({String? titleText}) {
  return AppBar(
    title: Text(
      titleText ?? "DIVERSITREE",
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: bgColor,
    // leading: IconButton(
    //   icon: Icon(Icons.arrow_back_ios_new, color: textColor),
    //   onPressed: () => {
    //     // Navigator.of(context).pop()
    //   },
    // )
  );
}