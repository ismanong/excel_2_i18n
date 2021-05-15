import 'dart:io';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/*
* dart 获取目录下的所有文件及子目录
* printFiles("D:/"); // 查询时间长
* printFiles("D:/web");
* */
void printFiles(String path) {
  try {
    var directory = new Directory(path);
    List<FileSystemEntity> files = directory.listSync();
    for (var f in files) {
      print(f.path);
      var bool = FileSystemEntity.isFileSync(f.path);
      if (!bool) {
        printFiles(f.path); // 递归
      }
    }
  } catch (e) {
    print("目录不存在！");
  }
}

writeFile(String saveFilePath, List<int> data) async {
  File saveFile = File(saveFilePath); // 需要保存的文件
  if (!saveFile.existsSync()) {
    saveFile.createSync(recursive: true);
    saveFile.writeAsBytesSync(data, flush: true);
  }
  // test---------------------------------
  int size = await saveFile.length();
  String sizeMb = '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
  print('文件大小：$sizeMb  文件路径：${saveFile.path}');
  // test---------------------------------end
  return saveFile.path;
}

String formattedDate() {
  DateTime dateTime = DateTime.now();
  String dateTimeString = '' +
      '${dateTime.year}-' +
      '${dateTime.month}-' +
      '${dateTime.day}_' +
      '${dateTime.hour}-' +
      '${dateTime.minute}-' +
      '${dateTime.second}_' +
      '${dateTime.millisecond}';
  return dateTimeString;
}

dateFormatTimestamp(int timestamp,
    {bySecond: false, format: 'yyyy-MM-dd HH:mm:ss'}) {
  // 默认接收毫秒时间戳 如果服务按秒返回 则设置bySecond:true
  if (bySecond) {
    timestamp = timestamp * 1000;
  }
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat(format).format(dateTime);
}

dateNowFormat() {
  return DateFormat('yyyy-MM-dd HH-mm-ss').format(DateTime.now());
}

openFileDirectory(String dirPath) async {
  String url = 'file:///$dirPath';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'openFileDirectory失败 $url';
  }
}

// var myDir = new Directory('D:/_work/svn资源/client/前端技术/语料包');
// var myDir = new Directory('D:/');
// var myDir = new Directory('D:/_work/client-web-tools/i18n-excel-to-json');
// print("Path: ${myDir.absolute.path}\n");
// Stream<FileSystemEntity> entityList =
//     myDir.list(recursive: false, followLinks: false);
// await for (FileSystemEntity entity in entityList) {
//   //文件、目录和链接都继承自FileSystemEntity
//   //FileSystemEntity.type静态函数返回值为FileSystemEntityType
//   //FileSystemEntityType有三个常量：
//   //Directory、FILE、LINK、NOT_FOUND
//   //FileSystemEntity.isFile .isLink .isDerectory可用于判断类型
//   print(entity.path);
// }

// String filePath =
//     "D:/_work/client-web-tools/i18n-excel-to-json/i18n_web.xlsx";
// File file = File(filePath);
// if (file.existsSync()) {
// var bytes = file.readAsBytesSync();
// var excel = Excel.decodeBytes(bytes);
// setState(() {
// _excelTables = excel.tables;
// });
// }
