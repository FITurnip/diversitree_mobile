import 'dart:convert';
import 'package:diversitree_mobile/helper/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Map<String, dynamic> _userData = {};

  static Future<void> _setUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userData["name"] = prefs.getString('name');
    _userData["email"] = prefs.getString('email');
  }

  static Future<void> prepare() async {
    _setUserData();
  }

  static Map<String, dynamic> getCurrentUserData() {
    return _userData;
  }

  static Future<bool> checkAuth() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> _auth(Map<String, dynamic> userData, String url, {required bool withAuth}) async {
    var response = await ApiService.post(url, userData, withAuth: false);
    var responseData = json.decode(response.body);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (responseData["response"] is Map) {
      if(responseData["response"]['token'] != null) await prefs.setString('token', responseData["response"]['token']);
      await prefs.setString('name', responseData["response"]['user']['name']);
      await prefs.setString('email', responseData["response"]['user']['email']);
    }

    await _setUserData();
  }

  static Future<void> login(Map<String, dynamic> userData) async {
    await _auth(userData, '/auth/login', withAuth: false);
  }

  static Future<void> register(Map<String, dynamic> userData) async {
    await _auth(userData, '/auth/register', withAuth: false);
  }

  static Future<void> editProfile(Map<String, dynamic> userData) async {
    await _auth(userData, '/auth/edit-profile', withAuth: true);
  }

  static Future<void> logout() async {
    await ApiService.post('/auth/logout', {}, withAuth: true);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('email');
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}