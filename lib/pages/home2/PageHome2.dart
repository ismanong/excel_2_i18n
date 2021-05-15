import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i18n_tools/RunConfig.dart';
import 'package:i18n_tools/pages/home/JsonSelect.dart';
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

  List<List> untranslated = []; //未翻译
  List<List> translated = []; //已翻译
  List<List> mergeTranslation = []; //已翻译
  _output() async {
    untranslated = codeKey.currentState!.csv;
    translated = codeKey2.currentState!.csv;

    for (List item in untranslated) {
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
    print(untranslated);
    String filePath = await csvToExcel('转换', untranslated);
    // String dirPath = File(filePath).parent.path;
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          Row(
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
          SizedBox(height: 20.0),
          _buildRowButtons(),
        ],
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
            onPressed: _output,
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
