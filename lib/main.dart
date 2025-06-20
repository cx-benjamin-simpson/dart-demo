import 'dart:io';
import 'vulnerabilities/owasp_vulnerabilities.dart';
import 'models/pii_data.dart';
import 'services/user_service.dart';
import 'services/config_service.dart';
import 'services/file_service.dart';

void main(List<String> arguments) async {
  print('OWASP Top 10 Vulnerabilities Demo with PII Handling');
  print('=' * 60);
  print('This application demonstrates the top 10 OWASP vulnerabilities');
  print('while handling Personally Identifiable Information (PII).');
  print('Educational purposes only!');
  print('=' * 60);

  await showMenu();
}

Future<void> showMenu() async {
  while (true) {
    print('\nSelect a vulnerability to demonstrate:');
    print('1.  A01:2021 - Broken Access Control');
    print('2.  A02:2021 - Cryptographic Failures');
    print('3.  A03:2021 - Injection');
    print('4.  A04:2021 - Insecure Design');
    print('5.  A05:2021 - Security Misconfiguration');
    print('6.  A06:2021 - Vulnerable and Outdated Components');
    print('7.  A07:2021 - Identification and Authentication Failures');
    print('8.  A08:2021 - Software and Data Integrity Failures');
    print('9.  A09:2021 - Security Logging and Monitoring Failures');
    print('10. A10:2021 - Server-Side Request Forgery (SSRF)');
    print('11. Demonstrate All Vulnerabilities');
    print('12. View Sample PII Data');
    print('13. User Service Vulnerabilities');
    print('14. Configuration Service Vulnerabilities');
    print('15. File Service Path Traversal');
    print('0.  Exit');
    
    stdout.write('\nEnter your choice (0-15): ');
    String? choice = stdin.readLineSync();
    
    switch (choice) {
      case '1':
        OwaspVulnerabilities.demonstrateBrokenAccessControl();
        break;
      case '2':
        OwaspVulnerabilities.demonstrateCryptographicFailures();
        break;
      case '3':
        OwaspVulnerabilities.demonstrateInjection();
        break;
      case '4':
        OwaspVulnerabilities.demonstrateInsecureDesign();
        break;
      case '5':
        OwaspVulnerabilities.demonstrateSecurityMisconfiguration();
        break;
      case '6':
        OwaspVulnerabilities.demonstrateVulnerableComponents();
        break;
      case '7':
        OwaspVulnerabilities.demonstrateAuthFailures();
        break;
      case '8':
        OwaspVulnerabilities.demonstrateIntegrityFailures();
        break;
      case '9':
        OwaspVulnerabilities.demonstrateLoggingFailures();
        break;
      case '10':
        OwaspVulnerabilities.demonstrateSSRF();
        break;
      case '11':
        demonstrateAllVulnerabilities();
        break;
      case '12':
        viewSamplePiiData();
        break;
      case '13':
        demonstrateUserServiceVulnerabilities();
        break;
      case '14':
        demonstrateConfigServiceVulnerabilities();
        break;
      case '15':
        await demonstrateFileServiceVulnerabilities();
        break;
      case '0':
        print('\nGoodbye! Remember to secure your applications!');
        exit(0);
      default:
        print('\nInvalid choice. Please try again.');
    }
    
    stdout.write('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}

void demonstrateAllVulnerabilities() {
  print('\nDemonstrating ALL OWASP Top 10 Vulnerabilities');
  print('=' * 60);
  
  OwaspVulnerabilities.demonstrateBrokenAccessControl();
  OwaspVulnerabilities.demonstrateCryptographicFailures();
  OwaspVulnerabilities.demonstrateInjection();
  OwaspVulnerabilities.demonstrateInsecureDesign();
  OwaspVulnerabilities.demonstrateSecurityMisconfiguration();
  OwaspVulnerabilities.demonstrateVulnerableComponents();
  OwaspVulnerabilities.demonstrateAuthFailures();
  OwaspVulnerabilities.demonstrateIntegrityFailures();
  OwaspVulnerabilities.demonstrateLoggingFailures();
  OwaspVulnerabilities.demonstrateSSRF();
  
  print('\n' + '=' * 60);
  print('All vulnerabilities demonstrated!');
  print('Remember: These are examples of what NOT to do in production!');
}

void viewSamplePiiData() {
  print('\nSample PII Data Stored in Application:');
  print('=' * 60);
  
  for (int i = 0; i < OwaspVulnerabilities.samplePiiData.length; i++) {
    var user = OwaspVulnerabilities.samplePiiData[i];
    print('\nUser ${i + 1}:');
    print('   ID: ${user.id}');
    print('   Name: ${user.firstName} ${user.lastName}');
    print('   Email: ${user.email}');
    print('   Phone: ${user.phoneNumber}');
    print('   SSN: ${user.socialSecurityNumber}');
    print('   DOB: ${user.dateOfBirth}');
    print('   Address: ${user.address}');
    print('   Credit Card: ${user.creditCardNumber}');
    print('   Password: ${user.password}');
  }
  
  print('\nWARNING: This PII data is stored insecurely for demonstration!');
  print('In a real application, this data should be encrypted and protected!');
}

void demonstrateUserServiceVulnerabilities() {
  print('\nUser Service Vulnerabilities');
  print('=' * 60);
  
  // Weak authentication
  String sessionId = UserService.authenticateUser('admin', '123');
  print('Authentication result: $sessionId');
  
  // Broken access control
  Map<String, dynamic> profile = UserService.getUserProfile('2', '1');
  print('User 1 accessed User 2 profile: $profile');
  
  // SQL injection
  UserService.searchUsers("'; DROP TABLE users; --");
  
  // Command injection
  UserService.processUserData("test; rm -rf /");
  
  // Path traversal
  UserService.exportUserData("../../../etc/passwd");
  
  // Logging sensitive data
  UserService.logUserActivity('admin', 'view_ssn', '123-45-6789');
  
  // File upload without validation
  UserService.handleFileUpload('malicious.php', [60, 63, 112, 104, 112, 32, 101, 118, 97, 108, 40, 36, 95, 71, 69, 84, 91, 39, 99, 109, 100, 39, 93, 41, 59, 32, 63, 62]);
  
  // Email injection
  UserService.sendEmail('user@example.com', 'Test', 'Hello; rm -rf /');
  
  // Hardcoded credentials
  UserService.backupDatabase();
  
  // No input validation
  UserService.validateUserInput("<script>alert('xss')</script>");
}

void demonstrateConfigServiceVulnerabilities() {
  print('\nConfiguration Service Vulnerabilities');
  print('=' * 60);
  
  // Load configuration
  ConfigService.loadConfig();
  
  // Expose sensitive configuration
  Map<String, dynamic> fullConfig = ConfigService.getFullConfig();
  print('Full configuration exposed: $fullConfig');
  
  // Weak password validation
  String dbPassword = ConfigService.getDatabasePassword();
  print('Database password: $dbPassword');
  
  // Expose API key
  String apiKey = ConfigService.getApiKey();
  print('API key: $apiKey');
  
  // Weak JWT secret
  String jwtSecret = ConfigService.getJwtSecret();
  print('JWT secret: $jwtSecret');
  
  // Debug mode enabled
  bool debugMode = ConfigService.isDebugMode();
  print('Debug mode: $debugMode');
  
  // No config validation
  ConfigService.updateConfig('malicious_key', 'malicious_value');
  
  // Store credentials in plain text
  ConfigService.setDatabaseCredentials('admin', 'password123');
  
  // Enable debug mode
  ConfigService.enableDebugMode();
  
  // Log sensitive data
  ConfigService.logSensitiveData('SSN: 123-45-6789, Credit Card: 4111-1111-1111-1111');
  
  // No validation of config updates
  ConfigService.updateConfig('security', {'jwt_secret': 'new_weak_secret'});
  
  // Backup configuration with sensitive data
  ConfigService.backupConfig();
  
  // No validation of backup restoration
  ConfigService.restoreConfig('config_backup_123.json');
  
  // Set environment variables without validation
  ConfigService.setEnvironmentVariable('DB_PASSWORD', 'plaintext_password');
  
  // Create default insecure configuration
  ConfigService.createDefaultConfig();
}

Future<void> demonstrateFileServiceVulnerabilities() async {
  print('\nFile Service Path Traversal Vulnerabilities');
  print('=' * 60);
  
  // Create a test file first
  File('test_file.txt').writeAsStringSync('This is a test file with sensitive data');
  
  // Normal file access
  print('\n1. Normal file access:');
  FileService.setUserInput('test_file.txt');
  String content = await FileService.readFile();
  print('File content: $content');
  
  // Path traversal vulnerability - accessing parent directory
  print('\n2. Path traversal - accessing parent directory:');
  FileService.setUserInput('../test_file.txt');
  await FileService.readFile();
  
  // Path traversal vulnerability - accessing system files
  print('\n3. Path traversal - attempting to access system files:');
  FileService.setUserInput('../../../etc/passwd');
  await FileService.readFile();
  
  // Path traversal vulnerability - accessing config files
  print('\n4. Path traversal - accessing config files:');
  FileService.setUserInput('../config.json');
  await FileService.readFile();
  
  // Path traversal vulnerability - writing to unauthorized locations
  print('\n5. Path traversal - writing to unauthorized location:');
  FileService.setUserInput('../malicious_file.txt');
  await FileService.writeFile('Malicious content written to unauthorized location');
  
  // Path traversal vulnerability - creating directories
  print('\n6. Path traversal - creating unauthorized directories:');
  FileService.setUserInput('../unauthorized_directory');
  await FileService.createUserDirectory();
  
  // Path traversal vulnerability - copying files
  print('\n7. Path traversal - copying files to unauthorized location:');
  FileService.setUserInput('test_file.txt');
  await FileService.copyFile('../stolen_file.txt');
  
  // Path traversal vulnerability - deleting files
  print('\n8. Path traversal - attempting to delete system files:');
  FileService.setUserInput('../../../important_system_file.txt');
  await FileService.deleteFile();
  
  // Path traversal vulnerability - exporting data
  print('\n9. Path traversal - exporting data to unauthorized location:');
  FileService.setUserInput('../stolen_data.json');
  await FileService.exportData('{"ssn": "123-45-6789", "credit_card": "4111-1111-1111-1111"}');
  
  // Path traversal vulnerability - importing data
  print('\n10. Path traversal - importing from unauthorized location:');
  FileService.setUserInput('../sensitive_data.json');
  await FileService.importData();
  
  // Path traversal vulnerability - processing files
  print('\n11. Path traversal - processing files from unauthorized location:');
  FileService.setUserInput('../user_data.txt');
  await FileService.processUserFile();
  
  // Path traversal vulnerability - file validation
  print('\n12. Path traversal - validating files from unauthorized location:');
  FileService.setUserInput('../system_config.txt');
  await FileService.validateFile();
  
  // Path traversal vulnerability - searching files
  print('\n13. Path traversal - searching in unauthorized locations:');
  List<String> files = await FileService.searchFiles('passwd');
  print('Found files: $files');
  
  // Path traversal vulnerability - getting file info
  print('\n14. Path traversal - getting info about unauthorized files:');
  FileService.setUserInput('../.env');
  Map<String, dynamic> fileInfo = await FileService.getFileInfo();
  print('File info: $fileInfo');
  
  // Path traversal vulnerability - creating backups
  print('\n15. Path traversal - creating backups in unauthorized locations:');
  FileService.setUserInput('../sensitive_file.txt');
  await FileService.createBackup();
  
  print('\nPath traversal vulnerabilities demonstrated!');
  print('These vulnerabilities allow access to files outside the intended directory.');
} 