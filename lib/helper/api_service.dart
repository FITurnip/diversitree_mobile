import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart'; // For kDebugMode
import 'package:http_parser/http_parser.dart'; 

class ApiService {
  static const _prefixUrl = '192.168.100.36:8000'; // The base URL without protocol

  static Uri _setUri(path) {
    return Uri.http(_prefixUrl, 'api' + path);
  }

  // static const _baseHeader = {
  //   'Content-Type': 'application/json'
  // };

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

    // Print details in debug mode
    if (kDebugMode) {
      print('ApiService: POST Request URL: $_url');
      print('ApiService: Request Body: $body');
    }

    var request = http.MultipartRequest('POST', _url);

    // Ensure `body` is not null before iterating
    if (body != null) {
      for (MapEntry<String, dynamic> entry in body.entries) { // ✅ Explicit type for `entry`
        String key = entry.key;
        dynamic value = entry.value;

        if (value != null) {
          if (value is XFile) {
            // Convert XFile to bytes
            var bytes = await value.readAsBytes();
            var multipartFile = http.MultipartFile.fromBytes(
              key,
              bytes,
              filename: basename(value.path),
            );
            request.files.add(multipartFile);
          } else if (value is File) {
            // Convert File to MultipartFile
            var fileStream = http.ByteStream(value.openRead());
            var fileLength = await value.length();
            var multipartFile = http.MultipartFile(
              key,
              fileStream,
              fileLength,
              filename: basename(value.path),
            );
            request.files.add(multipartFile);
          } else {
            // Add regular form fields
            request.fields[key] = value.toString();
          }
        }
      }
    }

    // Send the request
    var response = await request.send();

    // Handle the response
    var responseBody = await response.stream.bytesToString();
    return http.Response(responseBody, response.statusCode);
  }

  // POST request
  // static Future<http.Response> post(String path, Map<String, dynamic>? body) async {
  //   var _url = _setUri(path);

  //   // Print details in debug mode
  //   if (kDebugMode) {
  //     print('ApiService: POST Request URL: $_url');
  //     print('ApiService: Request Body: $body');
  //   }

  //   // Encode the body as x-www-form-urlencoded
  //   var encodedBody = _encodeBody(body);

  //   var response = await http.post(
  //     _url,
  //     headers: _baseHeader,
  //     body: encodedBody,
  //   );

  //   // Print the response in debug mode
  //   if (kDebugMode) {
  //     print('ApiService: Response Status Code: ${response.statusCode}');
  //     print('ApiService: Response Body: ${response.body}');
  //   }

  //   return response;
  // }

  static String _encodeBody(Map<String, dynamic>? body) {
    if (body == null || body.isEmpty) return '';

    List<String> encodedParams = [];
    body.forEach((key, value) {
      if (value == null) return;

      if (value is Map<String, dynamic>) {
        // If the value is a Map, recurse and flatten it
        encodedParams.addAll(_encodeNestedMap(key, value));
      } else {
        // Encode simple key-value pair
        encodedParams.add('${Uri.encodeComponent(key)}=${Uri.encodeComponent(value.toString())}');
      }
    });

    return encodedParams.join('&');
  }

  static List<String> _encodeNestedMap(String prefix, Map<String, dynamic> map) {
    List<String> encodedParams = [];
    map.forEach((key, value) {
      String newKey = '$prefix[$key]';  // Flatten nested key
      if (value is Map<String, dynamic>) {
        // Recurse for nested maps
        encodedParams.addAll(_encodeNestedMap(newKey, value));
      } else {
        // Encode simple key-value pair
        encodedParams.add('${Uri.encodeComponent(newKey)}=${Uri.encodeComponent(value.toString())}');
      }
    });
    return encodedParams;
  }

  static const _baseHeader = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  // static Future<http.Response> post(String path, Map<String, dynamic>? body) async {
  //   var _url = _setUri(path);

  //   // Print details in debug mode
  //   if (kDebugMode) {
  //     print('ApiService: POST Request URL: $_url');
  //     print('ApiService: Request Body: ${json.encode(body)}');
  //   }

  //   var response = await http.post(
  //     _url,
  //     headers: _baseHeader,
  //     body: json.encode(body),
  //   );

  //   // Print the response in debug mode
  //   if (kDebugMode) {
  //     print('ApiService: Response Status Code: ${response.statusCode}');
  //     print('ApiService: Response Body: ${response.body}');
  //   }

  //   return response;
  // }
}
