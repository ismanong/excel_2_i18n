import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:i18n_tools/pages/app_main_page.dart';
import 'dart:math' as math;
import 'package:window_size/window_size.dart' as window_size;
import 'package:path_provider_windows/path_provider_windows.dart';

import 'RunConfig.dart';

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
      // final frame = Rect.fromLTWH(left, top, width, height);
      final frame = Rect.fromLTWH(0, top, width, height);
      window_size.setWindowFrame(frame);
      window_size.setWindowMinSize(Size(0.8 * width, 0.8 * height));
      window_size.setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      window_size
          .setWindowTitle('Flutter Testbed on ${Platform.operatingSystem}');
    }
  });
  initDirectories();
  runApp(MyApp());
}

Future<void> initDirectories() async {
  String? downloadsDirectory;
  String? appSupportDirectory;
  final PathProviderWindows provider = PathProviderWindows();
  try {
    downloadsDirectory = await provider.getDownloadsPath();
  } catch (exception) {
    downloadsDirectory = '无法获取下载目录: $exception';
  }
  try {
    appSupportDirectory = await provider.getApplicationSupportPath();
  } catch (exception) {
    appSupportDirectory = '无法获取应用支持目录: $exception';
  }
  RunConfig.outputDirectoryPath = downloadsDirectory ?? 'Unknown';
  RunConfig.appSupportDirectory = appSupportDirectory ?? 'Unknown';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Flutter去除右上角Debug标签
      title: '小蜜蜂小恐龙', //app多任务标签页的title 任务管理器中应用程序标题
      builder: BotToastInit(), // 初始化 bot_toast
      navigatorObservers: [
        BotToastNavigatorObserver(), // 初始化 bot_toast
        // NavigatorUtils.getInstance(),
      ],
      // routes: NavigatorUtils.configRoutes,
      // initialRoute: '/',
      home: AppMainPage(),
    );
  }
}
