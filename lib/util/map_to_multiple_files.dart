import 'dart:convert';
import 'dart:io';
import 'package:i18n_tools/common/common_func.dart';
import 'package:path/path.dart';
import 'LangCodeManage.dart';
import 'dir_file_tools.dart';

///
/// 一个map数据 转换成 多个[json,arb]文件
///
void mapToMultipleFiles(
  Map<String, Map> resMap,
  String outputDirPath,
  String? suffix,
) async {
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
        lang = LangCodeManage.langCodeMapArb[lang] ?? lang;
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
