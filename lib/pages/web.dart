
import 'dart:convert';

import 'package:excel/excel.dart';

import '../util/dir_file_tools.dart';
import '../util/excel_list_2_map.dart';

class WebI18n extends ExcelList2Map{
  // web
  void excelList2MapOutputFile(Map resMap, String outputDirPath) {
    resMap.forEach((key, value) {
      // String json = jsonEncode(value);
      String prettyJsonStr = new JsonEncoder.withIndent('    ').convert(value);
      String saveFile = '$outputDirPath/$key.json';
      List<int> bytes = utf8.encode(prettyJsonStr);
      writeFile(saveFile, bytes);

      // TODO string 怎么转 ByteData
      // Uint8List bytes = utf8.encode(json);
      // ByteData blob = ByteData.sublistView(bytes);
      // writeFile(saveFile,bytes);
    });
  }
}