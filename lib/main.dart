import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:i18n_tools/pages/app.dart';
import 'dart:math' as math;
import 'package:window_size/window_size.dart' as window_size;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.getWindowInfo().then((window) {
    final screen = window.screen;
    if (screen != null) {
      final screenFrame = screen.visibleFrame;
      final width = math.max((screenFrame.width / 2).roundToDouble(), 1600.0);
      final height = math.max((screenFrame.height / 2).roundToDouble(), 900.0);
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);
      window_size.setWindowFrame(frame);
      window_size.setWindowMinSize(Size(0.8 * width, 0.8 * height));
      window_size.setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      window_size
          .setWindowTitle('Flutter Testbed on ${Platform.operatingSystem}');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Flutter去除右上角Debug标签
      title: 'test_100', //app多任务标签页的title 任务管理器中应用程序标题
      builder: BotToastInit(), // 初始化 bot_toast
      navigatorObservers: [
        BotToastNavigatorObserver(),  // 初始化 bot_toast
        // NavigatorUtils.getInstance(),
      ],
      // routes: NavigatorUtils.configRoutes,
      // initialRoute: '/',
      home: PageHome(),
    );
  }
}