import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gtarcade/constants/iconfont.dart';
import 'package:gtarcade/constants/ImagePaths.dart';
import 'package:gtarcade/global/Global.dart';

import '../MyLoadingIndicator.dart';

class BasicsFirstScreenBuilderController {
  Function reload;
}

class BasicsFirstScreenBuilder extends StatefulWidget {
  final Function calculation;
  final Function content;
  final BuildContext context;
  final model;
  final BasicsFirstScreenBuilderController controller;

  BasicsFirstScreenBuilder(
      {Key key,
      @required this.calculation,
      @required this.content,
      this.context,
      this.model,
      this.controller})
      : super(key: key);

  @override
  _LifeDemoState createState() => new _LifeDemoState();
}

class _LifeDemoState extends State<BasicsFirstScreenBuilder> {
  Future<bool> _calculation;

  Future<bool> _req() async {
    await widget.calculation();
    // await new Future.delayed(new Duration(seconds: 6));
    return Future.value(true); // 触发 snapshot.hasData
    // throw '1'; // 触发 snapshot.hasError
    // return Future.value(null); // 会一直处于等待状态
  }

  /*
  * 初始化加载 和 重新加载
  * */
  _onRefresh() {
    setState(() {
      _calculation = _req();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.reload = _onRefresh;
    }
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _calculation,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        /// snapshot.hasData snapshot.hasError 会有上一次的缓存，导致刷新失败，
        /// 需要 snapshot.connectionState = ConnectionState.waiting 配合
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (widget.model == null) {
            return widget.content();
          } else {
            return widget.content(widget.context, widget.model);
          }
        } else if (snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          // if (Global.isHaveNetwork) {
          //   return _loadingError(_onRefresh);
          // } else {
          //   return _networkError(_onRefresh);
          // }
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Icon(
              IconFont.page_error,
              color: Colors.grey.shade300,
              size: 100,
            ),
          );
        } else {
          // return _loading();
          return MyLoadingIndicator();
        }
        // switch (snapshot.connectionState) {
        //   case ConnectionState.none:
        //     return Text('Press button to start.');
        //   case ConnectionState.active:
        //   case ConnectionState.waiting:
        //     return Text('waiting...');
        //   case ConnectionState.done:
        //     if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     }
        //     return Text('Result: ${snapshot.data}');
        // }
      },
    );
  }

  Widget _loading() {
    /// 没有Scaffold()手脚架作为父类的时候，默认背景是黑色，默认字体样式是黄色下划线
    /// 所以用Container(color: Colors.white) decoration: TextDecoration.none,
    /// 把默认清楚掉
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(10.0),
            child: Image.asset(
              ImagePaths.logo_page_loading,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '正在努力加载...',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingError(Function func) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text('Error: ${snapshot.error}'),
            SizedBox(height: 20.0),
            Icon(IconFont.page_error, size: 100.0, color: Colors.grey),
            SizedBox(height: 20.0),
            Text(
              '加载失败，请点击重试',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 20.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  child: Text('重试', style: TextStyle(color: Colors.grey)),
                  onPressed: () => func(),
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _networkError(Function func) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Text('Error: ${snapshot.error}'),
            SizedBox(height: 20.0),
            Platform.isIOS
                ? Container()
                : Icon(IconFont.wifi_exclamation,
                    size: 100.0, color: Colors.grey),
            SizedBox(height: 20.0),
            Text(
              '网络链接失败，请检查您的网络',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20.0),
            Platform.isIOS ? NetworkComWgt() : Container(),
            SizedBox(height: 20.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
//              FlatButton(
////                shape: new RoundedRectangleBorder(
////                  borderRadius: new BorderRadius.circular(30.0),
////                  side: BorderSide(width: 1.0, color: Colors.grey),
////                ),
////                child: Text(
////                  '查询解决方案',
////                  style: TextStyle(color: Colors.grey),
////                ),
////                onPressed: () => func(),
////              ),
//              SizedBox(width: 30.0),
                FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  child: Text('重试', style: TextStyle(color: Colors.grey)),
                  onPressed: () => func(),
                ),
              ],
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

class NetworkComWgt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text('''
解决方案:
1.检查网络权限是否打开
i〇S10以上系统，需要开启APP使用网络权限。
如果您第一次打开赚赚熊APP弹出下面对话框
(允许“xxx”使用数据？)，请点击 “允许”。

如果您未遇到上述对话框，或已经选择了不允许。
解决办法：打开【设置】-【蜂窝移动网络】-【使用无 
线局域网与蜂窝移动的应用】，找到【xxx】，勾选 
【无线局域网与蜂窝移动数据】即可。
如果在【使用无线局域网与蜂窝移动的应用】中，未找 
到【xxx】，请重启手机再次尝试。
如果您的手机不是中国版，则：打开【设置】-【蜂窝移 
动网络】，找到【xxx】，启用幵关即可。

2.检查本地网络状况
请检查您本地的无线网络或手机信号情况，信号差的时 
候也无法正常获取数据。

          ''', style: TextStyle(color: Colors.grey)),
    );
  }
}
