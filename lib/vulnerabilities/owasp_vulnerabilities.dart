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
    
    // VULNERABLE: No authentication check
    String userId = '1';
    String requestedUserId = '2'; // Attacker trying to access another user's data
    
    // VULNERABLE CODE - No authorization check
    PiiData? userData = samplePiiData.firstWhere(
      (data) => data.id == requestedUserId,
      orElse: () => throw Exception('User not found'),
    );
    
    print('VULNERABLE: User $userId accessed data for user $requestedUserId');
    print('Exposed PII: ${userData.firstName} ${userData.lastName} - ${userData.email}');
  }

  // A02:2021 - Cryptographic Failures
  static void demonstrateCryptographicFailures() {
    print('\n=== A02:2021 - Cryptographic Failures ===');
    
    // VULNERABLE: Storing passwords in plain text
    print('VULNERABLE: Storing passwords in plain text');
    for (var user in samplePiiData) {
      print('User: ${user.firstName} ${user.lastName} - Password: ${user.password}');
    }
    
    // VULNERABLE: Weak encryption
    String sensitiveData = '123-45-6789'; // SSN
    String weakKey = 'secret123'; // Weak encryption key
    String encrypted = _weakEncrypt(sensitiveData, weakKey);
    print('VULNERABLE: Weakly encrypted SSN: $encrypted');
  }

  // A03:2021 - Injection
  static void demonstrateInjection() {
    print('\n=== A03:2021 - Injection ===');
    
    // VULNERABLE: SQL Injection
    String userInput = "'; DROP TABLE users; --";
    String vulnerableQuery = "SELECT * FROM users WHERE name = '$userInput'";
    print('VULNERABLE: SQL Injection query: $vulnerableQuery');
    
    // VULNERABLE: Command Injection
    String filename = 'file.txt; rm -rf /';
    String vulnerableCommand = 'cat $filename';
    print('VULNERABLE: Command injection: $vulnerableCommand');
  }

  // A04:2021 - Insecure Design
  static void demonstrateInsecureDesign() {
    print('\n=== A04:2021 - Insecure Design ===');
    
    // VULNERABLE: Predictable IDs
    print('VULNERABLE: Predictable user IDs');
    for (var user in samplePiiData) {
      print('User ID: ${user.id} - Easy to guess and enumerate');
    }
    
    // VULNERABLE: No rate limiting
    print('VULNERABLE: No rate limiting on login attempts');
    for (int i = 0; i < 100; i++) {
      if (i % 10 == 0) print('Login attempt $i - No blocking');
    }
  }

  // A05:2021 - Security Misconfiguration
  static void demonstrateSecurityMisconfiguration() {
    print('\n=== A05:2021 - Security Misconfiguration ===');
    
    // VULNERABLE: Default credentials
    Map<String, String> defaultConfig = {
      'admin_username': 'admin',
      'admin_password': 'admin',
      'database_password': 'password',
      'api_key': 'test_key_123',
    };
    print('VULNERABLE: Default configuration exposed:');
    defaultConfig.forEach((key, value) => print('$key: $value'));
    
    // VULNERABLE: Debug mode enabled in production
    bool debugMode = true;
    print('VULNERABLE: Debug mode enabled: $debugMode');
    if (debugMode) {
      print('DEBUG: Exposing internal error details and stack traces');
    }
  }

  // A06:2021 - Vulnerable and Outdated Components
  static void demonstrateVulnerableComponents() {
    print('\n=== A06:2021 - Vulnerable and Outdated Components ===');
    
    // VULNERABLE: Using outdated library versions
    Map<String, String> outdatedDependencies = {
      'crypto': '1.0.0',
      'http': '0.12.0',
      'sqlite3': '1.0.0',
    };
    print('VULNERABLE: Outdated dependencies:');
    outdatedDependencies.forEach((package, version) => print('$package: $version'));
    
    // VULNERABLE: Known vulnerable component
    print('VULNERABLE: Using known vulnerable encryption algorithm (MD5)');
    String password = 'password123';
    String md5Hash = md5.convert(utf8.encode(password)).toString();
    print('MD5 hash (vulnerable): $md5Hash');
  }

  // A07:2021 - Identification and Authentication Failures
  static void demonstrateAuthFailures() {
    print('\n=== A07:2021 - Identification and Authentication Failures ===');
    
    // VULNERABLE: Weak password policy
    List<String> weakPasswords = ['123456', 'password', 'qwerty', 'admin'];
    print('VULNERABLE: Weak passwords accepted:');
    weakPasswords.forEach((password) => print('Password: $password - ACCEPTED'));
    
    // VULNERABLE: No session timeout
    DateTime sessionStart = DateTime.now().subtract(Duration(hours: 24));
    print('VULNERABLE: Session started 24 hours ago - still active');
    print('Session start: $sessionStart');
    
    // VULNERABLE: Predictable session tokens
    String sessionToken = 'session_${DateTime.now().millisecondsSinceEpoch}';
    print('VULNERABLE: Predictable session token: $sessionToken');
  }

  // A08:2021 - Software and Data Integrity Failures
  static void demonstrateIntegrityFailures() {
    print('\n=== A08:2021 - Software and Data Integrity Failures ===');
    
    // VULNERABLE: No integrity checks on data
    print('VULNERABLE: No integrity verification on PII data');
    for (var user in samplePiiData) {
      print('User data: ${user.toJson()} - No checksum or signature');
    }
    
    // VULNERABLE: Unsigned software updates
    Map<String, dynamic> softwareUpdate = {
      'version': '2.0.0',
      'download_url': 'http://malicious-site.com/update.exe',
      'checksum': null,
    };
    print('VULNERABLE: Software update without signature: $softwareUpdate');
  }

  // A09:2021 - Security Logging and Monitoring Failures
  static void demonstrateLoggingFailures() {
    print('\n=== A09:2021 - Security Logging and Monitoring Failures ===');
    
    // VULNERABLE: No logging of sensitive operations
    print('VULNERABLE: Accessing PII without logging');
    for (var user in samplePiiData) {
      print('ACCESSED: ${user.firstName} ${user.lastName} SSN: ${user.socialSecurityNumber}');
    }
    
    // VULNERABLE: Logging sensitive data in plain text
    String logEntry = 'User admin accessed SSN: 123-45-6789 at ${DateTime.now()}';
    print('VULNERABLE: Logging sensitive data: $logEntry');
    
    // VULNERABLE: No alerting on suspicious activities
    int failedLogins = 50;
    print('VULNERABLE: $failedLogins failed login attempts - no alert generated');
  }

  // A10:2021 - Server-Side Request Forgery (SSRF)
  static void demonstrateSSRF() {
    print('\n=== A10:2021 - Server-Side Request Forgery (SSRF) ===');
    
    // VULNERABLE: No URL validation
    String userInput = 'http://internal-server/admin';
    String vulnerableUrl = 'https://api.example.com/fetch?url=$userInput';
    print('VULNERABLE: SSRF vulnerable URL: $vulnerableUrl');
    
    // VULNERABLE: Accessing internal resources
    List<String> internalEndpoints = [
      'http://localhost:8080/admin',
      'http://127.0.0.1:3306/mysql',
      'http://internal-api.company.com/users',
    ];
    print('VULNERABLE: Potential internal endpoints accessible:');
    internalEndpoints.forEach((endpoint) => print('  $endpoint'));
  }

  // Helper methods for demonstration
  static String _weakEncrypt(String data, String key) {
    List<int> bytes = utf8.encode(data + key);
    return base64.encode(bytes);
  }
} 