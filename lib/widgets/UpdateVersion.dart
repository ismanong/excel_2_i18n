// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
// class UpdateVersion {
//   final BuildContext context;
//   UpdateVersion(this.context) {
//     _getLatestVersionData();
//   }
//
//   String latestVersion;
//   bool _isForce;
//   String _downloadUrl;
//   String _introduce;
//   String _latestVersion;
//   // static String latestVersion;
//
//   OverlayEntry overlayEntry;
//   GlobalKey _globalKey = GlobalKey();
//
//   // 获取dom json
//   static reqSite(url) async {
//     try {
//       var response = await Dio(BaseOptions(
//         connectTimeout: 5000, // 连接服务器超时时间，单位是毫秒.
//         receiveTimeout: 5000, // 接收超时时间
//       )).get(url);
//       // var encoded = utf8.encode(response.data);
//       // var decoded = utf8.decode(encoded);
//       return jsonDecode(response.data);
//     } catch (e) {
//       return print(e);
//     }
//   }
//
//   Future _getLatestVersionData() async {
//     Map res = await reqSite(
//         'http://apps-qa.gtarcade.com/app-download-assets/latest_version.json');
//     print(res);
//     if (Platform.isAndroid) {
//       _isForce = res['android_force'];
//       _downloadUrl = res['android_download_url'];
//       _introduce = res['android_introduce'];
//       _latestVersion = res['android_version'];
//     } else if (Platform.isIOS) {
//       _isForce = res['ios_force'];
//       _downloadUrl = res['ios_download_url'];
//       _introduce = res['ios_introduce'];
//       _latestVersion = res['ios_version'];
//     }
//     showIndicator();
//     updateIndicator();
//   }
//
//   Future<bool> _listenerBack() {
//     //监听左上角返回和实体返回
//     return Future.value(false);
//   }
//
//   bool showLock = false; // OverlayEntry 的锁 防止多层报错
//   void showIndicator() {
//     if (showLock == true) return;
//     showLock = true;
//     overlayEntry = OverlayEntry(
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () => _listenerBack(),
//           child: Positioned(
//             top: 0,
//             left: 0.0,
//             right: 0.0,
//             bottom: 0,
//             child: Scaffold(
//               backgroundColor: Colors.red,
//               body: UpdateVersionUI(),
//             ),
//           ),
//         );
//       },
//     );
//     Overlay.of(context).insert(overlayEntry);
//   }
//
//   // 更新OverlayEntry
//   void updateIndicator() {
//     overlayEntry.markNeedsBuild();
//   }
//
//   void hideIndicator() {
//     overlayEntry.remove();
//     showLock = false;
//   }
// }
//
// class UpdateVersionUI extends StatelessWidget {
//   final String imageUrl;
//   final bool isDownload;
//   const UpdateVersionUI({Key key, this.imageUrl, this.isDownload}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {},
//       child: Container(
//         alignment: Alignment.center,
//         child: Text('currentItem.name'),
//       ),
//     );
//   }
// }
