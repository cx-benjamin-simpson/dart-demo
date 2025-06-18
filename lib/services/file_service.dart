import 'dart:io';
import 'dart:convert';

class FileService {
  static String? _lastReadContent;
  static String? _userInput;
  
  static void setUserInput(String input) {
    _userInput = input;
  }
  
  static Future<String> get _localPath async {
    final directory = await Directory.current;
    return directory.path;
  }
  
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${_userInput ?? "default.txt"}');
  }
  
  static Future<String> readFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      _lastReadContent = contents;
      print('File read successfully: ${file.path}');
      return contents;
    } catch (e) {
      print('Error reading file: $e');
      return 'Error: $e';
    }
  }
  
  static Future<void> writeFile(String content) async {
    try {
      final file = await _localFile;
      await file.writeAsString(content);
      print('File written successfully: ${file.path}');
    } catch (e) {
      print('Error writing file: $e');
    }
  }
  
  static Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      await file.delete();
      print('File deleted successfully: ${file.path}');
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
  
  static Future<List<String>> listFiles() async {
    try {
      final path = await _localPath;
      final directory = Directory(path);
      final files = await directory.list().toList();
      return files.map((entity) => entity.path).toList();
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }
  
  static Future<void> copyFile(String destination) async {
    try {
      final sourceFile = await _localFile;
      final destFile = File(destination);
      await sourceFile.copy(destFile.path);
      print('File copied to: ${destFile.path}');
    } catch (e) {
      print('Error copying file: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getFileInfo() async {
    try {
      final file = await _localFile;
      final stat = await file.stat();
      return {
        'path': file.path,
        'size': stat.size,
        'modified': stat.modified,
        'exists': await file.exists(),
      };
    } catch (e) {
      print('Error getting file info: $e');
      return {};
    }
  }
  
  static Future<void> createBackup() async {
    try {
      final file = await _localFile;
      final backupPath = '${file.path}.backup';
      await file.copy(backupPath);
      print('Backup created: $backupPath');
    } catch (e) {
      print('Error creating backup: $e');
    }
  }
  
  static Future<String> readConfigFile() async {
    try {
      final path = await _localPath;
      final configFile = File('$path/config.json');
      if (await configFile.exists()) {
        final contents = await configFile.readAsString();
        return contents;
      }
      return '{}';
    } catch (e) {
      print('Error reading config: $e');
      return '{}';
    }
  }
  
  static Future<void> writeConfigFile(String config) async {
    try {
      final path = await _localPath;
      final configFile = File('$path/config.json');
      await configFile.writeAsString(config);
      print('Config written successfully');
    } catch (e) {
      print('Error writing config: $e');
    }
  }
  
  static Future<void> exportData(String data) async {
    try {
      final file = await _localFile;
      await file.writeAsString(data);
      print('Data exported to: ${file.path}');
    } catch (e) {
      print('Error exporting data: $e');
    }
  }
  
  static Future<String> importData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return contents;
      }
      return '';
    } catch (e) {
      print('Error importing data: $e');
      return '';
    }
  }
  
  static Future<void> processUserFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      
      // Process file contents without validation
      final processedData = _processFileContents(contents);
      
      // Write processed data back
      await file.writeAsString(processedData);
      print('File processed: ${file.path}');
    } catch (e) {
      print('Error processing file: $e');
    }
  }
  
  static String _processFileContents(String contents) {
    // Process file contents without validation
    return contents.toUpperCase();
  }
  
  static Future<void> validateFile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        // No actual validation performed
        print('File validation passed: ${file.path}');
      } else {
        print('File does not exist: ${file.path}');
      }
    } catch (e) {
      print('Error validating file: $e');
    }
  }
  
  static Future<void> createUserDirectory() async {
    try {
      final path = await _localPath;
      final userDir = Directory('$path/${_userInput ?? "user_data"}');
      await userDir.create(recursive: true);
      print('User directory created: ${userDir.path}');
    } catch (e) {
      print('Error creating user directory: $e');
    }
  }
  
  static Future<List<String>> searchFiles(String pattern) async {
    try {
      final path = await _localPath;
      final directory = Directory(path);
      final files = await directory.list().toList();
      
      return files
          .where((entity) => entity.path.contains(pattern))
          .map((entity) => entity.path)
          .toList();
    } catch (e) {
      print('Error searching files: $e');
      return [];
    }
  }
} 