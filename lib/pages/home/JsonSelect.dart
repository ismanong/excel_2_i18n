import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:i18n_tools/util/convert_excel.dart';
import 'package:i18n_tools/util/dir_file_tools.dart';
import 'package:i18n_tools/util/xxx.dart';
import 'package:i18n_tools/util/multiple_files_to_map.dart';
import 'package:url_launcher/url_launcher.dart';

class JsonSelect extends StatefulWidget {
  @override
  _JsonSelectState createState() => _JsonSelectState();
}

class _JsonSelectState extends State<JsonSelect> {
  TextEditingController _controller = new TextEditingController(text: '');

  Future<void> _openFileSelector() async {
    String? result = await getDirectoryPath(
      initialDirectory: "/Users/mirock/Desktop", //打开面板时显示的目录
      confirmButtonText: "确定", //面板按钮文本更改
    ); //
    // 如果成功，则选择文件作为成功时的处理
    CancelFunc cancel = BotToast.showLoading();
    if (result != null) {
      List<Map<String, dynamic>> dataListMap = await multipleFilesToMap(result);
      String outputDirPath = await mapToExcel('多语言', dataListMap);
      openFileDirectory(outputDirPath);
      setState(() {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pathCon(),
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
              buildTextField('多语言JSON、arb文件夹位置', _controller),
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
}
