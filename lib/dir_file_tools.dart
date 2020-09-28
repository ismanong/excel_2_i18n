import 'dart:io';

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