import 'package:test/test.dart';
import 'package:owasp_pii_demo/vulnerabilities/owasp_vulnerabilities.dart';
import 'package:owasp_pii_demo/models/pii_data.dart';

void main() {
  group('OWASP Vulnerabilities Tests', () {
    test('should demonstrate broken access control vulnerability', () {
      // This test demonstrates the vulnerability, not fixes it
      expect(() {
        // Simulate user 1 accessing user 2's data
        String userId = '1';
        String requestedUserId = '2';
        
        // VULNERABLE: No authorization check
        var userData = OwaspVulnerabilities.samplePiiData.firstWhere(
          (data) => data.id == requestedUserId,
        );
        
        // This should fail in a secure system, but passes in vulnerable system
        expect(userData.id, equals(requestedUserId));
        expect(userData.firstName, isNotEmpty);
      }, returnsNormally);
    });

    test('should demonstrate cryptographic failures', () {
      // Test that passwords are stored in plain text
      for (var user in OwaspVulnerabilities.samplePiiData) {
        expect(user.password, isA<String>());
        expect(user.password.length, greaterThan(0));
        
        // VULNERABLE: Password is in plain text
        expect(user.password, isNot(equals('')));
        
        // Test weak encryption
        String sensitiveData = '123-45-6789';
        String weakKey = 'secret123';
        String encrypted = _weakEncrypt(sensitiveData, weakKey);
        
        // VULNERABLE: Weak encryption can be easily reversed
        expect(encrypted, isNotEmpty);
      }
    });

    test('should demonstrate injection vulnerabilities', () {
      // Test SQL injection vulnerability
      String maliciousInput = "'; DROP TABLE users; --";
      String vulnerableQuery = "SELECT * FROM users WHERE name = '$maliciousInput'";
      
      // VULNERABLE: Query contains malicious input
      expect(vulnerableQuery, contains(maliciousInput));
      expect(vulnerableQuery, contains('DROP TABLE'));
      
      // Test command injection
      String maliciousFilename = 'file.txt; rm -rf /';
      String vulnerableCommand = 'cat $maliciousFilename';
      
      expect(vulnerableCommand, contains(maliciousFilename));
    });

    test('should demonstrate insecure design', () {
      // Test predictable IDs
      for (var user in OwaspVulnerabilities.samplePiiData) {
        expect(user.id, isA<String>());
        // VULNERABLE: IDs are predictable (1, 2, etc.)
        expect(int.tryParse(user.id), isNotNull);
      }
    });

    test('should demonstrate security misconfiguration', () {
      // Test that debug information is exposed
      bool debugMode = true;
      expect(debugMode, isTrue);
      
      // VULNERABLE: Debug mode enabled in production
      if (debugMode) {
        expect(true, isTrue); // Simulates debug information exposure
      }
    });

    test('should demonstrate authentication failures', () {
      // Test weak password acceptance
      List<String> weakPasswords = ['123456', 'password', 'qwerty', 'admin'];
      
      for (String password in weakPasswords) {
        // VULNERABLE: Weak passwords are accepted
        expect(password.length, lessThan(8));
        expect(password, isNot(contains(RegExp(r'[A-Z]'))));
      }
    });

    test('should demonstrate integrity failures', () {
      // Test that PII data has no integrity checks
      for (var user in OwaspVulnerabilities.samplePiiData) {
        var jsonData = user.toJson();
        
        // VULNERABLE: No checksum or signature
        expect(jsonData, isA<Map<String, dynamic>>());
        expect(jsonData['id'], isNotNull);
        expect(jsonData['social_security_number'], isNotNull);
        
        // No integrity verification
        expect(jsonData.containsKey('checksum'), isFalse);
        expect(jsonData.containsKey('signature'), isFalse);
      }
    });

    test('should demonstrate logging failures', () {
      // Test that sensitive operations are not logged
      for (var user in OwaspVulnerabilities.samplePiiData) {
        // VULNERABLE: Accessing PII without logging
        expect(user.socialSecurityNumber, isNotEmpty);
        expect(user.creditCardNumber, isNotEmpty);
        
        // No audit trail created
        // In a real test, we would verify that no log entry was created
      }
    });

    test('should demonstrate SSRF vulnerabilities', () {
      // Test URL validation bypass
      List<String> maliciousUrls = [
        'http://localhost:8080/admin',
        'http://127.0.0.1:3306/mysql',
        'http://internal-api.company.com/users',
      ];
      
      for (String url in maliciousUrls) {
        // VULNERABLE: No URL validation
        expect(url, contains('localhost') | contains('127.0.0.1') | contains('internal'));
      }
    });

    test('should demonstrate PII data exposure', () {
      // Test that PII data is exposed in various ways
      for (var user in OwaspVulnerabilities.samplePiiData) {
        // VULNERABLE: PII data is accessible
        expect(user.firstName, isNotEmpty);
        expect(user.lastName, isNotEmpty);
        expect(user.email, isNotEmpty);
        expect(user.socialSecurityNumber, isNotEmpty);
        expect(user.creditCardNumber, isNotEmpty);
        expect(user.password, isNotEmpty);
        
        // VULNERABLE: toString() method exposes all PII
        String userString = user.toString();
        expect(userString, contains(user.socialSecurityNumber));
        expect(userString, contains(user.creditCardNumber));
        expect(userString, contains(user.password));
      }
    });
  });

  group('PII Data Model Tests', () {
    test('should serialize and deserialize PII data', () {
      var user = PiiData(
        id: 'test-1',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        phoneNumber: '555-123-4567',
        socialSecurityNumber: '123-45-6789',
        dateOfBirth: '1990-01-01',
        address: '123 Test St',
        creditCardNumber: '4111-1111-1111-1111',
        password: 'testpassword',
      );

      var json = user.toJson();
      var deserializedUser = PiiData.fromJson(json);

      expect(deserializedUser.id, equals(user.id));
      expect(deserializedUser.firstName, equals(user.firstName));
      expect(deserializedUser.lastName, equals(user.lastName));
      expect(deserializedUser.email, equals(user.email));
      expect(deserializedUser.phoneNumber, equals(user.phoneNumber));
      expect(deserializedUser.socialSecurityNumber, equals(user.socialSecurityNumber));
      expect(deserializedUser.dateOfBirth, equals(user.dateOfBirth));
      expect(deserializedUser.address, equals(user.address));
      expect(deserializedUser.creditCardNumber, equals(user.creditCardNumber));
      expect(deserializedUser.password, equals(user.password));
    });

    test('should expose PII in toString method', () {
      var user = PiiData(
        id: 'test-2',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phoneNumber: '555-987-6543',
        socialSecurityNumber: '987-65-4321',
        dateOfBirth: '1985-06-15',
        address: '456 Oak Ave',
        creditCardNumber: '5555-5555-5555-4444',
        password: 'secretpass',
      );

      String userString = user.toString();
      
      // VULNERABLE: toString() exposes sensitive data
      expect(userString, contains(user.socialSecurityNumber));
      expect(userString, contains(user.creditCardNumber));
      expect(userString, contains(user.password));
    });
  });
}

// Helper function to simulate weak encryption
String _weakEncrypt(String data, String key) {
  // Simulate weak encryption (base64 encoding)
  List<int> bytes = data.codeUnits + key.codeUnits;
  return String.fromCharCodes(bytes);
} 