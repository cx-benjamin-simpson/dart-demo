# OWASP Top 10 Vulnerabilities Demo with PII Handling

🚨 **EDUCATIONAL PURPOSE ONLY** 🚨

This Dart application demonstrates the **OWASP Top 10 Web Application Security Risks (2021)** while handling Personally Identifiable Information (PII). This is designed for educational purposes to understand common security vulnerabilities and their impact on PII data.

## ⚠️ Important Disclaimer

**This application intentionally contains security vulnerabilities for educational purposes. DO NOT use this code in production environments. The vulnerabilities demonstrated here are examples of what NOT to do in real applications.**

## 📋 OWASP Top 10 Vulnerabilities Covered

### 1. **A01:2021 - Broken Access Control**
- Demonstrates unauthorized access to other users' PII data
- Shows lack of proper authorization checks
- Examples of horizontal and vertical privilege escalation

### 2. **A02:2021 - Cryptographic Failures**
- Plain text storage of sensitive PII data
- Weak encryption algorithms and keys
- Insecure transmission of PII over HTTP

### 3. **A03:2021 - Injection**
- SQL injection vulnerabilities
- Command injection examples
- No input validation or sanitization

### 4. **A04:2021 - Insecure Design**
- Predictable user IDs
- No rate limiting on authentication
- Weak session management

### 5. **A05:2021 - Security Misconfiguration**
- Default credentials and configurations
- Debug mode enabled in production
- Exposed server information

### 6. **A06:2021 - Vulnerable and Outdated Components**
- Outdated library versions
- Known vulnerable encryption algorithms
- Missing security patches

### 7. **A07:2021 - Identification and Authentication Failures**
- Weak password policies
- No session timeout
- Predictable session tokens

### 8. **A08:2021 - Software and Data Integrity Failures**
- No integrity checks on PII data
- Unsigned software updates
- Lack of data validation

### 9. **A09:2021 - Security Logging and Monitoring Failures**
- No logging of sensitive operations
- Plain text logging of PII
- No alerting on suspicious activities

### 10. **A10:2021 - Server-Side Request Forgery (SSRF)**
- No URL validation
- Access to internal resources
- Unrestricted external requests

## 🏗️ Project Structure

```
owasp_pii_demo/
├── lib/
│   ├── main.dart                 # Main application entry point
│   ├── models/
│   │   └── pii_data.dart        # PII data model
│   ├── vulnerabilities/
│   │   └── owasp_vulnerabilities.dart  # OWASP vulnerability demonstrations
│   └── services/
│       ├── database_service.dart # Insecure database operations
│       └── web_service.dart      # Vulnerable web service calls
├── pubspec.yaml                  # Dart dependencies
└── README.md                     # This file
```

## 🚀 Getting Started

### Prerequisites

- Dart SDK (version 3.0.0 or higher)
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd owasp_pii_demo
   ```

2. **Install dependencies:**
   ```bash
   dart pub get
   ```

3. **Generate JSON serialization code:**
   ```bash
   dart run build_runner build
   ```

4. **Run the application:**
   ```bash
   dart run lib/main.dart
   ```

## 🎯 How to Use

The application provides an interactive menu where you can:

1. **Select individual vulnerabilities** to see specific demonstrations
2. **Run all vulnerabilities** at once for a comprehensive overview
3. **View sample PII data** to understand what sensitive information is being handled

### Menu Options

- **1-10**: Individual OWASP vulnerability demonstrations
- **11**: Demonstrate all vulnerabilities sequentially
- **12**: View sample PII data stored in the application
- **0**: Exit the application

## 📊 Sample PII Data

The application includes sample PII data for demonstration purposes:

- **Personal Information**: Names, addresses, phone numbers
- **Financial Data**: Credit card numbers
- **Government IDs**: Social Security Numbers
- **Authentication**: Passwords (stored insecurely)
- **Contact Information**: Email addresses

## 🔍 Vulnerability Examples

### Broken Access Control
```dart
// VULNERABLE: User 1 can access User 2's data
String userId = '1';
String requestedUserId = '2';
PiiData userData = getUserData(requestedUserId); // No authorization check
```

### Cryptographic Failures
```dart
// VULNERABLE: Storing passwords in plain text
String password = 'password123';
storePassword(password); // No hashing or encryption
```

### SQL Injection
```dart
// VULNERABLE: Direct string concatenation
String userInput = "'; DROP TABLE users; --";
String query = "SELECT * FROM users WHERE name = '$userInput'";
```

## 🛡️ Security Best Practices (What NOT to do)

This application demonstrates **anti-patterns** and insecure practices:

❌ **Don't do this in production:**
- Store PII in plain text
- Use weak passwords
- Skip input validation
- Expose sensitive data in logs
- Use HTTP instead of HTTPS
- Hardcode credentials
- Skip authorization checks

✅ **Instead, implement:**
- Strong encryption for PII
- Proper authentication and authorization
- Input validation and sanitization
- Secure logging practices
- HTTPS everywhere
- Environment-based configuration
- Principle of least privilege

## 🧪 Testing

Run the test suite to verify the application works correctly:

```bash
dart test
```

## 📚 Learning Resources

- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Dart Security Best Practices](https://dart.dev/guides/language/effective-dart/usage#do-use-const-for-constant-variables)
- [PII Data Protection Guidelines](https://www.ftc.gov/business-guidance/privacy-security)

## 🤝 Contributing

This is an educational project. If you find issues or want to add more vulnerability examples:

1. Fork the repository
2. Create a feature branch
3. Add your changes
4. Submit a pull request

## 📄 License

This project is for educational purposes only. Use at your own risk.

## ⚖️ Legal Notice

This software is provided "as is" without warranty of any kind. The authors are not responsible for any misuse of this software. This application is designed solely for educational purposes to understand security vulnerabilities.

---

**Remember: Security is everyone's responsibility!** 🔒 