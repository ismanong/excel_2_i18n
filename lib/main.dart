// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:excel/excel.dart';
import 'dir_file_tools.dart';
import 'excel_list_2_map.dart';

void main() async {
  runApp(MyApp());
}

/// Sample app
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _tempDirectory = 'Unknown';
  String _downloadsDirectory = 'Unknown';
  String _appSupportDirectory = 'Unknown';
  String _documentsDirectory = 'Unknown';
  String _xxxxx = 'Unknown';
  String _isExcelWeb = 'Unknown';
  Map<String, Sheet> _excelTables = {};

  @override
  void initState() {
    super.initState();
    initDirectories();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectories() async {
    String tempDirectory;
    String downloadsDirectory;
    String appSupportDirectory;
    String documentsDirectory;
    final PathProviderWindows provider = PathProviderWindows();

    try {
      tempDirectory = await provider.getTemporaryPath();
    } catch (exception) {
      tempDirectory = '无法获取临时目录: $exception';
    }
    try {
      downloadsDirectory = await provider.getDownloadsPath();
    } catch (exception) {
      downloadsDirectory = '无法获取下载目录: $exception';
    }

    try {
      documentsDirectory = await provider.getApplicationDocumentsPath();
    } catch (exception) {
      documentsDirectory = '无法获取文档目录: $exception';
    }

    try {
      appSupportDirectory = await provider.getApplicationSupportPath();
    } catch (exception) {
      appSupportDirectory = '无法获取应用支持目录: $exception';
    }

    setState(() {
      _tempDirectory = tempDirectory;
      _downloadsDirectory = downloadsDirectory;
      _appSupportDirectory = appSupportDirectory;
      _documentsDirectory = documentsDirectory;
    });

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



    String filePath = "D:/_work/client-web-tools/i18n-excel-to-json/i18n_web.xlsx";
    File file = File(filePath);
    if(file.existsSync()){
      setState(() {
        _isExcelWeb = '有文件';
      });
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      setState(() {
        _excelTables = excel.tables;
      });

      excelList2Map(_excelTables);
      // for (var table in excel.tables.keys) {
      //   print('sheet name: '+ table); //sheet Name
      //   print('maxCols   : '+ excel.tables[table].maxCols.toString());
      //   print('maxRows   : '+ excel.tables[table].maxRows.toString());
      //   for (var row in excel.tables[table].rows) {
      //     print("$row");
      //   }
      // }
    }else{
      setState(() {
        _isExcelWeb = '无文件';
      });
    }
  }

  Widget excelListItem(List<List<dynamic>> rows){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(rows.length, (index){
        return Text('${rows[index][0]},${rows[index][1]}');
      }),
    );
  }

  Widget excelListContent(){
    List<Widget> list = [];
    _excelTables.keys.forEach((String sheetName){
      Sheet sheet = _excelTables[sheetName];
      List<List<dynamic>> rows = sheet.rows;
      list.add(excelListItem(rows));
      // print(excelListItem(rows));
      // list.add(Text('Path Provider example app'));
    });
    return ListView(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Path Provider example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('临时目录: $_tempDirectory\n'),
              Text('文件目录: $_documentsDirectory\n'),
              Text('下载目录: $_downloadsDirectory\n'),
              Text('应用程序支持目录: $_appSupportDirectory\n'),
              Text('xxxx: $_xxxxx\n'),
              Text('是否有多语言excel: $_isExcelWeb\n'),
              Expanded(
                child: excelListContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}