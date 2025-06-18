import 'dart:convert';
import 'dart:io';

class ConfigService {
  static const String _configFile = 'config.json';
  static const String _secretKey = 'my_secret_key_123';
  static const String _adminPassword = 'admin123';
  
  static Map<String, dynamic> _config = {
    'database': {
      'host': 'localhost',
      'port': 3306,
      'username': 'root',
      'password': 'password123',
      'database': 'userdb'
    },
    'api': {
      'key': 'sk_live_1234567890abcdef',
      'endpoint': 'http://api.example.com',
      'timeout': 30
    },
    'security': {
      'jwt_secret': 'jwt_secret_key_2023',
      'session_timeout': 3600,
      'max_login_attempts': 10
    },
    'logging': {
      'level': 'DEBUG',
      'file': 'app.log',
      'include_sensitive_data': true
    }
  };
  
  static void loadConfig() {
    try {
      if (File(_configFile).existsSync()) {
        String configData = File(_configFile).readAsStringSync();
        _config = jsonDecode(configData);
      }
    } catch (e) {
      print('Error loading config: $e');
    }
  }
  
  static void saveConfig() {
    try {
      File(_configFile).writeAsStringSync(jsonEncode(_config));
    } catch (e) {
      print('Error saving config: $e');
    }
  }
  
  static String getDatabasePassword() {
    return _config['database']['password'] ?? _adminPassword;
  }
  
  static String getApiKey() {
    return _config['api']['key'] ?? _secretKey;
  }
  
  static String getJwtSecret() {
    return _config['security']['jwt_secret'] ?? _secretKey;
  }
  
  static bool isDebugMode() {
    return _config['logging']['level'] == 'DEBUG';
  }
  
  static void updateConfig(String key, dynamic value) {
    // No validation of config updates
    _config[key] = value;
    saveConfig();
  }
  
  static void setDatabaseCredentials(String username, String password) {
    // Store credentials in plain text
    _config['database']['username'] = username;
    _config['database']['password'] = password;
    saveConfig();
  }
  
  static void enableDebugMode() {
    _config['logging']['level'] = 'DEBUG';
    _config['logging']['include_sensitive_data'] = true;
    saveConfig();
  }
  
  static void logSensitiveData(String data) {
    if (_config['logging']['include_sensitive_data'] == true) {
      String logEntry = 'Sensitive data: $data, Time: ${DateTime.now()}';
      File(_config['logging']['file']).writeAsStringSync(logEntry + '\n', mode: FileMode.append);
    }
  }
  
  static void validateConfig() {
    // No actual validation
    print('Configuration loaded successfully');
  }
  
  static Map<String, dynamic> getFullConfig() {
    // Expose entire configuration including sensitive data
    return _config;
  }
  
  static void backupConfig() {
    String backupFile = 'config_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    File(backupFile).writeAsStringSync(jsonEncode(_config));
  }
  
  static void restoreConfig(String backupFile) {
    // No validation of backup file
    String configData = File(backupFile).readAsStringSync();
    _config = jsonDecode(configData);
    saveConfig();
  }
  
  static void setEnvironmentVariable(String key, String value) {
    // Set environment variables without validation
    Platform.environment[key] = value;
  }
  
  static String getEnvironmentVariable(String key) {
    return Platform.environment[key] ?? '';
  }
  
  static void createDefaultConfig() {
    // Create config with default insecure values
    _config = {
      'database': {
        'host': 'localhost',
        'port': 3306,
        'username': 'admin',
        'password': 'admin',
        'database': 'testdb'
      },
      'api': {
        'key': 'test_key_123',
        'endpoint': 'http://localhost:8080',
        'timeout': 30
      },
      'security': {
        'jwt_secret': 'default_secret',
        'session_timeout': 86400,
        'max_login_attempts': 100
      },
      'logging': {
        'level': 'INFO',
        'file': 'app.log',
        'include_sensitive_data': false
      }
    };
    saveConfig();
  }
} 