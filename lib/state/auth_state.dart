import 'package:e_commerce/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthState extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isLoading = false;
  String? email;

  final _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<void> loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      isLoggedIn = true;
      email = prefs.getString('email');
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post(ApiConstants.loginEndpoint, data: {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('email', email);

      isLoggedIn = true;
      this.email = email;
      return null;
    } on DioException catch(e){
      print("❌ LOGIN ERROR: ${e.response?.data}");
      return 'Wrong email or password.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn = false;
    email = null;
    notifyListeners();
  }
}
