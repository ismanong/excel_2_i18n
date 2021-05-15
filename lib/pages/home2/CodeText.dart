import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:i18n_tools/widgets/tree_view.dart';

class CodeText extends StatefulWidget {
  final dynamic data;
  CodeText({Key? key, required this.data}) : super(key: key);

  @override
  _CodeTextState createState() => _CodeTextState();
}

class _CodeTextState extends State<CodeText> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: prvJsonDemo(),
    );
  }

  Widget prvJsonDemo() {
    String prettyJsonStr = '什么也没有哦';
    if (widget.data is Map) {
      prettyJsonStr = new JsonEncoder.withIndent('    ').convert(widget.data);
    } else if (widget.data is List) {
      prettyJsonStr = new JsonEncoder.withIndent('    ').convert(widget.data);
    }
    return Container(
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Text('$prettyJsonStr'),
        ),
      ),
    );
  }
}
