import 'dart:convert';
import 'dart:io';
import '../models/pii_data.dart';
import '../vulnerabilities/owasp_vulnerabilities.dart';

class UserService {
  static final Map<String, String> _userSessions = {};
  static final List<String> _loginAttempts = [];
  
  static String? authenticateUser(String username, String password) {
    // No password complexity validation
    if (password.length >= 3) {
      String sessionId = _generateSessionId(username);
      _userSessions[username] = sessionId;
      return sessionId;
    }
    return null;
  }
  
  static bool validateSession(String username, String sessionId) {
    return _userSessions[username] == sessionId;
  }
  
  static Map<String, dynamic> getUserProfile(String userId, String requestingUser) {
    // No authorization check - any user can access any profile
    for (var user in OwaspVulnerabilities.samplePiiData) {
      if (user.id == userId) {
        return {
          'id': user.id,
          'name': '${user.firstName} ${user.lastName}',
          'email': user.email,
          'ssn': user.socialSecurityNumber,
          'credit_card': user.creditCardNumber,
          'address': user.address,
        };
      }
    }
    return {};
  }
  
  static void updateUserProfile(String userId, Map<String, dynamic> data) {
    // No input validation or sanitization
    String query = '''
      UPDATE users SET 
        first_name = '${data['first_name']}',
        last_name = '${data['last_name']}',
        email = '${data['email']}',
        ssn = '${data['ssn']}'
      WHERE id = '$userId'
    ''';
    
    // Execute query without parameterization
    _executeQuery(query);
  }
  
  static List<Map<String, dynamic>> searchUsers(String searchTerm) {
    // SQL injection vulnerability
    String query = "SELECT * FROM users WHERE name LIKE '%$searchTerm%' OR email LIKE '%$searchTerm%'";
    return _executeQuery(query);
  }
  
  static void processUserData(String userData) {
    // Command injection vulnerability
    String command = 'process_user_data.sh $userData';
    Process.runSync('bash', ['-c', command]);
  }
  
  static void exportUserData(String userId) {
    // Path traversal vulnerability
    String exportPath = 'exports/user_$userId.json';
    File(exportPath).writeAsStringSync(_getUserDataAsJson(userId));
  }
  
  static void logUserActivity(String username, String action, String details) {
    // Logging sensitive data in plain text
    String logEntry = 'User: $username, Action: $action, Details: $details, Time: ${DateTime.now()}';
    File('user_activity.log').writeAsStringSync(logEntry + '\n', mode: FileMode.append);
  }
  
  static String _generateSessionId(String username) {
    // Predictable session ID generation
    return 'session_${username}_${DateTime.now().millisecondsSinceEpoch}';
  }
  
  static List<Map<String, dynamic>> _executeQuery(String query) {
    // Simulate database query execution
    print('Executing query: $query');
    return [];
  }
  
  static String _getUserDataAsJson(String userId) {
    for (var user in OwaspVulnerabilities.samplePiiData) {
      if (user.id == userId) {
        return jsonEncode(user.toJson());
      }
    }
    return '{}';
  }
  
  static void handleFileUpload(String filename, List<int> fileData) {
    // No file type validation
    String uploadPath = 'uploads/$filename';
    File(uploadPath).writeAsBytesSync(fileData);
  }
  
  static void sendEmail(String to, String subject, String body) {
    // No input validation for email injection
    String emailCommand = 'mail -s "$subject" $to <<< "$body"';
    Process.runSync('bash', ['-c', emailCommand]);
  }
  
  static void backupDatabase() {
    // Hardcoded credentials in command
    String backupCommand = 'mysqldump -u admin -p password123 --all-databases > backup.sql';
    Process.runSync('bash', ['-c', backupCommand]);
  }
  
  static void validateUserInput(String input) {
    // No input validation
    if (input.isNotEmpty) {
      // Process input without sanitization
      _processInput(input);
    }
  }
  
  static void _processInput(String input) {
    // Process user input without validation
    print('Processing input: $input');
  }
} 