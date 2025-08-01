import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getUserFile(String userId) async {
    final path = await localPath;
    return File('$path/user_$userId.json');
  }
}
