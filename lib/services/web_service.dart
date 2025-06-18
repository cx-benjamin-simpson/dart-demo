import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pii_data.dart';

class WebService {
  // VULNERABLE: Hardcoded API keys and endpoints
  static const String _apiKey = 'sk_test_1234567890abcdef';
  static const String _baseUrl = 'http://localhost:8080/api';
  static const String _adminEndpoint = 'http://localhost:8080/admin';
  
  // VULNERABLE: No HTTPS enforcement
  static const String _insecureEndpoint = 'http://api.example.com/users';
  
  // VULNERABLE: Weak session management
  static String? _sessionToken;
  static DateTime? _sessionStart;
  
  // A01:2021 - Broken Access Control
  static Future<Map<String, dynamic>> getUserData(String userId, String requestingUserId) async {
    // VULNERABLE: No authorization check
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'User-ID': requestingUserId, // VULNERABLE: Client-controlled authorization
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user data');
    }
  }
  
  // A02:2021 - Cryptographic Failures
  static Future<void> sendPiiData(PiiData userData) async {
    // VULNERABLE: Sending PII over HTTP (not HTTPS)
    final response = await http.post(
      Uri.parse(_insecureEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('admin:password'))}', // VULNERABLE: Weak auth
      },
      body: jsonEncode({
        'user': userData.toJson(), // VULNERABLE: Sending PII in plain text
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
    
    print('VULNERABLE: PII data sent over HTTP: ${response.body}');
  }
  
  // A03:2021 - Injection
  static Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    // VULNERABLE: No input validation or sanitization
    final response = await http.get(
      Uri.parse('$_baseUrl/users/search?q=$searchTerm'), // VULNERABLE: Direct injection
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Search failed');
    }
  }
  
  // A05:2021 - Security Misconfiguration
  static Future<Map<String, dynamic>> getServerInfo() async {
    // VULNERABLE: Exposing server information
    final response = await http.get(
      Uri.parse('$_baseUrl/server/info'),
      headers: {
        'X-API-Key': _apiKey,
      },
    );
    
    if (response.statusCode == 200) {
      final serverInfo = jsonDecode(response.body);
      print('VULNERABLE: Server information exposed:');
      print('  Version: ${serverInfo['version']}');
      print('  Environment: ${serverInfo['environment']}');
      print('  Database: ${serverInfo['database']}');
      print('  Debug Mode: ${serverInfo['debug_mode']}');
      return serverInfo;
    } else {
      throw Exception('Failed to get server info');
    }
  }
  
  // A07:2021 - Identification and Authentication Failures
  static Future<String> login(String username, String password) async {
    // VULNERABLE: Weak authentication
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password, // VULNERABLE: Sending password in plain text
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _sessionToken = data['token'];
      _sessionStart = DateTime.now();
      
      // VULNERABLE: Weak session token
      print('VULNERABLE: Weak session token generated: $_sessionToken');
      return _sessionToken!;
    } else {
      throw Exception('Login failed');
    }
  }
  
  // A08:2021 - Software and Data Integrity Failures
  static Future<void> downloadUpdate(String updateUrl) async {
    // VULNERABLE: No integrity verification
    final response = await http.get(Uri.parse(updateUrl));
    
    if (response.statusCode == 200) {
      // VULNERABLE: No signature verification
      final updateFile = File('update_${DateTime.now().millisecondsSinceEpoch}.bin');
      updateFile.writeAsBytesSync(response.bodyBytes);
      print('VULNERABLE: Downloaded update without verification: ${updateFile.path}');
    } else {
      throw Exception('Update download failed');
    }
  }
  
  // A09:2021 - Security Logging and Monitoring Failures
  static Future<void> accessPiiData(String userId) async {
    // VULNERABLE: No logging of sensitive operations
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId/pii'),
      headers: {
        'Authorization': 'Bearer $_sessionToken',
      },
    );
    
    if (response.statusCode == 200) {
      final piiData = jsonDecode(response.body);
      print('VULNERABLE: Accessed PII data without logging:');
      print('  User ID: $userId');
      print('  SSN: ${piiData['social_security_number']}');
      print('  Credit Card: ${piiData['credit_card_number']}');
      // No audit log entry created
    } else {
      throw Exception('Failed to access PII data');
    }
  }
  
  // A10:2021 - Server-Side Request Forgery (SSRF)
  static Future<String> fetchExternalResource(String url) async {
    // VULNERABLE: No URL validation
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      print('VULNERABLE: Fetched external resource without validation: $url');
      return response.body;
    } else {
      throw Exception('Failed to fetch external resource');
    }
  }
  
  // Additional vulnerable methods
  
  // VULNERABLE: CORS misconfiguration
  static Future<void> setCorsHeaders() async {
    // VULNERABLE: Allowing all origins
    final response = await http.post(
      Uri.parse('$_baseUrl/config/cors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'allowed_origins': ['*'], // VULNERABLE: Allow all origins
        'allowed_methods': ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        'allowed_headers': ['*'], // VULNERABLE: Allow all headers
      }),
    );
    
    print('VULNERABLE: CORS configured to allow all origins');
  }
  
  // VULNERABLE: No rate limiting
  static Future<void> bruteForceLogin(String username) async {
    final commonPasswords = ['123456', 'password', 'admin', 'qwerty', 'letmein'];
    
    for (String password in commonPasswords) {
      try {
        await login(username, password);
        print('VULNERABLE: Brute force successful with password: $password');
        break;
      } catch (e) {
        // Continue trying
      }
    }
  }
  
  // VULNERABLE: Information disclosure
  static Future<void> getErrorDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/nonexistent'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );
      
      // VULNERABLE: Exposing detailed error information
      print('VULNERABLE: Detailed error response:');
      print('  Status: ${response.statusCode}');
      print('  Headers: ${response.headers}');
      print('  Body: ${response.body}');
    } catch (e) {
      print('VULNERABLE: Exception details exposed: $e');
    }
  }
  
  // VULNERABLE: No input validation
  static Future<void> uploadFile(List<int> fileData, String filename) async {
    // VULNERABLE: No file type validation
    final response = await http.post(
      Uri.parse('$_baseUrl/upload'),
      headers: {
        'Content-Type': 'application/octet-stream',
        'Authorization': 'Bearer $_apiKey',
        'X-Filename': filename, // VULNERABLE: Client-controlled filename
      },
      body: fileData,
    );
    
    if (response.statusCode == 200) {
      print('VULNERABLE: File uploaded without validation: $filename');
    } else {
      throw Exception('Upload failed');
    }
  }
} 