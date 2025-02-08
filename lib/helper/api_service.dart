import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For kDebugMode

class ApiService {
  static const _prefixUrl = '192.168.100.36:8000'; // The base URL without protocol

  static const urlStorage = 'http://$_prefixUrl/storage/';

  static String getPath(path) {
    return 'http://$_prefixUrl/api$path';
  }

  static Uri _setUri(path) {
    return Uri.http(_prefixUrl, 'api$path');
  }

  static Future<Map<String, String>> _getTokenHeader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    var header =  {
      "Authorization": "Bearer ${bearerToken}",
    };

    return header;
  }

  // GET request
  static Future<http.Response> get(String path, {required bool withAuth}) async {
    var _url = _setUri(path);

    // Print details in debug mode
    if (kDebugMode) {
      print('ApiService: GET Request URL: $_url');
    }

    var headers = withAuth ? await _getTokenHeader() : null;

    var response = await http.get(_url, headers: headers);

    // Print the response in debug mode
    if (kDebugMode) {
      print('ApiService: Response Status Code: ${response.statusCode}');
      print('ApiService: Response Body: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> post(String path, Map<String, dynamic>? body, {required bool withAuth}) async {
    var _url = _setUri(path);

    if (kDebugMode) {
      print('ApiService: POST Request URL: $_url');
      print('ApiService: Request Body: $body');
    }

    var request = http.MultipartRequest('POST', _url);
    if(withAuth) {
      var headers = await _getTokenHeader();
      request.headers.addAll(headers);
    }

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
