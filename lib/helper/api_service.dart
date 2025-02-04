import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart'; // For kDebugMode

class ApiService {
  static const _prefixUrl = '192.168.100.36:8000'; // The base URL without protocol

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
        // Skip adding null values to the request
        return;
      }

      if (value is Map<String, dynamic>) {
        // Recursively flatten nested maps
        _flattenAndAddFields(request, value, newKey);
      } else if (value is List) {
        // Handle List (array)
        for (int i = 0; i < value.length; i++) {
          // Flatten each item in the array and append index
          var item = value[i];
          String arrayKey = '$newKey[$i]';
          if (item is Map<String, dynamic>) {
            // Recursively flatten each object inside the array
            _flattenAndAddFields(request, item, arrayKey);
          } else {
            // Add primitive values directly to fields
            request.fields[arrayKey] = item.toString();
          }
        }
      } else if (value is File) {
        // Handle File
        var fileStream = http.ByteStream(value.openRead());
        var fileLength = await value.length();
        var multipartFile = http.MultipartFile(
          newKey,
          fileStream,
          fileLength,
          filename: basename(value.path),
        );
        request.files.add(multipartFile);
      } else {
        // Handle normal key-value pair
        request.fields[newKey] = value.toString();
      }
    });
  }
}
