import 'dart:io';
import 'vulnerabilities/owasp_vulnerabilities.dart';
import 'models/pii_data.dart';

void main(List<String> arguments) async {
  print('🚨 OWASP Top 10 Vulnerabilities Demo with PII Handling 🚨');
  print('=' * 60);
  print('This application demonstrates the top 10 OWASP vulnerabilities');
  print('while handling Personally Identifiable Information (PII).');
  print('⚠️  WARNING: This is for educational purposes only! ⚠️');
  print('=' * 60);

  // Display menu
  await showMenu();
}

Future<void> showMenu() async {
  while (true) {
    print('\n📋 Select a vulnerability to demonstrate:');
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
    print('0.  Exit');
    
    stdout.write('\nEnter your choice (0-12): ');
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
      case '0':
        print('\n👋 Goodbye! Remember to secure your applications!');
        exit(0);
      default:
        print('\n❌ Invalid choice. Please try again.');
    }
    
    stdout.write('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}

void demonstrateAllVulnerabilities() {
  print('\n🔥 Demonstrating ALL OWASP Top 10 Vulnerabilities 🔥');
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
  print('✅ All vulnerabilities demonstrated!');
  print('💡 Remember: These are examples of what NOT to do in production!');
}

void viewSamplePiiData() {
  print('\n📊 Sample PII Data Stored in Application:');
  print('=' * 60);
  
  for (int i = 0; i < OwaspVulnerabilities.samplePiiData.length; i++) {
    var user = OwaspVulnerabilities.samplePiiData[i];
    print('\n👤 User ${i + 1}:');
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
  
  print('\n⚠️  WARNING: This PII data is stored insecurely for demonstration!');
  print('   In a real application, this data should be encrypted and protected!');
} 