import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

AppBar header({String? titleText}) {
  return AppBar(
    title: Text(
      titleText ?? "DIVERSITREE",
      style: TextStyle(
        color: AppTextColors.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: AppColors.primary,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
  );
}