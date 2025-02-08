import 'package:flutter/material.dart';

class AppColors {
  static const Color lightPrimary = Color(0xFFF2FCF7);
  static const Color primary = Color(0xFF08CB4A);  // Leaf Green
  static const Color secondary = Color(0xFFB0B0B0); // Lighter Grey (closer to white)
  static const Color tertiary = Color(0xFFE0E0E0);   // Light Grey (not too white)
  
  // Update the info color to a more natural green
  static const Color info = Color(0xFF388E3C);      // Natural Green (a muted green)

  static const Color warning = Color(0xFFF4C542);   // Sun Yellow
  static const Color danger = Color(0xFFC62828);    // Berry Red
}


class AppTextColors {
  static const Color primaryText = Color(0xFF212121);  // Dark Grey (for main text)
  static const Color secondaryText = Color(0xFF616161); // Muted Grey (less emphasis)
  static const Color tertiaryText = Color(0xFF9E9E9E); // Soft, light gray text color
  static const Color onPrimary = Color(0xFFFFFFFF);   // White on primary
  static const Color onSecondary = Color(0xFFFFFFFF); // White on secondary
  static const Color onTertiary = Color(0xFF000000);  // Black on tertiary (for contrast)
  static const Color onInfo = Color(0xFFFFFFFF);      // White on info
  static const Color onWarning = Color(0xFF000000);   // Black on warning
  static const Color onDanger = Color(0xFFFFFFFF);    // White on danger
}

class AppTextStyles {
  // Headings (Optimized for Android)
  static const TextStyle heading1 = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.bold,
    color: AppTextColors.primaryText, 
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTextColors.primaryText,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppTextColors.primaryText,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTextColors.primaryText,
  );

  // Paragraphs
  static const TextStyle paragraph = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF424242), // Slightly lighter dark gray
    height: 1.5,
  );

  static const TextStyle paragraphSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppTextColors.secondaryText, // Uses adjusted grey
    height: 1.5,
  );

  // Emphasis
  static const TextStyle boldText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppTextColors.primaryText,
  );

  static const TextStyle italicText = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: Color(0xFF424242),
  );

  // Themed Text Colors
  static const TextStyle primaryText = TextStyle(
    fontSize: 12,
    color: AppColors.primary, // Leaf Green
  );

  static const TextStyle secondaryText = TextStyle(
    fontSize: 12,
    color: AppColors.secondary, // Updated to lighter grey
  );

  static const TextStyle tertiaryText = TextStyle(
    fontSize: 12,
    color: AppColors.tertiary, // Light grey (not too close to white)
  );

  static const TextStyle infoText = TextStyle(
    fontSize: 12,
    color: AppColors.info, // Sky Blue
  );

  static const TextStyle warningText = TextStyle(
    fontSize: 12,
    color: AppColors.warning, // Sun Yellow
  );

  static const TextStyle dangerText = TextStyle(
    fontSize: 12,
    color: AppColors.danger, // Berry Red
  );
}

const appBorderRadius = 10.0;
const appPadding = 8.0;
const appMargin = 8.0;