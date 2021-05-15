import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:i18n_tools/common/common_func.dart';
import 'package:i18n_tools/util/xxx.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import 'dir_file_tools.dart';

const Map<String, String> langCodeMapArb = {
  "zh-cn": "intl_zh_CN", // 英语
  "zh-zh": "intl_zh_TW", // 繁体中文
  "en-us": "intl_en", // 简体中文
  "de-de": "intl_de", // 土耳其语
  "fr-fr": "intl_fr", // 德语
  "es-es": "intl_es", // 法语
  "pt-pt": "intl_pt", // 俄语
  "ru-ru": "intl_ru", // 西班牙语
  "tr-tr": "intl_tr", // 葡萄牙语
  "ar-ar": "intl_ar", // 波兰语
  "id-id": "intl_id", // 印尼语
  "it-it": "intl_it", // 意大利语
  "pl-pl": "intl_pl", // 泰语
  "th-th": "intl_th", // 阿拉伯语
  "kr-kr": "intl_ko", // 韩语
  "jp-jp": "intl_ja", // 日文  //公司内部写错的遗留问题  正确的是 "ja": "ja-jp"
  "vi-vn": "intl_vi", // 越南
};

class ExcelList2Map {
  void excelList2MapOutputFile(
      Map<String, Map> resMap, String outputDirPath, String? suffix) {
    resMap.forEach((key, value) {
      if (key == null) {
        CommonFunc.showToast('有多余空列！！！！！会输出null.json');
        return;
      }
      // String json = jsonEncode(value);
      for (String lang in value.keys) {
        Map content = value[lang] as Map;
        String prettyJsonStr =
            new JsonEncoder.withIndent('    ').convert(content);
        String saveFilePath;
        if (suffix == null) {
          suffix = '.json';
        }
        if (suffix == '.arb') {
          lang = langCodeMapArb[lang] ?? lang;
        }
        saveFilePath = '$outputDirPath/$key/$lang$suffix';
        List<int> bytes = utf8.encode(prettyJsonStr);
        writeFile(saveFilePath, bytes);
      }

      // TODO string 怎么转 ByteData
      // Uint8List bytes = utf8.encode(json);
      // ByteData blob = ByteData.sublistView(bytes);
      // writeFile(saveFile,bytes);
    });
  }

  Map<String, Map<dynamic, dynamic>> excelList2Map(String filePath) {
    /// 解码excel文件 => Map
    var excelBytes = File(filePath).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(excelBytes);
    Map<String, SpreadsheetTable> tables = decoder.tables;

    Map<String, Map<dynamic, dynamic>> listSheetsConvert = {}; // 每个sheet转换后的存储
    Map<String, Map<dynamic, dynamic>> resultMap = {};

    /// 处理
    /// `rows` 是一个行数组 每行是一个单元格数组
    for (String sheetName in tables.keys) {
      SpreadsheetTable? sheetItem = tables[sheetName];
      if (sheetItem == null) {
        continue;
      }
      List<List> _rowsCopy = new List.from(sheetItem.rows);
      Map item = SheetItem().getTable(sheetName, _rowsCopy);
      listSheetsConvert[sheetItem.name] = item;
    }

    return listSheetsConvert;

    /// 合并多个sheet
    // for (String sheetName in listSheetsConvert.keys) {
    //   Map<dynamic, dynamic> sheetMap = listSheetsConvert[sheetName]!;
    //   sheetMap.forEach((key, value) {
    //     if (resultMap.containsKey(key)) {
    //       resultMap[key]!.addAll(value);
    //     } else {
    //       resultMap[key] = value;
    //     }
    //   });
    // }
    // return resultMap;
  }
}

class SheetItem {
  List<String> titles = [];
  Map<String, Map> allLanguages = {};

  Map getTable(String sheetName, List<List> rowsCopy) {
    List<dynamic> rowHead = rowsCopy.removeAt(0); //删除数组,返回删除项,获取标题
    List<List> rowBody = rowsCopy; // 获取内容
    getTableHead(rowHead);
    Map item = getTableBody(sheetName, rowBody);
    return item;
  }

