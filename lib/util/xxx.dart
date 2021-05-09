import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:i18n_tools/util/dir_file_tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

// Future<void> excelToJson(String fileName, String fileDirectory,GlobalKey<ScaffoldState> scaffoldKey) async {
//   ByteData data = await rootBundle.load(fileDirectory);
//   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   var excel = Excel.decodeBytes(bytes);
//   int i = 0;
//   List<dynamic> keys = new List<dynamic>();
//   List<Map<String, dynamic>> json = new List<Map<String, dynamic>>();
//   for (var table in excel.tables.keys) {
//     for (var row in excel.tables[table].rows) {
//       if (i == 0) {
//         keys = row;
//         i++;
//       } else {
//         Map<String, dynamic> temp = Map<String, dynamic>();
//         int j = 0;
//         String tk = '';
//         for (var key in keys) {
//           tk = '"' + key + '"';
//           temp[tk] = (row[j].runtimeType == String)
//               ? '"' + row[j].toString() + '"'
//               : row[j];
//           j++;
//         }
//         json.add(temp);
//       }
//     }
//   }
//   print(json.length);
//   String fullJson = json.toString().substring(1, json
//       .toString()
//       .length - 1);
//
//   fullJson = '{ "DATA" : [$fullJson]}';
//   final directory = await getExternalStorageDirectory();
//
//   File file = await File('${directory.path}/$fileName.json').create();
//   await file.writeAsString(fullJson).then((value) =>
//       scaffoldKey.currentState
//           .showSnackBar(SnackBar(content: Text("Completed")))
//   );
//   print(file.exists().toString());
// }
// Future<String> excelToJson() async {
//   FilePickerResult result =await FilePicker.platform.pickFiles(type:FileType.custom,allowedExtensions: ['xls','xlsx','csv']);
//   if (result != null) {
//     File excelFile = File(result.files.single.path);}
//   var bytes = File(excelFilePath).readAsBytesSync();
//   var excel = Excel.decodeBytes(bytes);
//   int i = 0;
//   List<dynamic> keys = [];
//   var jsonMap = [];
//
//   for (var table in excel.tables.keys) {
//     dev.log(table.toString());
//     for (var row in excel.tables[table].rows) {
//       dev.log(row.toString());
//       if (i == 0) {
//         keys = row;
//         i++;
//       } else {
//         var temp = {};
//         int j = 0;
//         String tk = '';
//         for (var key in keys) {
//           tk = '\"${key.toString()}\"';
//           temp[tk] = (row[j].runtimeType == String)
//               ?  '\"${row[j].toString()}\"'
//               : row[j];
//           j++;
//         }
//
//         jsonMap.add(temp);
//       }
//     }
//   }
//   dev.log(
//     jsonMap.length.toString(),
//     name: 'excel to json',
//   );
//   dev.log(jsonMap.toString(), name: 'excel to json');
//   String fullJson =
//   jsonMap.toString().substring(1, jsonMap.toString().length - 1);
//   dev.log(
//     fullJson.toString(),
//     name: 'excel to json',
//   );
//   return fullJson;
// }

Future<String> jsons(String filesDirectory) async {
  List<FileSystemEntity> fs = []; // 所有的缓存文件
  /// 分享文件夹
  if (await FileSystemEntity.isDirectory(filesDirectory)) {
    fs.addAll(Directory(filesDirectory).listSync());
  }
  Map<String, Map> res1 = {};
  for (FileSystemEntity item in fs) {
    File file = new File(item.path);
    String str = file.readAsStringSync();
    String filename = basename(file.path)
        .split(".")
        .first; // import 'package:path/path.dart';
    res1[filename] = jsonDecode(str);
    // List<dynamic> jsonResult = jsonDecode(jsonString)["DATA"];
  }
  print(res1);

  Map<String, Map> resSort = {};
  langCodeMap.forEach((List<String> element) {
    for (var code in element) {
      if (res1[code] != null) {
        resSort[code] = res1[code]!;
        break; // 结束循环，只能跳出一层
      }
    }
  });

  /// 转换为excel的json格式 []
  List<Map<String, dynamic>> res2 = [];

  /// 输出占位key-value
  String index0 = resSort.keys.first; // 中文开发，为最全的key
  for (String key in resSort[index0]!.keys) {
    Map<String, dynamic> listItem = {};
    listItem['key'] = key;
    resSort.keys.forEach((element) {
      listItem[element] = key;
    });
    res2.add(listItem);
  }

  /// 替换占位 赋值结果
  for (int i = 0; i < res2.length; i++) {
    Iterable langs = res2[i].keys;
    res2[i].forEach((key, value) {
      // 排除初始 key
      if (key != 'key') {
        String val = resSort[key]![value] ?? ''; // 如果没有查出来则为空
        res2[i][key] = val;
      }
    });
  }
  print(res2);
  String outputPath = await jsonToExcel('多语言', res2);
  return outputPath;
}

Future<String> jsonToExcel(
    String fileName, List<Map<String, dynamic>> jsonResult) async {
  // String fileName, String fileDirectory
  // String jsonString = await rootBundle.loadString(fileDirectory);
// List<dynamic> jsonResult = jsonDecode(jsonString)["DATA"];

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  Map<String, dynamic> result = jsonResult[0];
  sheetObject.appendRow(result.keys.toList());

  for (int i = 0; i < jsonResult.length; i++) {
    Map<String, dynamic> result = jsonResult[i];
    sheetObject.appendRow(result.values.toList());
  }
  final PathProviderWindows provider = PathProviderWindows();
  var downloadsDirectory = await provider.getDownloadsPath();
  String outputDirPath = '$downloadsDirectory/gta_i18n_${formattedDate()}';

  final onValue = excel.encode();
  File(("$outputDirPath/$fileName.xlsx"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(onValue!);
  print(sheetObject);
  return "$outputDirPath";
}

List<List<String>> langCodeMap = [
  ["cn", "zh-cn", "intl_zh_CN"], // 简体中文
  ["zh", "zh-zh", "intl_zh_TW"], // 繁体中文
  ["en", "en-us", "intl_en"], // 英语
  ["de", "de-de", "intl_de"], // 德语
  ["fr", "fr-fr", "intl_fr"], // 法语
  ["es", "es-es", "intl_es"], // 西班牙语
  ["pt", "pt-pt", "intl_pt"], // 葡萄牙语
  ["ru", "ru-ru", "intl_ru"], // 俄语
  ["tr", "tr-tr", "intl_tr"], // 土耳其语
  ["ar", "ar-ar", "intl_ar"], // 阿拉伯语
  ["id", "id-id", "intl_id"], // 印尼语
  ["it", "it-it", "intl_it"], // 意大利语
  ["pl", "pl-pl", "intl_pl"], // 波兰语
  ["th", "th-th", "intl_th"], // 泰语
  [
    "kr",
    "kr-kr",
    "intl_ko",
    "ko"
  ], // 韩语 //公司内部写错的遗留问题  正确的是 ko 朝鲜语 ko-KR 朝鲜语(韩国)
  ["jp", "jp-jp", "intl_ja", "ja"], // 日文 //公司内部写错的遗留问题  正确的是 "ja": "ja-JP"
  ["vi", "vi-vn", "intl_vi"], // 越南
];
