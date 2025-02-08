import 'package:flutter/material.dart';
import 'package:diversitree_mobile/core/styles.dart';

class DiversitreeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final List<Widget>? actions;

  const DiversitreeAppBar({Key? key, this.titleText, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: titleText == null
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                'storage/Logo_White.png',
                fit: BoxFit.fitWidth,
              ),
            )
          : null,
      title: Text(
        titleText ?? "Diversitree",
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      toolbarHeight: 44,
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      iconTheme: IconThemeData(color: AppColors.primary),
      actions: actions, // Use dynamic actions here
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44);
}