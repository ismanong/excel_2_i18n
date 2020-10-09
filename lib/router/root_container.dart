import 'package:flutter/material.dart';

import '../pages/app.dart';

class RootContainer extends StatefulWidget {
  RootContainer({Key key}) : super(key: key);
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootContainer> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('初始化 root page');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.toString());
    if (AppLifecycleState.resumed == state) {
      print('恢复 => App 前台');
    }
    if (AppLifecycleState.paused == state) {
      print('暂停 => App 后台');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在didChangeDependencies中，可以跨组件拿到数据。
    print('root page => didChangeDependencies');
  }

  @override
  void didUpdateWidget(RootContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    //当组件的状态改变的时候就会调用didUpdateWidget,比如调用了setState.
    //实际上这里flutter框架会创建一个新的Widget,绑定本State，并在这个函数中传递老的Widget。
    //这个函数一般用于比较新、老Widget，看看哪些属性改变了，并对State做一些调整。
    //需要注意的是，涉及到controller的变更，需要在这个函数中移除老的controller的监听，并创建新controller的监听。
    print('root page => didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    //在dispose之前，会调用这个函数。
    print('root page => deactivate');
  }

  @override
  void dispose() {
    print('root page => dispose');
    WidgetsBinding.instance.removeObserver(this);
    // 一旦到这个阶段，组件就要被销毁了，这个函数一般会移除监听，清理环境。
    super.dispose();
  }

  int last = 0;
  Future<bool> _doubleClickBack() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - last > 800) {
      last = DateTime.now().millisecondsSinceEpoch;
      print('不退出');
      return Future.value(false); //表示不退出
    } else {
      print('退出');
      return Future.value(true); //表示退出
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('您好！'),
            content: new Text('确定退出 赚赚熊 吗?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('暂不'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('确定'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    Widget _page = MyApp();

    return WillPopScope(
      //监听左上角返回和实体返回
      onWillPop: () => _doubleClickBack(),
      child: _page,
    );
  }
}
