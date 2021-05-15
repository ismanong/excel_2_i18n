import 'package:flutter/material.dart';
import 'package:i18n_tools/RunConfig.dart';
import 'ExcelSelect.dart';
import 'JsonSelect.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  TextEditingController _controller = new TextEditingController(text: '');
  int? groupValue = 1;

  @override
  void initState() {
    super.initState();
    _controller.value = TextEditingValue(text: RunConfig.outputDirectoryPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('应用目录: ${RunConfig.appSupportDirectory}'),
      ),
      body: Column(
        children: [
          pathCon(),
          SizedBox(height: 20.0),
          Divider(color: Colors.red),
          ExcelSelect(),
          SizedBox(height: 20.0),
          Divider(color: Colors.red),
          JsonSelect(),
          // Expanded(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //               color: Colors.blueAccent,
          //               style: BorderStyle.solid,
          //             ),
          //           ),
          //           child: excelListContent(),
          //         ),
          //       ),
          //       Icon(Icons.arrow_forward),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //               color: Colors.blueAccent,
          //               style: BorderStyle.solid,
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               Container(
          //                 decoration: BoxDecoration(
          //                   border: Border.all(
          //                     color: Colors.blueAccent,
          //                     style: BorderStyle.solid,
          //                   ),
          //                 ),
          //                 width: 200,
          //                 child: prvDemo2(),
          //               ),
          //               Expanded(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     border: Border.all(
          //                       color: Colors.redAccent,
          //                       style: BorderStyle.solid,
          //                     ),
          //                   ),
          //                   child: prvJsonDemo(),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget pathCon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildTextField('输出目录', _controller),
            ],
          ),
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
            color: Colors.grey.shade100,
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
            enableInteractiveSelection: false,
            enabled: false,
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
