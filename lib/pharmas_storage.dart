import 'dart:convert';
import 'dart:io';

import 'package:niventis_app/pharma.dart';
import 'package:path_provider/path_provider.dart';

class PharmasStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pharmas.json');
  }

  Future<String> readPharmas() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return null
      return null;
    }
  }

  Future<File> writePharmas(List<Pharma> pharmas) async {
    final file = await _localFile;

    // Write the file
    List jsonList = List();
    pharmas.map((item)=>
        jsonList.add(jsonEncode(item.toJson()))
    ).toList();
    print(jsonEncode(jsonList));
    return file.writeAsString(jsonEncode(jsonList));
  }
}
