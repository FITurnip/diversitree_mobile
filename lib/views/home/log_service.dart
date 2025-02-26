import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LogService {
  static Future<void> writeToLog(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/diversitree_log.txt');
      final timestamp = DateTime.now().toIso8601String();
      
      await logFile.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
    } catch (e) {
      print('Failed to write log: $e');
    }
  }
}
