import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'file:///D:/_github/excel_2_i18n/lib/widgets/tree_view.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:excel/excel.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'c++.dart';
import '../common/common_func.dart';
import '../util/dir_file_tools.dart';
import '../util/excel_list_2_map.dart';
import 'msg_dialog_repeat.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  String _downloadsDirectory = 'Unknown';
  String _appSupportDirectory = 'Unknown';
  Map<String, Sheet> _excelTables = {};
  Map _resMap = {};
  TextEditingController _controller = new TextEditingController(text: '');
  TextEditingController _controller2 = new TextEditingController(text: '');
  int? groupValue = 1;
  List _repeatKeysValues = [];

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  sure2Json() {
    if (_controller2.text == '') return CommonFunc.showToast('请选择excel');
    String outputDirPath = '$_downloadsDirectory/gta_i18n_${formattedDate()}';
    CancelFunc cancel =
        BotToast.showLoading(backButtonBehavior: BackButtonBehavior.none);
    if (groupValue == 1) {
      ExcelList2Map().excelList2MapOutputFile(_resMap, outputDirPath);
    } else {
      CppI18n().excelList2MapOutputFile(_resMap, outputDirPath);
    }
    cancel();
    _launchURL('file:///$outputDirPath');
  }

  String _completeText = '';
  File? _selectFile;
  Future<void> _openPanel() async {
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

      var excelBytes = File(result.path).readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(excelBytes);
      SpreadsheetTable? table = decoder.tables['Sheet1'];
      var values = table?.rows[0];





      File xlsx = File(result.path);
      var bytes = xlsx.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      Map resMap;
      List resMsgList;
      if (groupValue == 1) {
        ExcelList2Map excelList2Map = ExcelList2Map();
        resMap = excelList2Map.excelList2Map(excel.tables);
        resMsgList = excelList2Map.repeatKeysValues;
      } else {
        CppI18n excelList2Map = CppI18n();
        resMap = excelList2Map.excelList2Map(
          excel.tables,
          isPassRepeatKey: true,
          langKey: 'en',
          isMergeSheets: true,
          isSimplifyLangCode: true,
        );
        resMsgList = excelList2Map.repeatKeysValues;
      }
      setState(() {
        _selectFile = xlsx;
        _controller2.value = TextEditingValue(text: xlsx.path);
        _excelTables = excel.tables;
        _repeatKeysValues = resMsgList;
        _resMap = resMap;
      });
      // msgDialogRepeat(context,_repeatKeysValues.toString());
    }
    cancel();

    /// 不能乱捕获 需要手动管理出错的堆栈信息
    // try {
    // } catch (e) {
    //   print(e);
    //   CommonFunc.showToast('转换错误');
    // } finally {
    // }
  }

  Future<void> _savePanel() async {
    String? result = await getSavePath(
      suggestedName: "新的文件.png", //打开面板时要保存的文件名
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示目录
      // allowedFileTypes: ["png"], //允许文件扩展名
      // confirmButtonText: "保存!",  //面板按钮文本更改
    );
    if (result != null && _selectFile != null) {
      _selectFile?.copy(result);
    } else {
      setState(() => _completeText = "总觉得不行");
    }
  }

  Future<void> initDirectories() async {
    String? downloadsDirectory;
    String? appSupportDirectory;
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
      _downloadsDirectory = downloadsDirectory ?? _downloadsDirectory;
      _appSupportDirectory = appSupportDirectory ?? _appSupportDirectory;
    });
    _controller.value = TextEditingValue(text: _downloadsDirectory);
  }

  @override
  void initState() {
    super.initState();
    initDirectories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('应用目录: $_appSupportDirectory'),
      ),
      body: Column(
        children: [
          pathCon(),
          paramsCon(),
          outputCon(),
          SizedBox(height: 20.0),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: excelListContent(),
                  ),
                ),
                Icon(Icons.arrow_forward),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              style: BorderStyle.solid,
                            ),
                          ),
                          width: 200,
                          child: prvDemo2(),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: prvJsonDemo(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget prvDemo() {
    List<dynamic> listKeys = _resMap.keys.toList();
    return TreeView(
      parentList: [
        Parent(
          isExpanded: true,
          parent: Row(
            children: [
              Icon(Icons.folder, color: Colors.orange),
              Text('web_i18n'),
            ],
          ),
          childList: ChildList(
            children: List<Widget>.generate(listKeys.length, (index) {
              String key = listKeys[index];
              Map value = _resMap[key];

              return Container(
                margin: EdgeInsets.only(left: 20.0),
                height: 25.0,
                child: FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      _fileJsonMap = value;
                    });
                  },
                  icon: Icon(Icons.insert_drive_file_outlined,
                      color: Colors.orange),
                  label: Text('$key.json'),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget prvDemo2() {
    List<dynamic> listKeys = _resMap.keys.toList();
    return TreeView(
      parentList: [
        Parent(
          isExpanded: true,
          parent: Row(
            children: [
              Icon(Icons.folder, color: Colors.orange),
              Text('web_i18n'),
            ],
          ),
          childList: ChildList(
            children: List<Widget>.generate(listKeys.length, (index) {
              String key = listKeys[index];
              Map value = _resMap[key];

              return Container(
                margin: EdgeInsets.only(left: 20.0),
                height: 25.0,
                child: FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      _fileJsonMap = value;
                    });
                  },
                  icon: Icon(Icons.insert_drive_file_outlined,
                      color: Colors.orange),
                  label: Text('$key.json'),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Map _fileJsonMap = {};
  Widget prvJsonDemo() {
    String prettyJsonStr =
        new JsonEncoder.withIndent('    ').convert(_fileJsonMap);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Text('$prettyJsonStr'),
      ),
    );
  }

  Widget excelListRowsRow(List<dynamic> row) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(row.length, (index) {
        // return Text('${row[index].toString()}');
        return Container(
          decoration: BoxDecoration(
            color: row[index] == null ? Colors.redAccent : Colors.white,
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
          ),
          width: 30,
          height: 30,
          child: Text('$index'),
        );
      }),
    );
  }

  Widget excelListRows(List<List<dynamic>> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(rows.length, (index) {
        return excelListRowsRow(rows[index]);
      }),
    );
  }

  Widget excelListContent() {
    List<Widget> list = [];
    _excelTables.keys.forEach((String sheetName) {
      Sheet sheet = _excelTables[sheetName]!;
      List<List<dynamic>> rows = sheet.rows;
      list.add(excelListRows(rows));
      // print(excelListItem(rows));
      // list.add(Text('Path Provider example app'));
    });
    return ListView(
      children: list,
    );
  }

  Widget pathCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTextField('下载目录', _controller),
              SizedBox(width: 10.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFcccedb),
                    style: BorderStyle.solid,
                  ),
                ),
                width: 80.0,
                height: 22.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: _openPanel,
                  child: Text('浏览(B)'),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTextField('多语言excel位置', _controller2),
              SizedBox(width: 10.0),
              Container(
                width: 80.0,
                height: 22.0,
                child: OutlineButton(
                  borderSide: BorderSide(color: Color(0xFFcccedb)),
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: _openPanel,
                  child: Text('浏览(B)'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget paramsCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('选择多语言使用场景：'),
          Radio<int>(
            value: 1,
            groupValue: groupValue,
            onChanged: (int? v) {
              setState(() {
                groupValue = v;
              });
            },
          ),
          Text('web'),
          Radio<int>(
            value: 2,
            groupValue: groupValue,
            onChanged: (int? v) {
              setState(() {
                groupValue = v;
              });
            },
          ),
          Text('c++'),
        ],
      ),
    );
  }

  Widget outputCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF3399ff),
                style: BorderStyle.solid,
              ),
            ),
            width: 80.0,
            height: 22.0,
            child: FlatButton(
              hoverColor: Color(0xFFc9def5),
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: sure2Json,
              child: Text('输出'),
            ),
          ),
          SizedBox(width: 10.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFcccedb),
                style: BorderStyle.solid,
              ),
            ),
            width: 80.0,
            height: 22.0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () async => _savePanel(),
              child: Text('另存为'),
            ),
          ),
          Text(_completeText),
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
}
