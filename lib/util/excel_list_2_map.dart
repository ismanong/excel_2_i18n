import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

import 'dir_file_tools.dart';

class ExcelList2Map {
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

  Map<String, Map<dynamic, dynamic>> excelList2Map(
      Map<String, Sheet> excelTables) {
    // for (var table in excel.tables.keys) {
    //   print('sheet name: '+ table); //sheet Name
    //   print('maxCols   : '+ excel.tables[table].maxCols.toString());
    //   print('maxRows   : '+ excel.tables[table].maxRows.toString());
    //   for (var row in excel.tables[table].rows) {
    //     print("$row");
    //   }
    // }
    List<Map<dynamic, dynamic>> res = [];
    Map<String, Map<dynamic, dynamic>> resMap = {};
    excelTables.keys.forEach((String sheetName) {
      Sheet sheet = excelTables[sheetName];
      List<List<dynamic>> rows = sheet.rows;
      Map item = excelList2MapItem(sheetName, rows);
      res.add(item);
    });

    res.forEach((Map<dynamic, dynamic> element) {
      element.forEach((key, value) {
        if (resMap.containsKey(key)) {
          resMap[key].addAll(value);
        } else {
          resMap[key] = value;
        }
      });
    });
    return resMap;
  }

  RegExp reg = new RegExp("[a-zA-Z-]+");
  Map excelList2MapItem(String sheetName, List<List<dynamic>> rows) {
    // `rows` 是一个行数组 每行是一个单元格数组
    List<dynamic> titleRow = rows[0];
    Map allLanguages = {};
    List<String> titles = [];
    // 分割-输出表头
    for (int i = 0; i < titleRow.length; i++) {
      String str = titleRow[i].toString(); // 取出英文字母(即 国家英文简写标识code)
      String langCode = reg.stringMatch(str);
      if (i == 0) {
        // if(abcdefg === 'key') //TODO  待办
        titles.add(titleRow[i]);
      } else {
        if (langCode == '') {
          // langCode == '' 丢弃——多语言的备注(备注一般给翻译者阅读使用，对程序是无用的)
          throw '国家为空';
        } else {
          // 取出语言标识代码(zh-cn)  从1开始取 因为0是 key
          String langKey = getLangCode(langCode);
          // String langKey = langCode
          titles.add(langKey);
          allLanguages[langKey] = {};
        }
      }
    }

    // 分割-输出表内容
    for (int i = 1; i < rows.length; i++) {
      List<dynamic> row = rows[i];
      // 如果表key为空，则输出md5,以第一列内容输出md5
      String rowKey = getKey(row[0], titles, row);
      _checkKey(rowKey,titles,row,sheetName);

      for (int j = 1; j < row.length; j++) {
        // titles[j] 获取语言标识 row[0] 获取此行语言的key row[j] 获取此行语言的value
        // allLanguages[titles[j]][row_key] = row[j] ?? row_key;
        if (allLanguages[titles[j]][sheetName] == null) {
          allLanguages[titles[j]][sheetName] = {};
        }
        // Map sss = {};
        // sss[row_key] = row[j] ?? row_key;
        // if(allLanguages[titles[j]][sheetName].containsKey(row_key)){
        //   Map mmm = allLanguages[titles[j]][sheetName];
        //   mmm.addAll(sss);
        // }else{
        // String val = row[j] ?? row[titles.indexOf('en-us')]; /// 默认英文
        allLanguages[titles[j]][sheetName][rowKey] = row[j] ?? rowKey;
        // }
        /// {"en-us":{"key1":"en-us-key1-value1"},"zh-cn":{"key1":"zh-cn-key1-value2"}}
      }
    }
    return allLanguages;
  }

  getKey(String rowKey, titles, row) {
    // if (rowKey != null && rowKey.length > 0) {
    //   String abc = reg.stringMatch(rowKey); // 可能key写的是注释 中文
    //   rowKey = abc == '' ? null : abc; // 取出英文字母
    // }
    // if (rowKey == null) {
      int langIndex = titles.indexOf('en-us'); // 找到en-us 根据其内容用md5编码 自动生成key
      int langIndex2 = titles.indexOf('zh-cn'); // 找到en-us 根据其内容用md5编码 自动生成key
      String langText = row[langIndex] + row[langIndex2]; // 中英混合编码 来适应特殊语言场景 也增加复杂度
      List<int> bytes = utf8.encode(langText); // data being hashed
      String digest = md5.convert(bytes).toString();
      String x16MD5 = digest.substring(8, 24); // 16位md5
      rowKey = x16MD5;
    // }
    return rowKey;
  }

  Map keysValues = {};
  List repeatKeysValues = [];
  _checkKey(String rowKey, titles, row, sheetName){
    if (keysValues.containsKey(rowKey)) {
      String msg = '\n有重复的语言内容key\n'
          '已有的key: $rowKey  值value: ${keysValues[rowKey]}\n'
          '重复的key: $rowKey  值value: $row\n';
      print(msg);
      repeatKeysValues.add(msg);
    }
    keysValues[rowKey] = row;
  }

  getLangCode(String langCode) {
    return langCodeMap[langCode];
  }

  Map<String, String> langCodeMap = {
    "en": "en-us", // 英语
    "zh": "zh-zh", // 繁体中文
    "cn": "zh-cn", // 简体中文
    "tr": "tr-tr", // 土耳其语
    "de": "de-de", // 德语
    "fr": "fr-fr", // 法语
    "ru": "ru-ru", // 俄语
    "es": "es-es", // 西班牙语
    "pt": "pt-pt", // 葡萄牙语
    "pl": "pl-pl", // 波兰语
    "id": "id-id", // 印尼语
    "it": "it-it", // 意大利语
    "th": "th-th", // 泰语
    "ar": "ar-ar", // 阿拉伯语
    "kr": "kr-kr", // 韩语
    "jp": "jp-jp", // 日文  //公司内部写错的遗留问题  正确的是 "ja": "ja-jp"
    "vi": "vi-vn", // 越南
  };
}
