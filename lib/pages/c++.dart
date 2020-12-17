
import 'dart:convert';

import 'package:excel/excel.dart';

import '../util/dir_file_tools.dart';
import '../util/excel_list_2_map.dart';

class CppI18n extends ExcelList2Map{

  bool _isPassRepeatKey = false; // 是否跳过重复的 则覆盖之前的重复的row
  String _langKey; // 使用固定语言作为key
  bool _isMergeSheets = false; // 是否合并多张数据表
  bool _isSimplifyLangCode = false; // 是否简写语言code: en -> en-us

  // c++
  void excelList2MapOutputFile(Map resMap, String outputDirPath) {
    resMap.forEach((key, value) {
      // String json = jsonEncode(value);
      String prettyJsonStr = new JsonEncoder.withIndent('    ').convert(value);
      String saveFile = '$outputDirPath/$key.json';
      List<int> bytes = utf8.encode(prettyJsonStr);
      writeFile(saveFile, bytes);
    });
  }

  @override
  Map<String, Map<dynamic, dynamic>> excelList2Map(Map<String, Sheet> excelTables,
      {bool isPassRepeatKey, String langKey, bool isMergeSheets, bool isSimplifyLangCode}) {
    if (isPassRepeatKey != null) {
      _isPassRepeatKey = isPassRepeatKey;
    }
    if (langKey != null) {
      _langKey = langKey;
    }
    if (isSimplifyLangCode != null) {
      _isSimplifyLangCode = isSimplifyLangCode;
    }
    Map<String, Map<dynamic, dynamic>> resMapSuper = super.excelList2Map(excelTables);
    Map<String, Map<dynamic, dynamic>> resMap = {};

    resMapSuper.forEach((key, value) {
      Map<dynamic, dynamic> mMerges = {};
      value.forEach((key2, value2) => mMerges.addAll(value2));
      if (resMap.containsKey(key)) {
        resMap['$key/lang'].addAll(mMerges);
      } else {
        resMap['$key/lang'] = mMerges;
      }
    });
    return resMap;
  }

  @override
  getKey (String rowKey,titles,row){
    if (rowKey == null) {
      int langText = titles.indexOf(_langKey);
      rowKey = row[langText];
    }
    return rowKey.trim(); // 去掉前后空格
  }

  @override
  getLangCode (String langCode){
    return langCode;
  }


}