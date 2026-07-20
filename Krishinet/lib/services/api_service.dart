import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to reach host machine localhost.
  // For web (Flutter web), use localhost directly.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    return 'http://10.0.2.2:5000/api'; // Android emulator
    // For physical device on same network: 'http://192.168.X.X:5000/api'
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Generic GET request
  static Future<dynamic> get(String endpoint) async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  /// Generic POST request
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// Generic PATCH request
  static Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// Generic DELETE request
  static Future<dynamic> delete(String endpoint) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }
    // Throw readable error message from API
    final message =
        decoded['message'] ?? 'Unknown error (${response.statusCode})';
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
