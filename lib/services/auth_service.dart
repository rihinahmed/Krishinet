import 'api_service.dart';
import 'storage_service.dart';

class UserSession {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;

  UserSession({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class AuthService {
  /// Register a new user and return [UserSession] on success.
  static Future<UserSession> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String phone = '',
  }) async {
    final data = await ApiService.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
    });

    await StorageService.saveTokens(data['accessToken'], data['refreshToken']);
    final user = UserSession.fromJson(data['user']);
    await StorageService.saveUserInfo(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      phone: user.phone,
    );
    return user;
  }

  /// Login with email + password. Returns [UserSession] on success.
  static Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    await StorageService.saveTokens(data['accessToken'], data['refreshToken']);
    final user = UserSession.fromJson(data['user']);
    await StorageService.saveUserInfo(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      phone: user.phone,
    );
    return user;
  }

  /// Logout: clear local session.
  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout', {});
    } catch (_) {
      // Ignore logout API errors; clear locally anyway
    }
    await StorageService.clearAll();
  }

  /// Get the current user session from local storage (no API call).
  static Future<UserSession?> currentSession() async {
    final info = await StorageService.getUserInfo();
    if (info['id'] == null || info['id']!.isEmpty) return null;
    return UserSession(
      id: info['id']!,
      name: info['name'] ?? '',
      email: info['email'] ?? '',
      role: info['role'] ?? '',
      phone: info['phone'] ?? '',
    );
  }

  /// Refresh the access token.
  static Future<bool> refreshSession() async {
    try {
      final refresh = await StorageService.getRefreshToken();
      if (refresh == null) return false;
      final data = await ApiService.post('/auth/refresh', {
        'refreshToken': refresh,
      });
      await StorageService.saveTokens(
        data['accessToken'],
        data['refreshToken'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
