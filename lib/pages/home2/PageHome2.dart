import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i18n_tools/RunConfig.dart';
import 'package:i18n_tools/pages/home/JsonSelect.dart';
import 'package:i18n_tools/util/convert_excel.dart';
import 'package:i18n_tools/util/dir_file_tools.dart';
import 'package:i18n_tools/util/xxx.dart';

import 'CodeSelect.dart';
import 'CodeSelect2.dart';
import 'CodeText.dart';

class PageHome2 extends StatefulWidget {
  @override
  _PageHome2State createState() => _PageHome2State();
}

class _PageHome2State extends State<PageHome2> {
  GlobalKey<CodeSelectState> codeKey = GlobalKey();
  GlobalKey<CodeSelect2State> codeKey2 = GlobalKey();

  List<List> allTranslated = []; //全部翻译
  List<List> untranslated = []; //未翻译
  List<List> translated = []; //已翻译
  List<List> mergeTranslation = []; //已翻译
  _output() async {
    untranslated = codeKey.currentState!.csv;
    String filePath = await csvToExcel('待翻译', untranslated);
    openFileDirectory(filePath);
  }

  _outputAll() async {
    allTranslated = codeKey.currentState!.csvAll;
    String filePath = await csvToExcel('All翻译', allTranslated);
    openFileDirectory(filePath);
  }

  _convert() async {
    allTranslated = codeKey.currentState!.csvAll;
    translated = codeKey2.currentState!.csv;
    for (List item in allTranslated) {
      String cn = item[1]; //获取中文
      for (List target in translated) {
        String targetCN = target[1]; //获取中文
        if (cn == targetCN) {
          for (var i = 1; i < item.length; i++) {
            item[i] = target[i];
          }
        }
      }
    }
    String filePath = await csvToExcel('合并翻译', allTranslated);
    openFileDirectory(filePath);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('输出目录: ${RunConfig.outputDirectoryPath}'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CodeSelect(codeKey),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: CodeSelect2(codeKey2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            _buildRowButtons(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRowButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80.0,
          height: 22.0,
          child: ElevatedButton(
            onPressed: _outputAll,
            child: Text('下载全部'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              //字体颜色
              foregroundColor: MaterialStateProperty.all(Colors.white),
              //高亮色，按钮处于focused, hovered, or pressed时的颜色
              overlayColor: MaterialStateProperty.all(Colors.blueAccent),
              //阴影颜色
              shadowColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ),
        SizedBox(width: 20.0),
        SizedBox(
          width: 80.0,
          height: 22.0,
          child: ElevatedButton(
            onPressed: _output,
            child: Text('下载未翻'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              //字体颜色
              foregroundColor: MaterialStateProperty.all(Colors.white),
              //高亮色，按钮处于focused, hovered, or pressed时的颜色
              overlayColor: MaterialStateProperty.all(Colors.blueAccent),
              //阴影颜色
              shadowColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ),
        SizedBox(width: 20.0),
        SizedBox(
          width: 80.0,
          height: 22.0,
          child: ElevatedButton(
            onPressed: _convert,
            child: Text('转换'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              //字体颜色
              foregroundColor: MaterialStateProperty.all(Colors.black),
              //高亮色，按钮处于focused, hovered, or pressed时的颜色
              overlayColor: MaterialStateProperty.all(Color(0xFFc9def5)),
              //阴影颜色
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              //边框
              side: MaterialStateProperty.all(
                BorderSide(width: 1, color: Color(0xFF3399ff)),
              ),
              //圆角弧度
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
