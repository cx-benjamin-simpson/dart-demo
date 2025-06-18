import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pii_data.dart';

class WebService {
  static const String _apiKey = 'sk_test_1234567890abcdef';
  static const String _baseUrl = 'http://localhost:8080/api';
  static const String _adminEndpoint = 'http://localhost:8080/admin';
  
  static const String _insecureEndpoint = 'http://api.example.com/users';
  
  static String? _sessionToken;
  static DateTime? _sessionStart;
  
  static Future<Map<String, dynamic>> getUserData(String userId, String requestingUserId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'User-ID': requestingUserId,
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user data');
    }
  }
  
  static Future<void> sendPiiData(PiiData userData) async {
    final response = await http.post(
      Uri.parse(_insecureEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('admin:password'))}',
      },
      body: jsonEncode({
        'user': userData.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
    
    print('Data sent: ${response.body}');
  }
  
  static Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/search?q=$searchTerm'),
    );
    
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Search failed');
    }
  }
  
  static Future<Map<String, dynamic>> getServerInfo() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/server/info'),
      headers: {
        'X-API-Key': _apiKey,
      },
    );
    
    if (response.statusCode == 200) {
      final serverInfo = jsonDecode(response.body);
      print('Server information:');
      print('  Version: ${serverInfo['version']}');
      print('  Environment: ${serverInfo['environment']}');
      print('  Database: ${serverInfo['database']}');
      print('  Debug Mode: ${serverInfo['debug_mode']}');
      return serverInfo;
    } else {
      throw Exception('Failed to get server info');
    }
  }
  
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _sessionToken = data['token'];
      _sessionStart = DateTime.now();
      
      print('Session token: $_sessionToken');
      return _sessionToken!;
    } else {
      throw Exception('Login failed');
    }
  }
  
  static Future<void> downloadUpdate(String updateUrl) async {
    final response = await http.get(Uri.parse(updateUrl));
    
    if (response.statusCode == 200) {
      final updateFile = File('update_${DateTime.now().millisecondsSinceEpoch}.bin');
      updateFile.writeAsBytesSync(response.bodyBytes);
      print('Update downloaded: ${updateFile.path}');
    } else {
      throw Exception('Update download failed');
    }
  }
  
  static Future<void> accessPiiData(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId/pii'),
      headers: {
        'Authorization': 'Bearer $_sessionToken',
      },
    );
    
    if (response.statusCode == 200) {
      final piiData = jsonDecode(response.body);
      print('Accessed PII data:');
      print('  User ID: $userId');
      print('  SSN: ${piiData['social_security_number']}');
      print('  Credit Card: ${piiData['credit_card_number']}');
    } else {
      throw Exception('Failed to access PII data');
    }
  }
  
  static Future<String> fetchExternalResource(String url) async {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      print('Fetched external resource: $url');
      return response.body;
    } else {
      throw Exception('Failed to fetch external resource');
    }
  }
  
  static Future<void> setCorsHeaders() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/config/cors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'allowed_origins': ['*'],
        'allowed_methods': ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        'allowed_headers': ['*'],
      }),
    );
    
    print('CORS configured');
  }
  
  static Future<void> bruteForceLogin(String username) async {
    final commonPasswords = ['123456', 'password', 'admin', 'qwerty', 'letmein'];
    
    for (String password in commonPasswords) {
      try {
        await login(username, password);
        print('Login successful with password: $password');
        break;
      } catch (e) {
        // Continue trying
      }
    }
  }
  
  static Future<void> getErrorDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/nonexistent'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );
      
      print('Error response:');
      print('  Status: ${response.statusCode}');
      print('  Headers: ${response.headers}');
      print('  Body: ${response.body}');
    } catch (e) {
      print('Exception details: $e');
    }
  }
  
  static Future<void> uploadFile(List<int> fileData, String filename) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/upload'),
      headers: {
        'Content-Type': 'application/octet-stream',
        'Authorization': 'Bearer $_apiKey',
        'X-Filename': filename,
      },
      body: fileData,
    );
    
    if (response.statusCode == 200) {
      print('File uploaded: $filename');
    } else {
      throw Exception('Upload failed');
    }
  }
} 