import 'dart:io';
import 'package:excel/excel.dart';
import 'package:i18n_tools/util/dir_file_tools.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

Future<String> mapToExcel(
    String fileName, List<Map<String, dynamic>> dataList) async {
  // String fileName, String fileDirectory
  // String jsonString = await rootBundle.loadString(fileDirectory);
// List<dynamic> jsonResult = jsonDecode(jsonString)["DATA"];

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  Map<String, dynamic> result = dataList[0];
  sheetObject.appendRow(result.keys.toList());

  for (int i = 0; i < dataList.length; i++) {
    Map<String, dynamic> result = dataList[i];
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

Future<String> csvToExcel(String fileName, List<List> csvData) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  for (int i = 0; i < csvData.length; i++) {
    sheetObject.appendRow(csvData[i]);
  }

  final PathProviderWindows provider = PathProviderWindows();
  var downloadsDirectory = await provider.getDownloadsPath();
  String outputDirPath = '$downloadsDirectory/gta_i18n_${dateNowFormat()}';

  final onValue = excel.encode();
  File(("$outputDirPath/$fileName.xlsx"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(onValue!);
  print(sheetObject);
  return "$outputDirPath"; // 文件夹目录
}