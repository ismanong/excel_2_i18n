import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CodeText.dart';
import 'read_file_to_map.dart';

class CodeSelect2 extends StatefulWidget {
  CodeSelect2(Key key) : super(key: key);
  @override
  CodeSelect2State createState() => CodeSelect2State();
}

class CodeSelect2State extends State<CodeSelect2> {
  TextEditingController _controller = new TextEditingController(text: '');
  dynamic _dataMap = {};

  List<List> _csv = [];
  List<List> get csv => _csv;

  List<List> _rows = [];
  Future<void> _openFileSelector() async {
    XFile? result = await openFile(
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示的目录
      acceptedTypeGroups: <XTypeGroup>[
        new XTypeGroup(label: 'excel', extensions: ['xlsx'])
      ], //允许文件扩展名
      confirmButtonText: "确定", //面板按钮文本更改
    ); //
    // 如果成功，则选择文件作为成功时的处理
    CancelFunc cancel =
        BotToast.showLoading(backButtonBehavior: BackButtonBehavior.none);
    if (result != null) {
      Map<String, Map> resMap;
      var excelBytes = File(result.path).readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(excelBytes);
      Map<String, SpreadsheetTable> tables = decoder.tables;
      SpreadsheetTable sheetItem = tables[tables.keys.first]!;
      List<List> rows = sheetItem.rows;
      _csv = rows;
      setState(() {
        _rows = rows;
        _dataMap = rows;
        _controller.value = TextEditingValue(text: result.path);
      });
    }
    cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pathCon(),
        SizedBox(
          height: 500,
          child: _buildDataTable(),
        ),
      ],
    );
  }

  Widget pathCon() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTextField('打开翻译的Excel', _controller),
              SizedBox(width: 10.0),
              Container(
                width: 80.0,
                height: 22.0,
                child: OutlinedButton(
                  onPressed: _openFileSelector,
                  child: Text('浏览(B)'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    side: BorderSide(color: Color(0xFFcccedb)),
                    primary: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget buildTextField(String title, TextEditingController ctl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(title),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFcccedb),
              style: BorderStyle.solid,
            ),
          ),
          // constraints: BoxConstraints(
          //   maxHeight: 22.0,
          // ),
          width: 500,
          margin: EdgeInsets.only(top: 10.0),
          child: TextField(
            controller: ctl,
            decoration: InputDecoration(
              hintText: '',
              isDense: true, // 使用较少的垂直空间
              contentPadding: EdgeInsets.all(5),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              border: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.text, //键盘类型
            textInputAction: TextInputAction.search, //为next时，enter键显示的文字内容为 下一步
            textCapitalization: TextCapitalization.words, //none 默认使用小写
            style: TextStyle(fontSize: 14.0, color: Colors.black54), //输入文本的样式
            // autofocus: true, //是否自动获得焦点
            onChanged: (text) {
              // _text = text;
            },
            onSubmitted: (text) {
              // _submit();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    if (_rows.isEmpty) {
      return Container();
    }
    List<List> rowsCopy = new List.from(_rows);
    List<dynamic> rowHead = rowsCopy.removeAt(0); //删除数组,返回删除项,获取标题
    List<List> rowBody = rowsCopy; // 获取内容

    List<DataColumn> columns = rowHead.map((dynamic e) {
      return DataColumn(
        label: Container(
          width: 40.0,
          child: Text('$e'),
        ),
      );
    }).toList();

    List<DataRow> rows = rowBody.map((List e) {
      List<DataCell> cells = e.map((text) {
        return DataCell(Container(
          width: 40.0,
          child: Text('$text'),
        ));
      }).toList();
      return DataRow(
        cells: cells,
      );
    }).toList();

    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 0.0,
        dataRowHeight: 20.0,
        columns: columns,
        rows: rows,
      ),
    );
  }
}
