import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import './platform_info.dart';

class AppFolder {

  static Future<Directory> document() async{
    var dir = await path_provider.getApplicationDocumentsDirectory();

    if (PlatformInfo.isDesktopOS()) {
      
      dir = Directory(path.join(dir.path, 'test_floor'));
      if (!dir.existsSync()) dir.createSync(recursive: true);
    } 

    return dir;
  }
  
  static Future<dynamic> images({String basenameImageFile = ''}) async {
    
    var dir = await document();
    dir = Directory(path.join(dir.path, 'images'));
    if (!dir.existsSync()) dir.createSync(recursive: true);

    if (basenameImageFile != '') {
      return File(path.join(dir.path, basenameImageFile));
    }

    return dir;

  }

}