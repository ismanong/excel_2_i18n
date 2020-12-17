import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:sentry/sentry.dart';
import 'router/navigator_utils.dart';
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

  // runApp(MyApp());
  final sentry = SentryClient(dsn: "https://db288df248db418e8ab79104141c1f8c@o320342.ingest.sentry.io/5459002");
  //在一个区域中运行整个应用程序以捕获所有未捕获的错误。
  runZonedGuarded(
        () => runApp(MyApp()),
        (error, stackTrace) {
      try {
        sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
        print('Error sent to sentry.io: $error');
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
    },
  );
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