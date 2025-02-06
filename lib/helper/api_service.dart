import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart'; // For kDebugMode

class ApiService {
  static const _prefixUrl = '192.168.161.78:8000'; // The base URL without protocol

  static const urlStorage = 'http://$_prefixUrl/storage/';

  static Uri _setUri(path) {
    return Uri.http(_prefixUrl, 'api$path');
  }

  // GET request
  static Future<http.Response> get(String path) async {
    var _url = _setUri(path);

    // Print details in debug mode
    if (kDebugMode) {
      print('ApiService: GET Request URL: $_url');
    }

    var response = await http.get(_url);

    // Print the response in debug mode
    if (kDebugMode) {
      print('ApiService: Response Status Code: ${response.statusCode}');
      print('ApiService: Response Body: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> post(String path, Map<String, dynamic>? body) async {
    var _url = _setUri(path);

    if (kDebugMode) {
      print('ApiService: POST Request URL: $_url');
      print('ApiService: Request Body: $body');
    }

    var request = http.MultipartRequest('POST', _url);

    // Ensure `body` is not null before iterating
    if (body != null) {
      _flattenAndAddFields(request, body);
    }

    // Send the request
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    // Print response details in debug mode before returning
    if (kDebugMode) {
      print('ApiService: Response Status Code: ${response.statusCode}');
      print('ApiService: Response Body: $responseBody');
    }

    // Handle the response
    return http.Response(responseBody, response.statusCode);
  }

  // Recursive function to flatten nested maps
  static void _flattenAndAddFields(http.MultipartRequest request, Map<String, dynamic> map, [String prefix = '']) {
    map.forEach((key, value) async {
      String newKey = prefix.isEmpty ? key : '$prefix[$key]';

      if (value == null) {
        return;
      }

      if (value is Map<String, dynamic>) {
        _flattenAndAddFields(request, value, newKey);
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          var item = value[i];
          String arrayKey = '$newKey[$i]';
          if (item is Map<String, dynamic>) {
            _flattenAndAddFields(request, item, arrayKey);
          } else {
            request.fields[arrayKey] = item.toString();
          }
        }
      } else if (value is File || value is XFile) {
        // Handle both File and XFile
        var fileStream = http.ByteStream((value as dynamic).openRead());
        var fileLength = await value.length();
        var multipartFile = http.MultipartFile(
          newKey,
          fileStream,
          fileLength,
          filename: basename(value.path),
        );
        request.files.add(multipartFile);
      } else {
        request.fields[newKey] = value.toString();
      }
    });
  }
}
