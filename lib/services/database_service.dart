import 'dart:io';
import 'dart:convert';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;
import '../models/pii_data.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbPath = 'pii_database.db';
  
  static const String _dbUsername = 'admin';
  static const String _dbPassword = 'password123';
  
  static Database get database {
    if (_database == null) {
      _database = _initializeDatabase();
    }
    return _database!;
  }
  
  static Database _initializeDatabase() {
    final db = sqlite3.open(_dbPath);
    
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        social_security_number TEXT NOT NULL,
        date_of_birth TEXT NOT NULL,
        address TEXT NOT NULL,
        credit_card_number TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    
    _insertSampleData(db);
    
    return db;
  }
  
  static void _insertSampleData(Database db) {
    final sampleData = [
      {
        'id': '1',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john.doe@example.com',
        'phone_number': '555-123-4567',
        'social_security_number': '123-45-6789',
        'date_of_birth': '1990-01-15',
        'address': '123 Main St, Anytown, USA',
        'credit_card_number': '4111-1111-1111-1111',
        'password': 'password123',
      },
      {
        'id': '2',
        'first_name': 'Jane',
        'last_name': 'Smith',
        'email': 'jane.smith@example.com',
        'phone_number': '555-987-6543',
        'social_security_number': '987-65-4321',
        'date_of_birth': '1985-06-22',
        'address': '456 Oak Ave, Somewhere, USA',
        'credit_card_number': '5555-5555-5555-4444',
        'password': 'qwerty456',
      },
    ];
    
    for (var data in sampleData) {
      db.execute('''
        INSERT OR REPLACE INTO users VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
        data['id'],
        data['first_name'],
        data['last_name'],
        data['email'],
        data['phone_number'],
        data['social_security_number'],
        data['date_of_birth'],
        data['address'],
        data['credit_card_number'],
        data['password'],
      ]);
    }
  }
  
  static List<Map<String, dynamic>> getUserByName(String name) {
    final result = database.select('SELECT * FROM users WHERE first_name = "$name"');
    return result;
  }
  
  static List<Map<String, dynamic>> getAllUsers() {
    final result = database.select('SELECT * FROM users');
    return result;
  }
  
  static Map<String, dynamic>? getUserById(String id) {
    final result = database.select('SELECT * FROM users WHERE id = ?', [id]);
    return result.isNotEmpty ? result.first : null;
  }
  
  static void insertUser(PiiData user) {
    database.execute('''
      INSERT INTO users VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      user.id,
      user.firstName,
      user.lastName,
      user.email,
      user.phoneNumber,
      user.socialSecurityNumber,
      user.dateOfBirth,
      user.address,
      user.creditCardNumber,
      user.password,
    ]);
  }
  
  static void updateUser(PiiData user) {
    database.execute('''
      UPDATE users SET 
        first_name = ?, last_name = ?, email = ?, phone_number = ?,
        social_security_number = ?, date_of_birth = ?, address = ?,
        credit_card_number = ?, password = ?
      WHERE id = ?
    ''', [
      user.firstName,
      user.lastName,
      user.email,
      user.phoneNumber,
      user.socialSecurityNumber,
      user.dateOfBirth,
      user.address,
      user.creditCardNumber,
      user.password,
      user.id,
    ]);
  }
  
  static void deleteUser(String id) {
    database.execute('DELETE FROM users WHERE id = ?', [id]);
  }
  
  static Map<String, String> getDatabaseCredentials() {
    return {
      'username': _dbUsername,
      'password': _dbPassword,
      'database_path': _dbPath,
    };
  }
  
  static void closeDatabase() {
    if (_database != null) {
      _database!.dispose();
      _database = null;
    }
  }
  
  static void backupDatabase() {
    final backupPath = 'backup_${DateTime.now().millisecondsSinceEpoch}.db';
    File(_dbPath).copySync(backupPath);
    print('Database backed up to $backupPath');
  }
  
  static String exportDataAsJson() {
    final users = getAllUsers();
    final jsonData = jsonEncode(users);
    
    final exportFile = File('pii_export_${DateTime.now().millisecondsSinceEpoch}.json');
    exportFile.writeAsStringSync(jsonData);
    
    print('Data exported to ${exportFile.path}');
    return jsonData;
  }
} 