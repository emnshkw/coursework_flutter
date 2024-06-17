import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    _directory = await getApplicationDocumentsDirectory();

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
    // To get the external path from device of download folder
    // final String directory = await getExternalDocumentPath();
    // return directory;
  }

  static Future<File> writeCounter(String text, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    // Write the data in the file you have created
    return file.writeAsString(text);
  }

  static Future<String> read() async {
    String text = '';
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/favourites.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }
}

// Stream<Response> get_restaurants_as_stream()async*{
//   yield* Stream.periodic(Duration(seconds: 5), (_) {
//     return get(Uri.parse('https://eatbro.ru/api/v1/arkhangelsk'), headers: {
//       'Content-Type': 'text/html',
//       'charset': 'UTF-8',
//       'Authorization': "Token e50a1b2bc189e8cc23324beff755db705ac9f062"
//     });
//   }).asyncMap((event) async => await event);
// }
