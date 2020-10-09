import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonFunc {

  static writeFile(String saveFilePath, ByteData data) async {
    File saveFile = File(saveFilePath); // 需要保存的文件
    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
      saveFile.writeAsBytesSync(data.buffer.asUint8List(), flush: true);
    }
    // test---------------------------------
    int size = await saveFile.length();
    String sizeMb = '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
    print('图片大小：$sizeMb  图片路径：${saveFile.path}');
    // test---------------------------------end
    return saveFile.path;
  }

  static String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = '' +
        '${dateTime.year}-' +
        '${dateTime.month}-' +
        '${dateTime.day}_' +
        '${dateTime.hour}-' +
        '${dateTime.minute}-' +
        '${dateTime.second}_' +
        '${dateTime.millisecond}';
    return dateTimeString;
  }

  /// 暂时无用
//  Future<String> showImage(context) async {
//    if (!(await _checkPermission())) return null;
//    if (!(await checkPermission())) await requestPermission();

//    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
//    Directory directory;
//    if (Platform.isIOS) {
//    directory = await getTemporaryDirectory();
//    } else if (Platform.isAndroid) {
//      directory = await getExternalStorageDirectory();
//    }
//    String path = '${directory.path}/$directoryName';
//    await Directory(path).create(recursive: true);
//    String imgUrl = '$path/${formattedDate()}.png';
//    File(imgUrl).writeAsBytesSync(pngBytes.buffer.asInt8List());
//    File myFile = new File(imgUrl);
//    int size = await myFile.length();
//    String sizeMb = '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
//    print('图片大小：$sizeMb  图片路径：$imgUrl');
//    return imgUrl;

//    return showDialog<Null>(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('$imgUrl'),
//          content: Image.memory(Uint8List.view(pngBytes.buffer)),
//        );
//      },
//    );
//  }

//  Future<bool> _checkPermission() async {
//    if (Platform.isAndroid) {
//       PermissionStatus permission = await PermissionHandler()
//           .checkPermissionStatus(PermissionGroup.storage);
//       if (permission != PermissionStatus.granted) {
//         Map<PermissionGroup, PermissionStatus> permissions =
//             await PermissionHandler()
//                 .requestPermissions([PermissionGroup.storage]);
//         if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//           return true;
//         } else {
//           print('Permission 请求失败!');
//           return false;
//         }
//       } else {
//         return true;
//       }
//    }
//    return false;
//  }

  static showToast(String msg, {String position = 'top'}) {
    BotToast.showText(
      text: msg,
      align: Alignment.center,
    );
  }

  static checkNetwork() async {
    /*
    * 如果手机连接的WiFi并没有接入互联网，那么这台手机虽然连上了WiFi，
    * 但是根本就不能上网（例如将路由器的Wan 口网线拔掉）
    * 检查网络是否可以访问 http://captive.apple.com/
    * */
    // const String url = 'http://captive.apple.com/';
    // String response = await HttpDio.reqSite(url);
    // bool bo = response == null ? false : response.contains('Success');
    // return bo;
  }

  static Future<Map> jsonToMap(jsonStr) async {
    Map jsonMap = jsonDecode(jsonStr);
    return jsonMap;
  }
}
