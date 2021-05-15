import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'LangCodeManage.dart';

///
/// 多个[json,arb]文件 转换成 一个map数据
///
Future<List<Map<String, dynamic>>> multipleFilesToMap(String directory) async {
  List<FileSystemEntity> fs = []; // 所有的缓存文件
  /// 分享文件夹
  if (await FileSystemEntity.isDirectory(directory)) {
    fs.addAll(Directory(directory).listSync());
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
  LangCodeManage.langCodeMap.forEach((List<String> element) {
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
  return res2;
}
