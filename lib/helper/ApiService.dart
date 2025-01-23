import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For kDebugMode

class Apiservice {
  static const _prefixUrl = '192.168.100.36:8000'; // The base URL without protocol

  static Uri _setUri(path) {
    return Uri.http(_prefixUrl, 'api' + path);
  }

  static const _baseHeader = {
    'Content-Type': 'application/json'
  };

  // GET request
  static Future<http.Response> get(String path) async {
    var _url = _setUri(path);

    // Print details in debug mode
    if (kDebugMode) {
      print('GET Request URL: $_url');
    }

    var response = await http.get(_url);

    // Print the response in debug mode
    if (kDebugMode) {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    return response;
  }

  // POST request
  static Future<http.Response> post(String path, Map<String, dynamic>? body) async {
    var _url = _setUri(path);

    // Print details in debug mode
    if (kDebugMode) {
      print('POST Request URL: $_url');
      print('Request Body: ${json.encode(body)}');
    }

    var response = await http.post(
      _url,
      headers: _baseHeader,
      body: json.encode(body),
    );

    // Print the response in debug mode
    if (kDebugMode) {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    return response;
  }
}
