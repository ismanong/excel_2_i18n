import 'dart:io';
import 'package:flutter/services.dart';

/*
* dart 获取目录下的所有文件及子目录
* printFiles("D:/"); // 查询时间长
* printFiles("D:/web");
* */
void printFiles(String path){
  try{
    var  directory  =   new Directory(path);
    List<FileSystemEntity> files = directory.listSync();
    for(var f in files){
      print(f.path);
      var bool = FileSystemEntity.isFileSync(f.path);
      if(!bool){
        printFiles(f.path); // 递归
      }
    }
  }catch(e){
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
