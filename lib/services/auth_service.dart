import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  // NOTE: For a production app, use environment variables or a secure
  // configuration file for API keys.
  static final String _baseUrl =
      dotenv.env['AUTH_API_BASE_URL'] ??
      'https://login-signup.p.rapidapi.com/public/v1';
  static final String _apiKey =
      dotenv.env['RAPIDAPI_AUTH_KEY'] ?? dotenv.env['RAPIDAPI_KEY'] ?? '';
  static final String _apiHost =
      dotenv.env['AUTH_API_HOST'] ?? 'login-signup.p.rapidapi.com';

  /// A private helper method to handle all API POST requests with robust error handling.
  static Future<Map<String, dynamic>> _postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          if (_apiKey.isNotEmpty) 'x-rapidapi-key': _apiKey,
          'x-rapidapi-host': _apiHost,
          'Content-Type': 'application/x-www-form-urlencoded',
          'Origin': 'http://127.0.0.1',
        },
        body: body,
      );

      // Check for a non-200 status code first.
      if (response.statusCode != 200) {
        String errorMessage =
            'An error occurred with status code ${response.statusCode}.';
        try {
          // Attempt to parse the body for a more specific error message.
          final responseData = json.decode(response.body);
          if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          }
        } on FormatException {
          // The body was not valid JSON.
          errorMessage = 'Server error. The response was not valid.';
        }
        return {'success': false, 'error': errorMessage};
      }

      // If status code is 200, but the response body is malformed.
      try {
        final responseData = json.decode(response.body);
        return {'success': true, 'data': responseData};
      } on FormatException {
        return {
          'success': false,
          'error': 'Invalid data received from the server.',
        };
      }
    } on SocketException {
      // Catch specific network connectivity issues.
      return {
        'success': false,
        'error': 'No internet connection. Please try again.',
      };
    } on http.ClientException catch (e) {
      // Catch other HTTP client errors.
      return {'success': false, 'error': 'Network error: ${e.message}'};
    } catch (e) {
      // The final fallback for any other unexpected errors.
      return {
        'success': false,
        'error': 'An unknown error occurred: ${e.toString()}',
      };
    }
  }

  /// Authenticates a user with the provided email and password.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final body = {'email': email, 'password': password};
    return _postRequest('login.php', body);
  }

  /// Creates a new user account with the provided details.
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
    return _postRequest('signup.php', body);
  }

  /// Requests a password reset link for the provided email.
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final body = {'email': email};
    return _postRequest('forgot-password.php', body);
  }

  /// Verifies a user's email using a verification code.
  static Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    final body = {'email': email, 'verification_code': verificationCode};
    return _postRequest('verify-email.php', body);
  }
}
