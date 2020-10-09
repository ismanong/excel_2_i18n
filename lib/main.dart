import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'router/navigator_utils.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Flutter去除右上角Debug标签
      title: 'test_100', //app多任务标签页的title 任务管理器中应用程序标题
      builder: BotToastInit(), //BotToastInit移动到此处
      navigatorObservers: [
        BotToastNavigatorObserver(),
        NavigatorUtils.getInstance(),
      ],
      routes: NavigatorUtils.configRoutes,
      initialRoute: '/',
    );
  }
}