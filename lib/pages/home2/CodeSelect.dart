import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'CodeText.dart';
import 'CsvDataTable.dart';
import '../../util/multiple_files_to_map.dart';

class CodeSelect extends StatefulWidget {
  CodeSelect(Key key) : super(key: key);
  @override
  CodeSelectState createState() => CodeSelectState();
}

class CodeSelectState extends State<CodeSelect> {
  TextEditingController _controller = new TextEditingController(text: '');
  List<List> _data = [];

  Future<void> _openFileSelector() async {
    String? result = await getDirectoryPath(
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示的目录
      confirmButtonText: "确定", //面板按钮文本更改
    ); //
    // 如果成功，则选择文件作为成功时的处理
    CancelFunc cancel = BotToast.showLoading();
    if (result != null) {
      List<Map<String, dynamic>> dataListMap = await multipleFilesToMap(result);
      Map<String, dynamic> head = dataListMap[0];
      List headList = head.keys.toList();
      csv.add(headList);
      _csvAll.add(headList);
      for (int i = 0; i < dataListMap.length; i++) {
        Map<String, dynamic> item = dataListMap[i];
        if (item.values.contains('')) {
          _csv.add(item.values.toList());
        }
        _csvAll.add(item.values.toList());
      }
      setState(() {
        _data = _csv;
        _controller.value = TextEditingValue(text: result);
      });
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

  List<List> _csv = [];
  List<List> get csv => _csv;

  List<List> _csvAll = [];
  List<List> get csvAll => _csvAll;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pathCon(),
        Expanded(
          // child: CodeText(data: _data),
          child: CsvDataTable(csv: _csv),
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
              Expanded(
                child: buildTextField('多语言JSON、arb文件夹位置', _controller),
              ),
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
