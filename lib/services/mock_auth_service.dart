import 'dart:async';

class _User {
  final String email;
  final String password;

  _User({required this.email, required this.password});
}

class MockAuthService {
  static final List<_User> _mockUsers = [];
  static String? _lastLoggedInEmail;

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
  }) async {
    try {
      if (_mockUsers.any((user) => user.email == email)) {
        return {'success': false, 'error': 'This email is already registered.'};
      }
      final newUser = _User(email: email, password: password);
      _mockUsers.add(newUser);
      _lastLoggedInEmail = newUser.email;
      return {'success': true, 'message': 'Account created successfully!'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = _mockUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _lastLoggedInEmail = user.email;
      return {'success': true, 'message': 'Login successful!'};
    } catch (e) {
      return {'success': false, 'error': 'Invalid email or password.'};
    }
  }

  static Future<void> signOut() async {
    // In a real app, this would clear the user session.
    _lastLoggedInEmail = null;
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static String? getCurrentUserEmail() {
    return _lastLoggedInEmail;
  }
}
