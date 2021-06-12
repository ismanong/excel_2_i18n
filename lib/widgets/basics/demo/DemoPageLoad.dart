import 'package:flutter/material.dart';
import 'package:gtarcade/global/Global.dart';
import 'package:gtarcade/widget/modules/basicsFirstScreenBuilder.dart';

class DemoPageLoad extends StatefulWidget {
  final int tab;
  DemoPageLoad({Key key, this.tab}) : super(key: key);

  @override
  _DemoPageLoadState createState() => _DemoPageLoadState();
}

class _DemoPageLoadState extends State<DemoPageLoad> {
  BasicsFirstScreenBuilderController _firstScreenBuilderController =
      BasicsFirstScreenBuilderController();
  void _calculation() async {
    if (_state == 0) {
      await new Future.delayed(new Duration(seconds: 6));
    } else if (_state == 1) {
      Global.isHaveNetwork = true;
      throw 'demo test';
    } else if (_state == 2) {
      Global.isHaveNetwork = false;
      throw 'demo test';
    }
  }

  int _state = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          'dome 页面加载状态',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _body(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _state = 0;
              _firstScreenBuilderController.reload();
            },
            child: Text('加载中(6秒)'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _state = 1;
              _firstScreenBuilderController.reload();
            },
            child: Text('加载失败'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _state = 2;
              _firstScreenBuilderController.reload();
            },
            child: Text('网络异常'),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return BasicsFirstScreenBuilder(
      calculation: _calculation,
      content: _content,
      controller: _firstScreenBuilderController,
    );
  }

  Widget _content() {
    return Center(
      child: Text(
        '视图渲染完成',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
