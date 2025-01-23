import 'package:intl/intl.dart';

class FormatTextService {
  // Method to convert from one string format to another
  static String formatDate(String originalDateString) {
    // Step 1: Parse the string to DateTime object using the original format
    DateFormat originalFormat = DateFormat('yyyy-MM-dd');
    DateTime parsedDate = originalFormat.parse(originalDateString); // This converts the string to DateTime
    
    // Step 2: Convert the DateTime object to a new string format
    DateFormat newFormat = DateFormat('dd/MM/yyyy');
    String formattedDate = newFormat.format(parsedDate); // This formats DateTime into a new string
    
    return formattedDate;  // Return the formatted date string
  }
}