  Map<String, Map> getTableHead(List<dynamic> rowHead) {
    // 分割-输出表头
    for (int i = 0; i < rowHead.length; i++) {
      String str = rowHead[i]; // 取出英文字母(即 国家英文简写标识code)
      // String? langCode = reg.stringMatch(str); // TODO -----
      String? langCode = str; // TODO -----
      if (i == 0) {
        // if(abcdefg === 'key') //TODO  待办
        titles.add(rowHead[i]);
      } else {
        if (langCode == null || langCode == '') {
          // langCode == '' 丢弃——多语言的备注(备注一般给翻译者阅读使用，对程序是无用的)
          throw '\n国家为空: sheetName $i ${rowHead[i]} \nlangCode: $langCode';
        } else {
          // 取出语言标识代码(zh-cn)  从1开始取 因为0是 key
          String langKey = getLangCode(langCode);
          // String langKey = langCode
          titles.add(langKey);
          allLanguages[langKey] = {};
        }
      }
    }
    return allLanguages;
  }

  RegExp reg = new RegExp("[a-zA-Z-]+");
  Map getTableBody(String sheetName, List<List> rowBody) {
    // 分割-输出表内容
    for (int i = 0; i < rowBody.length; i++) {
      List<dynamic> row = rowBody[i];
      // 如果表key为空，则输出md5,以第一列内容输出md5
      for (int j = 1; j < row.length; j++) {
        String lang = titles[j];
        String? value = row[j]; // 默认输出中文
        String rowKey = getKey(row[0], row);
        // String rowKey = getKey(row[0], row) + '---$i+$j';
        _setValue(lang, rowKey, value);
      }
    }
    return allLanguages;
  }

  // 写值
  _setValue(String lang, String rowKey, String? value) {
    // _checkKey(rowKey, titles, row, sheetName);
    Map<dynamic, dynamic>? item = allLanguages[lang];
    if (item != null && value != null) {
      item[rowKey] = value; // value ?? '#intl#'
    }
    // {"en-us":{"key1":"en-us-key1-value1"},"zh-cn":{"key1":"zh-cn-key1-value2"}}
  }

  getKey(String? rowKey, List<dynamic> row) {
    // if (rowKey != null && rowKey.length > 0) {
    //   String abc = reg.stringMatch(rowKey); // 可能key写的是注释 中文
    //   rowKey = abc == '' ? null : abc; // 取出英文字母
    // }
    if (rowKey == null) {
      int langIndex = titles.indexOf('en-us'); // 找到en-us 根据其内容用md5编码 自动生成key
      int langIndex2 = titles.indexOf('zh-cn'); // 找到en-us 根据其内容用md5编码 自动生成key
      String langText;
      String langText1;
      String langText2;
      langText1 = row[langIndex] ?? '';
      langText2 = row[langIndex2] ?? '';
      langText = langText1 + langText2; // 中英混合编码 来适应特殊语言场景 也增加复杂度
      List<int> bytes = utf8.encode(langText); // data being hashed
      String digest = md5.convert(bytes).toString();
      String x16MD5 = digest.substring(8, 24); // 16位md5
      rowKey = x16MD5;
    }
    return rowKey;
  }

  Map keysValues = {};
  List repeatKeysValues = [];
  _checkKey(String rowKey, titles, row, sheetName) {
    if (keysValues.containsKey(rowKey)) {
      String msg = '\n有重复的语言内容key\n'
          '已有的key: $rowKey  值value: ${keysValues[rowKey]}\n'
          '重复的key: $rowKey  值value: $row\n';
      print(msg);
      repeatKeysValues.add(msg);
    }
    keysValues[rowKey] = row;
  }

  getLangCode(String? langCode) {
    String? targetCode;
    langCodeMap.forEach((List<String> element) {
      for (var code in element) {
        if (code == langCode) {
          targetCode = code;
          break; // 结束循环，只能跳出一层
        }
      }
    });
    if(targetCode == null){
      throw '未匹配到多语言支持的lang-code: $langCode';
    }
    return targetCode;
  }

  // Map<String, String> langCodeMap = {
  //   "en": "en-us", // 英语
  //   "zh": "zh-zh", // 繁体中文
  //   "cn": "zh-cn", // 简体中文
  //   "tr": "tr-tr", // 土耳其语
  //   "de": "de-de", // 德语
  //   "fr": "fr-fr", // 法语
  //   "ru": "ru-ru", // 俄语
  //   "es": "es-es", // 西班牙语
  //   "pt": "pt-pt", // 葡萄牙语
  //   "pl": "pl-pl", // 波兰语
  //   "id": "id-id", // 印尼语
  //   "it": "it-it", // 意大利语
  //   "th": "th-th", // 泰语
  //   "ar": "ar-ar", // 阿拉伯语
  //   "kr": "kr-kr", // 韩语
  //   "jp": "jp-jp", // 日文  //公司内部写错的遗留问题  正确的是 "ja": "ja-jp"
  //   "vi": "vi-vn", // 越南
  // };
}
