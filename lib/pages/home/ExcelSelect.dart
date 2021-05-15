import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:i18n_tools/RunConfig.dart';
import 'package:i18n_tools/util/map_to_multiple_files.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/common_func.dart';
import '../../util/dir_file_tools.dart';
import '../../util/excel_list_2_map.dart';

class ExcelSelect extends StatefulWidget {
  @override
  _ExcelSelectState createState() => _ExcelSelectState();
}

class _ExcelSelectState extends State<ExcelSelect> {
  Map<String, Map> _resMap = {};
  TextEditingController _controller = new TextEditingController(text: '');
  String? groupValue = '.json';

  String _completeText = '';
  File? _selectFile;
  Future<void> _openFileSelector() async {
    XFile? result = await openFile(
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示的目录
      acceptedTypeGroups: <XTypeGroup>[
        new XTypeGroup(label: 'excel', extensions: ['xlsx'])
      ], //允许文件扩展名
      confirmButtonText: "确定", //面板按钮文本更改
    ); //
    // 如果成功，则选择文件作为成功时的处理
    CancelFunc cancel = BotToast.showLoading();
    if (result != null) {
      Map<String, Map> resMap;
      ExcelList2Map excelList2Map = ExcelList2Map();
      resMap = excelList2Map.excelList2Map(result.path);

      setState(() {
        // _selectFile = xlsx;
        _controller.value = TextEditingValue(text: result.path);
        // _excelTables = excel.tables;
        // _repeatKeysValues = resMsgList;
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

  Future<void> _saveFileSelector() async {
    CommonFunc.showToast('暂时不支持');
    // String? result = await getSavePath(
    //   suggestedName: "新的文件.png", //打开面板时要保存的文件名
    //   initialDirectory: "/Users/mirock/Desktop", //打开面板时显示目录
    //   // allowedFileTypes: ["png"], //允许文件扩展名
    //   // confirmButtonText: "保存!",  //面板按钮文本更改
    // );
    // if (result != null && _selectFile != null) {
    //   _selectFile?.copy(result);
    // } else {
    //   setState(() => _completeText = "总觉得不行");
    // }
  }

  Future<void> _output() async {
    String downloadsDirectory = RunConfig.outputDirectoryPath;
    if (_controller.text == '') return CommonFunc.showToast('请选择excel');
    String outputDirPath = '$downloadsDirectory/gta_i18n_${formattedDate()}';
    CancelFunc cancel = BotToast.showLoading();
    mapToMultipleFiles(_resMap, outputDirPath, groupValue);
    cancel();
    openFileDirectory(outputDirPath);
  }

  _onChanged(String? v) {
    setState(() {
      groupValue = v;
    });
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
        SizedBox(height: 20.0),
        paramsCon(),
        SizedBox(height: 20.0),
        outputCon(),
      ],
    );
  }

  Widget pathCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildTextField('多语言excel位置', _controller),
          SizedBox(width: 10.0),
          Container(
            width: 80.0,
            height: 22.0,
            child: OutlineButton(
              borderSide: BorderSide(color: Color(0xFFcccedb)),
              padding: EdgeInsets.all(0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: _openFileSelector,
              child: Text('浏览(B)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget paramsCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('输出文件名、格式：'),
          Radio<String>(
            value: '.json',
            groupValue: groupValue,
            onChanged: _onChanged,
          ),
          Text('.json'),
          SizedBox(width: 20.0),
          Radio<String>(
            value: '.arb',
            groupValue: groupValue,
            onChanged: _onChanged,
          ),
          Text('.arb'),
        ],
      ),
    );
  }

  Widget outputCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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
              onPressed: _output,
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
              onPressed: _saveFileSelector,
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
