// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String _downloadsDirectory = 'Unknown';
  String _appSupportDirectory = 'Unknown';
  String _excelFilePath = 'Unknown';
  Map<String, Sheet> _excelTables = {};

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sure2Json() {
    excelList2Map(_excelTables, _downloadsDirectory);
    _launchURL('file:///$_downloadsDirectory/web_i18n');
  }

  String _completeText = '';
  File _selectFile;
  Future<void> _openPanel() async {
    var result = await showOpenPanel(
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示的目录
      allowsMultipleSelection: true, //允许选择多个文件或
      allowedFileTypes: [new FileTypeFilterGroup(label: 'excel',fileExtensions: ['xlsx'])], //允许文件扩展名
      confirmButtonText: "确定", //面板按钮文本更改
    ); //
    // 如果成功，则选择文件作为成功时的处理
    if (!result.canceled) {
      File xlsx = File(result.paths[0]);
      _selectFile = xlsx;
      print(xlsx.path);
    }
  }


  Future<void> _savePanel() async {
    var result = await showSavePanel(
      suggestedFileName: "新的文件.png", //打开面板时要保存的文件名
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示目录
      // allowedFileTypes: ["png"], //允许文件扩展名
      // confirmButtonText: "保存!",  //面板按钮文本更改
    );
    if (!result.canceled && _selectFile != null) {
      _selectFile.copy(result.paths[0]);
    } else {
      setState(() => _completeText = "总觉得不行");
    }
  }


  @override
  void initState() {
    super.initState();
    initDirectories();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectories() async {
    String downloadsDirectory;
    String appSupportDirectory;
    final PathProviderWindows provider = PathProviderWindows();

    try {
      downloadsDirectory = await provider.getDownloadsPath();
    } catch (exception) {
      downloadsDirectory = '无法获取下载目录: $exception';
    }
    try {
      appSupportDirectory = await provider.getApplicationSupportPath();
    } catch (exception) {
      appSupportDirectory = '无法获取应用支持目录: $exception';
    }
    setState(() {
      _downloadsDirectory = downloadsDirectory;
      _appSupportDirectory = appSupportDirectory;
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

    String filePath =
        "D:/_work/client-web-tools/i18n-excel-to-json/i18n_web.xlsx";
    File file = File(filePath);
    if (file.existsSync()) {
      setState(() {
        _excelFilePath = filePath;
      });
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      setState(() {
        _excelTables = excel.tables;
      });
      // for (var table in excel.tables.keys) {
      //   print('sheet name: '+ table); //sheet Name
      //   print('maxCols   : '+ excel.tables[table].maxCols.toString());
      //   print('maxRows   : '+ excel.tables[table].maxRows.toString());
      //   for (var row in excel.tables[table].rows) {
      //     print("$row");
      //   }
      // }
    } else {
      setState(() {
        _excelFilePath = '无文件';
      });
    }
  }

  Widget excelListItem(List<List<dynamic>> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(rows.length, (index) {
        return Text('${rows[index][0]},${rows[index][1]}');
      }),
    );
  }

  Widget excelListContent() {
    List<Widget> list = [];
    _excelTables.keys.forEach((String sheetName) {
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
          title: const Text('demo'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('下载目录: $_downloadsDirectory\n'),
                    Text('应用目录: $_appSupportDirectory\n'),
                    Row(
                      children: [
                        Text('多语言excel路径: $_excelFilePath\n'),
                        RaisedButton(onPressed: _openPanel, child: Text('位置')),
                      ],
                    ),

                  ],
                ),
                RaisedButton(onPressed: sure2Json, child: Text('点击转换')),
                FlatButton(
                  color: Colors.blueGrey,
                  child: Text(
                    "保存",
                  ),
                  onPressed: () async => _savePanel(),
                ),
                Text(
                  _completeText ?? "",
                ),
              ],
            ),
            Expanded(
              child: excelListContent(),
            ),
          ],
        ),
      ),
    );
  }
}
