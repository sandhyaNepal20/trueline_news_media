import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  /// ✅ Save Token
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString('token', token);
  }

  /// ✅ Get Token
  Future<String?> getToken() async {
    return _sharedPreferences.getString('token');
  }

  /// ✅ Save User Information
  Future<void> saveUserInfo(
      String fullName, String email, String role, String profileImage) async {
    await _sharedPreferences.setString('fullName', fullName);
    await _sharedPreferences.setString('email', email);
    await _sharedPreferences.setString('role', role);
    await _sharedPreferences.setString('profileImage', profileImage);
  }

  /// ✅ Save User ID (Optional if needed)
  Future<void> saveUserId(String userId) async {
    await _sharedPreferences.setString('userId', userId);
  }

  /// ✅ Get User Information
  Future<Map<String, String>> getUserInfo() async {
    return {
      'fullName': _sharedPreferences.getString('fullName') ?? '',
      'email': _sharedPreferences.getString('email') ?? '',
      'role': _sharedPreferences.getString('role') ?? '',
      'profileImage': _sharedPreferences.getString('profileImage') ?? '',
      'userId': _sharedPreferences.getString('userId') ?? '',
    };
  }

  /// ✅ Logout (Clears All Stored Data)
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
