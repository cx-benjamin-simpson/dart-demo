import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/pii_data.dart';

class OwaspVulnerabilities {
  // Sample PII data for demonstration
  static final List<PiiData> samplePiiData = [
    PiiData(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phoneNumber: '555-123-4567',
      socialSecurityNumber: '123-45-6789',
      dateOfBirth: '1990-01-15',
      address: '123 Main St, Anytown, USA',
      creditCardNumber: '4111-1111-1111-1111',
      password: 'password123',
    ),
    PiiData(
      id: '2',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane.smith@example.com',
      phoneNumber: '555-987-6543',
      socialSecurityNumber: '987-65-4321',
      dateOfBirth: '1985-06-22',
      address: '456 Oak Ave, Somewhere, USA',
      creditCardNumber: '5555-5555-5555-4444',
      password: 'qwerty456',
    ),
  ];

  // A01:2021 - Broken Access Control
  static void demonstrateBrokenAccessControl() {
    print('\n=== A01:2021 - Broken Access Control ===');
    
    String currentUserId = '1';
    String targetUserId = '2';
    
    PiiData? userData = samplePiiData.firstWhere(
      (data) => data.id == targetUserId,
      orElse: () => throw Exception('User not found'),
    );
    
    print('User $currentUserId accessed data for user $targetUserId');
    print('Retrieved: ${userData.firstName} ${userData.lastName} - ${userData.email}');
  }

  // A02:2021 - Cryptographic Failures
  static void demonstrateCryptographicFailures() {
    print('\n=== A02:2021 - Cryptographic Failures ===');
    
    print('User credentials stored in database:');
    for (var user in samplePiiData) {
      print('${user.firstName} ${user.lastName}: ${user.password}');
    }
    
    String ssn = '123-45-6789';
    String encryptionKey = 'company_secret_key_2023';
    String encryptedSsn = _encryptData(ssn, encryptionKey);
    print('Encrypted SSN: $encryptedSsn');
  }

  // A03:2021 - Injection
  static void demonstrateInjection() {
    print('\n=== A03:2021 - Injection ===');
    
    String searchTerm = "'; DROP TABLE users; --";
    String sqlQuery = "SELECT * FROM users WHERE name = '$searchTerm'";
    print('Executing query: $sqlQuery');
    
    String fileName = 'report.txt; rm -rf /home/user';
    String command = 'cat $fileName';
    print('Executing command: $command');
  }

  // A04:2021 - Insecure Design
  static void demonstrateInsecureDesign() {
    print('\n=== A04:2021 - Insecure Design ===');
    
    print('User IDs in system:');
    for (var user in samplePiiData) {
      print('User ID: ${user.id}');
    }
    
    print('Login attempts (no rate limiting):');
    for (int i = 0; i < 100; i++) {
      if (i % 10 == 0) print('Attempt $i');
    }
  }

  // A05:2021 - Security Misconfiguration
  static void demonstrateSecurityMisconfiguration() {
    print('\n=== A05:2021 - Security Misconfiguration ===');
    
    Map<String, String> config = {
      'admin_user': 'admin',
      'admin_pass': 'admin',
      'db_password': 'password',
      'api_key': 'test_key_123',
    };
    print('Configuration loaded:');
    config.forEach((key, value) => print('$key: $value'));
    
    bool isDebugMode = true;
    print('Debug mode: $isDebugMode');
    if (isDebugMode) {
      print('Debug information: Stack trace and internal details available');
    }
  }

  // A06:2021 - Vulnerable and Outdated Components
  static void demonstrateVulnerableComponents() {
    print('\n=== A06:2021 - Vulnerable and Outdated Components ===');
    
    Map<String, String> dependencies = {
      'crypto': '1.0.0',
      'http': '0.12.0',
      'sqlite3': '1.0.0',
    };
    print('Current dependencies:');
    dependencies.forEach((package, version) => print('$package: $version'));
    
    String userPassword = 'password123';
    String hashedPassword = md5.convert(utf8.encode(userPassword)).toString();
    print('Password hash: $hashedPassword');
  }

  // A07:2021 - Identification and Authentication Failures
  static void demonstrateAuthFailures() {
    print('\n=== A07:2021 - Identification and Authentication Failures ===');
    
    List<String> passwords = ['123456', 'password', 'qwerty', 'admin'];
    print('Accepted passwords:');
    passwords.forEach((password) => print('Password: $password - Status: ACCEPTED'));
    
    DateTime sessionCreated = DateTime.now().subtract(Duration(hours: 24));
    print('Session created: $sessionCreated');
    print('Session status: ACTIVE');
    
    String sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
    print('Session ID: $sessionId');
  }

  // A08:2021 - Software and Data Integrity Failures
  static void demonstrateIntegrityFailures() {
    print('\n=== A08:2021 - Software and Data Integrity Failures ===');
    
    print('User data without integrity verification:');
    for (var user in samplePiiData) {
      print('User: ${user.toJson()}');
    }
    
    Map<String, dynamic> updatePackage = {
      'version': '2.0.0',
      'download_url': 'http://updates.example.com/package.bin',
      'checksum': null,
    };
    print('Update package: $updatePackage');
  }

  // A09:2021 - Security Logging and Monitoring Failures
  static void demonstrateLoggingFailures() {
    print('\n=== A09:2021 - Security Logging and Monitoring Failures ===');
    
    print('Accessing user data:');
    for (var user in samplePiiData) {
      print('Accessed: ${user.firstName} ${user.lastName} SSN: ${user.socialSecurityNumber}');
    }
    
    String logMessage = 'User admin accessed SSN: 123-45-6789 at ${DateTime.now()}';
    print('Log entry: $logMessage');
    
    int failedAttempts = 50;
    print('Failed login attempts: $failedAttempts');
  }

  // A10:2021 - Server-Side Request Forgery (SSRF)
  static void demonstrateSSRF() {
    print('\n=== A10:2021 - Server-Side Request Forgery (SSRF) ===');
    
    String userProvidedUrl = 'http://internal-server/admin';
    String apiUrl = 'https://api.example.com/fetch?url=$userProvidedUrl';
    print('Fetching URL: $apiUrl');
    
    List<String> internalServices = [
      'http://localhost:8080/admin',
      'http://127.0.0.1:3306/mysql',
      'http://internal-api.company.com/users',
    ];
    print('Available internal services:');
    internalServices.forEach((service) => print('  $service'));
  }

  // Helper methods for demonstration
  static String _encryptData(String data, String key) {
    List<int> bytes = utf8.encode(data + key);
    return base64.encode(bytes);
  }
} 